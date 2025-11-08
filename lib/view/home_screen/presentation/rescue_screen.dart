import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dissaster_mgmnt_app/view/home_screen/riverpod/sos_provider.dart';

class RescueScreen extends ConsumerWidget {
  const RescueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sosAlerts = ref.watch(sosAlertsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("SOS Alerts", style: GoogleFonts.poppins()),
        backgroundColor: Colors.redAccent,
      ),
      body: sosAlerts.when(
        data: (alerts) {
          if (alerts.isEmpty) {
            return Center(
              child: Text(
                "No SOS signals yet",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              final dateStr = alert.timestamp != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(alert.timestamp!)
                  : "Unknown time";

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            alert.userEmail,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Coordinates
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "(${alert.latitude ?? 'N/A'}, ${alert.longitude ?? 'N/A'})",
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Address
                      Row(
                        children: [
                          const Icon(Icons.place, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              alert.address,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Timestamp
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateStr,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Status tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "SOS Signal Active",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: ${err.toString()}")),
      ),
    );
  }
}
