import 'package:dissaster_mgmnt_app/view/home_screen/presentation/map/disasterdistence.dart';
import 'package:dissaster_mgmnt_app/view/home_screen/riverpod/googlemap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Map View
          Positioned.fill(
            child: Consumer(
              builder: (_, ref, _) {
                final googleMapNotifier = ref.read(googleMapProvider.notifier);
                final googleMapState = ref.watch(googleMapProvider);
                return googleMapState.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: GoogleMap(
                          padding: EdgeInsets.only(top: 45, right: 20),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          compassEnabled: true,
                          fortyFiveDegreeImageryEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            controller.setMapStyle(googleMapState.mapStyle);
                          },
                          initialCameraPosition: CameraPosition(
                            target: googleMapState.currentLocation,
                            zoom: 16.5,
                          ),
                          markers: googleMapNotifier.zoos.map((zoo) {
                            return Marker(
                              markerId: MarkerId(zoo.name),
                              position: LatLng(zoo.latitude, zoo.longitude),
                              infoWindow: InfoWindow(title: 'Zoo Location'),
                              icon: googleMapState.customIconFuture!,
                            );
                          }).toSet(),

                          // {
                          //   Marker(
                          //
                          //   ),
                          //
                          // },
                        ),
                      );
              },
            ),
          ),

          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: Disasterdistence(),
            ),
          ),
        ],
      ),
    );
  }
}
