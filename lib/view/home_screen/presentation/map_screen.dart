import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "🗺️ Map Screen (Coming Soon)",
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700]),
      ),
    );
  }
}
