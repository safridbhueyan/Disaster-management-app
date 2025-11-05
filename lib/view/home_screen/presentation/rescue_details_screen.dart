import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RescueDetailScreen extends StatelessWidget {
  final Map<String, dynamic> alertData;
  const RescueDetailScreen({super.key, required this.alertData});

  @override
  Widget build(BuildContext context) {
    // Safe timestamp parsing
    final timestamp = alertData['timestamp'] as Timestamp?;
    final dateStr = timestamp != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate())
        : "Unknown time";

    final userName = alertData['email'] ?? alertData['uid'] ?? "Unknown";

    final latitude = alertData['latitude']?.toString() ?? "N/A";
    final longitude = alertData['longitude']?.toString() ?? "N/A";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("SOS Details", style: GoogleFonts.poppins()),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User: $userName",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Location: ($latitude, $longitude)",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text("Time: $dateStr", style: GoogleFonts.poppins(fontSize: 14)),
            const SizedBox(height: 20),
            Text(
              "Disaster Info (dummy for now):",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "⚠️ Flood reported in this area.\nStay safe and await rescue.",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
