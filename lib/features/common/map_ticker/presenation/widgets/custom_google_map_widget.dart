import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMapWidget extends StatelessWidget {
  final CameraPosition initialPosition;
  final LatLng markerPosition;
  final Function(LatLng)? onTap;

  const CustomGoogleMapWidget({
    super.key,
    required this.initialPosition,
    required this.markerPosition,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: initialPosition,
      onTap: onTap,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      markers: {
        Marker(
          markerId: const MarkerId('selected'),
          position: markerPosition,
          draggable: true,
          onDragEnd: (newPosition) {
            onTap?.call(newPosition);
          },
        ),
      },
    );
  }
}
