import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Notifier for SOS button + messaging
final sosProvider =
    StateNotifierProvider<SosNotifier, AsyncValue<List<Map<String, dynamic>>>>(
      (ref) => SosNotifier(),
    );

final sosAlertsProvider = StreamProvider.autoDispose<List<SOSAlert>>((ref) {
  final _firestore = FirebaseFirestore.instance;
  return _firestore
      .collection('sos_alerts')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        List<SOSAlert> alerts = [];
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final uid = data['uid'] as String?;
          final latitude = data['latitude'] as double?;
          final longitude = data['longitude'] as double?;
          final timestamp = data['timestamp'] as Timestamp?;

          // Get user email
          String userEmail = 'Unknown';
          if (uid != null) {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();
            userEmail = userDoc.data()?['email'] ?? 'Unknown';
          }

          // Get address from lat/lng
          String address = '';
          if (latitude != null && longitude != null) {
            try {
              final placemarks = await placemarkFromCoordinates(
                latitude,
                longitude,
              );
              if (placemarks.isNotEmpty) {
                final p = placemarks.first;
                address =
                    "${p.name}, ${p.locality}, ${p.postalCode}, ${p.country}";
              }
            } catch (e) {
              address = "Unknown location";
            }
          }

          alerts.add(
            SOSAlert(
              userEmail: userEmail,
              latitude: latitude,
              longitude: longitude,
              timestamp: timestamp?.toDate(),
              address: address,
            ),
          );
        }
        return alerts;
      });
});

class SosNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  SosNotifier() : super(const AsyncValue.data([])) {
    _listenToChats();
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Current user UID
  String get currentUserId => _auth.currentUser?.uid ?? '';

  /// Send SOS with current location
  Future<void> sendSOS() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _firestore.collection('sos_alerts').add({
        'uid': user.uid,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add chat message
      await _firestore.collection('chats').add({
        'text': "🚨 ${user.email ?? 'Someone'} triggered an SOS!",
        'senderId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Listen to live chat messages
  void _listenToChats() {
    _firestore
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
          final messages = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'text': data['text'] ?? '',
              'senderId': data['senderId'] ?? '',
              'timestamp': data['timestamp'],
            };
          }).toList();
          state = AsyncValue.data(messages);
        });
  }

  /// Send a new message
  Future<void> sendMessage(String msg) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('chats').add({
      'text': msg,
      'senderId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

/// SOS Alert model for Rescue screen
class SOSAlert {
  final String userEmail;
  final double? latitude;
  final double? longitude;
  final DateTime? timestamp;
  final String address;

  SOSAlert({
    required this.userEmail,
    this.latitude,
    this.longitude,
    this.timestamp,
    required this.address,
  });
}
