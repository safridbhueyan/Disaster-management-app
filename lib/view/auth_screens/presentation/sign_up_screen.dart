import 'package:dissaster_mgmnt_app/view/auth_screens/Riverpod/auth_provider.dart';
import 'package:dissaster_mgmnt_app/view/auth_screens/presentation/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final authState = ref.watch(authControllerProvider);
    final colorPrimary = const Color(0xFF1E88E5);

    ref.listen<AsyncValue<User?>>(authControllerProvider, (prev, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            ); // Go back to Sign In
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account created successfully!")),
            );
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err.toString())));
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.shield_moon_outlined, size: 70, color: colorPrimary),
                const SizedBox(height: 12),
                Text(
                  "DisasterLink",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colorPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Join to stay safe and informed",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 36),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: nameCtrl,
                        label: "Full Name",
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: emailCtrl,
                        label: "Email",
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: passwordCtrl,
                        label: "Password",
                        icon: Icons.lock_outline,
                        obscure: true,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    ref
                                        .read(authControllerProvider.notifier)
                                        .signUp(
                                          emailCtrl.text.trim(),
                                          passwordCtrl.text.trim(),
                                          nameCtrl.text.trim(),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: authState.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInScreen(),
                              ),
                            ),
                            child: Text(
                              "Sign In",
                              style: GoogleFonts.poppins(
                                color: colorPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (val) => val!.isEmpty ? "Enter $label" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
