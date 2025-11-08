import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RescueDetailsScreen extends StatelessWidget {
  final dynamic alert; // You can replace dynamic with your SOS model type

  const RescueDetailsScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final dateStr = alert.timestamp != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(alert.timestamp!)
        : "Unknown time";

    return Scaffold(
      appBar: AppBar(
        title: Text("Rescue Details", style: GoogleFonts.poppins()),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User email
            Text(
              "Reported by:",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              alert.userEmail,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Coordinates
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  "Lat: ${alert.latitude}, Lng: ${alert.longitude}",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.home, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alert.address,
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Timestamp
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "Reported at: $dateStr",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "🚨 SOS Signal Active",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ),

            const Spacer(),

            // Action button (optional)
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.map),
                label: Text(
                  "View on Map",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                onPressed: () {
                  // TODO: Navigate to map screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Map screen coming soon...")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
