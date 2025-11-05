// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? mapController;
//   final LatLng _center = const LatLng(23.8103, 90.4125); // Dhaka default
//   final Set<Marker> _markers = {};
//   bool _loading = true;
//   bool _locationGranted = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkPermission();
//   }

//   Future<void> _checkPermission() async {
//     final status = await Permission.location.request();
//     if (status.isGranted) {
//       setState(() {
//         _locationGranted = true;
//         _loading = false;
//       });
//     } else {
//       setState(() => _loading = false);
//       // Show dialog safely after build
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text("Permission Required"),
//             content: const Text(
//               "Location permission is required to show nearby disasters.",
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("OK"),
//               ),
//             ],
//           ),
//         );
//       });
//     }
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: const MarkerId('user_location'),
//           position: _center,
//           infoWindow: const InfoWindow(title: 'You are here'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorPrimary = const Color(0xFF1E88E5);

//     if (_loading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (!_locationGranted) {
//       return const Scaffold(
//         body: Center(child: Text("Location permission denied.")),
//       );
//     }

//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Map fills the screen
//             GoogleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: _center,
//                 zoom: 13.5,
//               ),
//               markers: _markers,
//               zoomControlsEnabled: false,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             ),

//             // Top info card
//             Positioned(
//               top: 20,
//               left: 16,
//               right: 16,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 14,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.95),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.location_on, color: Colors.blueAccent),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         "Nearby Disaster Locations",
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: colorPrimary,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Bottom info card
//             Positioned(
//               bottom: 20,
//               left: 16,
//               right: 16,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.warning_amber_rounded,
//                       color: Colors.redAccent,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         "No active disaster alerts near your area.",
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
