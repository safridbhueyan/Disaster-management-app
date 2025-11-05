import 'package:dissaster_mgmnt_app/view/home_screen/presentation/map_screens.dart';
import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'sos_screen.dart';
import 'rescue_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _screens = [MapScreen(), const SosScreen(), const RescueScreen()];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = const Color(0xFF1E88E5);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          height: 70,
          notchMargin: 8,
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.map_outlined,
                  color: _selectedIndex == 0 ? colorPrimary : Colors.grey,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: Icon(
                  Icons.group_outlined,
                  color: _selectedIndex == 2 ? colorPrimary : Colors.grey,
                ),
                onPressed: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => _onItemTapped(1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
