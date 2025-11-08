import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

/// Stream provider to listen to all SOS alerts
final sosAlertsProvider = StreamProvider.autoDispose<List<SOSAlert>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('sos_alerts')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        List<SOSAlert> alerts = [];

        for (var doc in snapshot.docs) {
          final data = doc.data();

          final email = data['email'] ?? 'Unknown';
          final lat = data['latitude'] as double?;
          final lng = data['longitude'] as double?;
          final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

          // Reverse-geocode location to address
          String address = 'Unknown location';
          if (lat != null && lng != null) {
            try {
              final placemarks = await placemarkFromCoordinates(lat, lng);
              if (placemarks.isNotEmpty) {
                final p = placemarks.first;
                address = "${p.name}, ${p.locality}, ${p.country}";
              }
            } catch (e) {
              address = 'Unknown location';
            }
          }

          alerts.add(
            SOSAlert(
              userEmail: email,
              latitude: lat,
              longitude: lng,
              timestamp: timestamp,
              address: address,
            ),
          );
        }

        return alerts;
      });
});

/// Notifier for sending SOS signals and messages
final sosProvider =
    StateNotifierProvider<SosNotifier, AsyncValue<List<Map<String, dynamic>>>>(
      (ref) => SosNotifier(),
    );

class SosNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  SosNotifier() : super(const AsyncValue.data([])) {
    _listenToChats();
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser?.uid ?? '';

  /// Send SOS with current location
  Future<void> sendSOS() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Save to Firestore
      await _firestore.collection('sos_alerts').add({
        'uid': user.uid,
        'email': user.email ?? 'Unknown',
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Optional: Notify in chat
      await _firestore.collection('chats').add({
        'text': "🚨 ${user.email ?? 'Someone'} triggered an SOS!",
        'senderId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Listen to live chat updates
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

  /// Send new chat message
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
