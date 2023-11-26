// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:medical_care_app/widgets/constants.dart';

class ViewMap extends StatefulWidget {
  final LatLng userLocation;
  final LatLng doctorLocation;

  const ViewMap({required this.userLocation, required this.doctorLocation});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  List<LatLng> polylineCoordinates = [];

  late LatLng userLocation;
  late LatLng doctorLocation;

  void initState() {
    super.initState();
    doctorLocation = widget.doctorLocation;
    userLocation = widget.userLocation;
    polylineCoordinates = [userLocation, doctorLocation];
  }

  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('عرض الخريطة'),
        actions: [
          ElevatedButton(
            onPressed: () {
              mapController.move(
                  LatLng(userLocation.latitude, userLocation.longitude), 14);
            },
            child: Image.asset(
              'assets/images/compass.png',
              height: 35,
              width: 35,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(userLocation.latitude, userLocation.longitude),
              zoom: 14,
              maxZoom: 18,
              minZoom: 3,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(

                    width: 90, height: 90,
                    point: LatLng(
                        userLocation.latitude, userLocation.longitude),
                    builder: (ctx) =>
                        Column(
                          children: [
                            Container(
                              padding:EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),color:Colors.white),child: Text('موقعي'),),
                            Image.asset('assets/images/map.png',width: 50,height: 50,),
                          ],
                        ),
                  ),
                  Marker(
                    height: 90,
                    width: 90,
                    point: LatLng(
                        doctorLocation.latitude, doctorLocation.longitude),
                    builder: (ctx) =>
                        Container(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/hospital.png',width: 50,height: 50, ),

                              Container(
                                padding:EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),color:Colors.white),child: Text('موقع الطبيب'),),
                            ],
                          ),
                        ),
                  ),
                ],
              ),
              PolylineLayerOptions(
                polylines: [
                  Polyline(
                    points: polylineCoordinates,
                    color: Colors.red,
                    strokeWidth: 3.0,
                  ),
                ],
              ),
            ],
            mapController: mapController,
          ),
        ],
      ),
    );
  }
}