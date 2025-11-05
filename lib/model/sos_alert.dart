import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

class SOSAlert {
  final String userEmail;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String address;

  SOSAlert({
    required this.userEmail,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.address,
  });
}

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
          final uid = data['uid'] as String;
          final lat = data['latitude'] as double;
          final lng = data['longitude'] as double;
          final timestamp = (data['timestamp'] as Timestamp).toDate();

          // Get user email
          String email = 'Unknown';
          final userDoc = await firestore.collection('users').doc(uid).get();
          email = userDoc.data()?['email'] ?? 'Unknown';

          // Get address
          String address = '';
          try {
            final placemarks = await placemarkFromCoordinates(lat, lng);
            if (placemarks.isNotEmpty) {
              final p = placemarks.first;
              address = "${p.name}, ${p.locality}, ${p.country}";
            }
          } catch (e) {
            address = "Unknown location";
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
