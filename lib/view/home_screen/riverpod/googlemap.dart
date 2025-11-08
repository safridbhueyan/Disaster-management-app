import 'package:dissaster_mgmnt_app/model/zoo_model.dart';
import 'package:dissaster_mgmnt_app/view/home_screen/riverpod/map_riverpod.dart';
import 'package:dissaster_mgmnt_app/view/home_screen/riverpod/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final googleMapProvider =
    StateNotifierProvider<GoogleMapNotifier, GoogleMapState>(
      (ref) => GoogleMapNotifier(),
    );

class GoogleMapNotifier extends StateNotifier<GoogleMapState> {
  GoogleMapNotifier() : super(GoogleMapState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });
  }

  // List of zoos
  List<ZooModel> zoos = [
    ZooModel(name: 'Zoo A', latitude: 22.9958, longitude: 89.8220),
    ZooModel(name: 'Zoo B', latitude: 22.9965, longitude: 89.8250),
    ZooModel(name: 'Zoo C', latitude: 22.9980, longitude: 89.8180),
    ZooModel(name: 'Zoo D', latitude: 22.9940, longitude: 89.8195),
    ZooModel(name: 'Zoo E', latitude: 22.9930, longitude: 89.8210),
  ];

  /// Function to get current location
  Future<void> getCurrentLocation() async {
    try {
      /// Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      state = state.copyWith(
        currentLocation: LatLng(position.latitude, position.longitude),
      );
      _findNearestZoo(position.latitude, position.longitude);
    } catch (e) {
      /// Handle location error
      state = state.copyWith(errorMessage: "Unable to fetch location");
    }
  }

  Future<void> _loadCustomMarker() async {
    final customIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(48, 48)),
      "assets/dis.bmp",
    );
    state = state.copyWith(customIconFuture: customIcon);
  }

  // Function to calculate nearest zoo
  Future<void> _findNearestZoo(double userLat, double userLon) async {
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

    final mapStyle = await rootBundle.loadString('assets/map_style.json');

    state = state.copyWith(
      nearestZoo: closestZoo,
      distanceToNearestZoo: closestDistance.roundToDouble() / 1000,
      mapStyle: mapStyle,
    );

    await _loadCustomMarker();

    state = state.copyWith(isLoading: false);
  }
}
