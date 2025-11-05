import 'package:dissaster_mgmnt_app/model/zoo_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapState {
  final LatLng currentLocation;
  final ZooModel? nearestZoo;
  final double distanceToNearestZoo;
  final bool isLoading;
  final String errorMessage;
  BitmapDescriptor? customIconFuture;
  String? mapStyle;

  GoogleMapState({
    this.currentLocation = const LatLng(0.0, 0.0),
    this.nearestZoo,
    this.distanceToNearestZoo = 0,
    this.isLoading = true,
    this.errorMessage = "",
    this.customIconFuture,
    this.mapStyle,
  });

  // factory GoogleMapState.initial() {
  //   return GoogleMapState(
  //     currentLocation: LatLng(0.0, 0.0),
  //     nearestZoo: ZooModel(name: 'Unknown', latitude: 0.0, longitude: 0.0),
  //     distanceToNearestZoo: 0.0,
  //     isLoading: true,
  //     errorMessage: '',
  //
  //   );
  // }

  /// update state by copying new value
  GoogleMapState copyWith({
    LatLng? currentLocation,
    ZooModel? nearestZoo,
    double? distanceToNearestZoo,
    bool? isLoading,
    String? errorMessage,
    BitmapDescriptor? customIconFuture,
    String? mapStyle,
  }) {
    return GoogleMapState(
      currentLocation: currentLocation ?? this.currentLocation,
      nearestZoo: nearestZoo ?? this.nearestZoo,
      distanceToNearestZoo: distanceToNearestZoo ?? this.distanceToNearestZoo,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      customIconFuture: customIconFuture ?? this.customIconFuture,
      mapStyle: mapStyle ?? this.mapStyle,
    );
  }
}
