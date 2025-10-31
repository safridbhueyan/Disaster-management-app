import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  List<String> dummyChats = [
    "Help! I’m stuck near the bridge!",
    "We’re on the way 🚑",
    "Anyone else in this area?",
  ];

  late Timer _chatTimer;

  @override
  void initState() {
    super.initState();
    _startChatAnimation();
  }

  void _startChatAnimation() {
    _chatTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (dummyChats.length < 10) {
        setState(() {
          dummyChats.add(
            timer.tick % 2 == 0 ? "Rescue team approaching..." : "Stay safe!",
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _chatTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = const Color(0xFF1E88E5);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              "Emergency SOS",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorPrimary,
              ),
            ),
            const SizedBox(height: 30),

            // Glowing SOS Button
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 1.2),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                onEnd: () => setState(() {}),
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "🚨 SOS Alert Sent!",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                        duration: const Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "SOS",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Live Chat Section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: ListView.builder(
                  itemCount: dummyChats.length,
                  itemBuilder: (context, index) {
                    final isUser = index % 2 == 0;
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? colorPrimary.withOpacity(0.1)
                              : Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          dummyChats[index],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
