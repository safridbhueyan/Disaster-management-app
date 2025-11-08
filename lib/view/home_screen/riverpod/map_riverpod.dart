import 'package:dissaster_mgmnt_app/model/zoo_model.dart';
import 'package:dissaster_mgmnt_app/view/home_screen/riverpod/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// 🔹 Provider
final googleMapProvider =
    StateNotifierProvider<GoogleMapNotifier, GoogleMapState>(
      (ref) => GoogleMapNotifier(),
    );

// 🔹 Notifier
class GoogleMapNotifier extends StateNotifier<GoogleMapState> {
  GoogleMapNotifier() : super(GoogleMapState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });
  }

  // ✅ List of mock “zoos” (disaster zones)
  final List<ZooModel> zoos = [
    ZooModel(name: 'Zone A', latitude: 22.9958, longitude: 89.8220),
    ZooModel(name: 'Zone B', latitude: 22.9965, longitude: 89.8250),
    ZooModel(name: 'Zone C', latitude: 22.9980, longitude: 89.8180),
    ZooModel(name: 'Zone D', latitude: 22.9940, longitude: 89.8195),
    ZooModel(name: 'Zone E', latitude: 22.9930, longitude: 89.8210),
  ];

  /// ✅ Get current user location safely
  Future<void> getCurrentLocation() async {
    try {
      print("📍 Requesting location permission...");
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        print("❌ Location permission denied.");
        state = state.copyWith(
          errorMessage: "Location permission denied.",
          isLoading: false,
        );
        return;
      }

      print("✅ Fetching current location...");
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("📍 Current Location: ${position.latitude}, ${position.longitude}");

      state = state.copyWith(
        currentLocation: LatLng(position.latitude, position.longitude),
      );

      await _findNearestZoo(position.latitude, position.longitude);
    } catch (e) {
      print("❌ Location Error: $e");
      state = state.copyWith(
        errorMessage: "Unable to fetch location.",
        isLoading: false,
      );
    }
  }

  /// ✅ Load custom map marker
  Future<void> _loadCustomMarker() async {
    try {
      final customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        "assets/dis.bmp",
      );
      state = state.copyWith(customIconFuture: customIcon);
    } catch (e) {
      print("⚠️ Failed to load custom marker: $e");
    }
  }

  /// ✅ Find the nearest “zoo” (disaster zone)
  Future<void> _findNearestZoo(double userLat, double userLon) async {
    try {
      double closestDistance = double.infinity;
      ZooModel closestZoo = zoos[0];

      for (var zoo in zoos) {
        double distance = Geolocator.distanceBetween(
          userLat,
          userLon,
          zoo.latitude,
          zoo.longitude,
        );

        if (distance < closestDistance) {
          closestDistance = distance;
          closestZoo = zoo;
        }
      }

      String mapStyle = "";
      try {
        mapStyle = await rootBundle.loadString('assets/map_style.json');
      } catch (e) {
        print("⚠️ Map style not found, using default.");
      }

      await _loadCustomMarker();

      state = state.copyWith(
        nearestZoo: closestZoo,
        distanceToNearestZoo: closestDistance / 1000, // meters to km
        mapStyle: mapStyle,
        isLoading: false,
      );

      print(
        "✅ Nearest Zone: ${closestZoo.name}, ${closestDistance / 1000} km away",
      );
    } catch (e) {
      print("❌ Error finding nearest zoo: $e");
      state = state.copyWith(isLoading: false);
    }
  }
}
