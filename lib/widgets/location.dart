import 'package:latlong2/latlong.dart' as LatLng;
import 'package:location/location.dart';
// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

class GetLocation{


  Future<LatLng.LatLng> getLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service is disabled.');
      }
    }

    // Check location permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission not granted.');
      }
    }

    // Get the current location
    final currentLocation = await location.getLocation();
    final latLng = LatLng.LatLng(currentLocation.latitude!, currentLocation.longitude!);
    return latLng;  }
}