// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:medical_care_app/widgets/constants.dart';


class selectLocation extends StatefulWidget {
  final LatLng userLocation;

  const selectLocation({required this.userLocation});

  @override
  State<selectLocation> createState() => _selectLocationState();
}

class _selectLocationState extends State<selectLocation> {
  LatLng? chosenLocation;
  List<Marker> markers = [];
  Map<String,double> LatLong={};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('حدد موقع عيادتك'),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: // Declare a variable to store the chosen location

          FlutterMap(
        mapController: MapController(),
        options: MapOptions(
            center: LatLng(
                widget.userLocation.latitude, widget.userLocation.longitude),
            zoom: 14,
            maxZoom: 18,
            minZoom: 3,
            onTap: (tapPos, latLng) {
              setState(() {
                // Store the chosen location

                chosenLocation = latLng;
                LatLong['latitude']=chosenLocation!.latitude;
                LatLong['longitude']=chosenLocation!.longitude;
                markers.clear();
                markers.add(
                  Marker(
                    point: chosenLocation!,
                    builder: (ctx) => Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),
                );
              });
            }),
        layers: [
          // Add your desired tile layer
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
              markers: (markers.length <= -1)
                  ? [
                      Marker(
                          point: widget.userLocation,
                          builder: (ctx) => Icon(
                                Icons.location_on,
                                color: Colors.transparent,
                              ))
                    ]
                  : markers),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('تم'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () async {
          if(chosenLocation==null){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    titlePadding: const EdgeInsets.only(
                        left: 0, right: 0, top: 0, bottom: 30),
                    // تعيين هوامش العناصر داخل الحوار
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      // تعيين شكل الحوار
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Container(
                      // إضافة عنصر عنوان الحوار
                      decoration: BoxDecoration(
                        // تعيين خصائص العنوان
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // تعيين محاذاة العناصر
                          children: [
                            SizedBox(width: 10),
                            Text('لم يتم تحديد موقع', // إضافة عنصر النص
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/doctor (2).png', width: 120),
                        Text('الرجاء تحديد موقع للمتابعه ')
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Container(
                            width: 90,
                            margin: EdgeInsets.symmetric(horizontal: 80),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                                  'حسنا',
                                  style: TextStyle(color: Colors.white),
                                ))),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ]);
              },
            );
          }
          else {

            Get.back(result: LatLong);
          }

        },
      ),
    );
  }
}
