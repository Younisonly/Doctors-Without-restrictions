// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:medical_care_app/views/wlcome_page.dart';
import '../view_model/auth.dart';
import '../widgets/constants.dart';
import '../widgets/location.dart';
import 'doctors_details.dart';
import 'map.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('المفضلة'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .where('lovers', arrayContains: user?.email)
              .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data()
                          as Map<dynamic, dynamic>;
                      return Column(
                        children: [
                          doctorsList(data),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    itemCount: snapshot.data!.docs.length);
          }),
    );
  }

  Widget DaysAvailable(List available) {
    List Days = [
      'السبت',
      'الاحد',
      'الاثنين',
      'الثلاثاء',
      'الاربعاء',
      'الخميس',
      'الجمعة'
    ];
    return SizedBox(
      height: 250,
      child: ListView.builder(
          itemBuilder: (context, index) {
            Color? color;
            if (available[index] == 1) {
              color = const Color.fromRGBO(0, 185, 255, 1);
            } else if (available[index] == 0) {
              color = Color.fromRGBO(199, 47, 47, 1);
            }
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 1.7, bottom: 1.7),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: color,
                  border: Border.all(color: Colors.white, width: 1)),
              child: Text(
                Days[index],
                style: const TextStyle(color: CupertinoColors.white),
              ),
            );
          },
          itemCount: available.length),
    );
  }

  Widget doctorsList(data) {
    print(data);
    print('0000000000000000000000000000000000000mm');
    if (data != []) {
      var rating = data?["raters"];
      List<dynamic> lovers = data?["lovers"];
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;
      double faverate = 1;

      final stars =
          (rating.values.reduce((value, element) => value + element))/rating.length;
      if (data['status'] == 'active') {
        return GestureDetector(
          onTap: () {
            Get.to(Details(model: data));
          },
          child: Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 8),
              height: 250,
              width: 450,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 7,
                    offset: Offset(0, 0), // موقع الظل
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white38,
                          radius: 40,
                          backgroundImage: (data['image'] == '')
                              ? AssetImage('assets/images/doctor (10).png')
                              : NetworkImage(data['image'])
                                  as ImageProvider<Object>?,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: RatingBarIndicator(
                            rating: stars,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 15.0,
                            unratedColor: Colors.grey[300],
                            direction: Axis.horizontal,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: RatingBar.builder(
                            initialRating: 1,
                            itemBuilder: (context, index) => const FaIcon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            itemCount: 1,
                            allowHalfRating: false,
                            itemSize: 25.0,
                            unratedColor: Colors.grey[300],
                            onRatingUpdate: (double value) {
                              if (Get.find<Auth>().user == null) {
                                Get.to(const Welcome_page());
                              } else {
                                if (value == 1) {
                                  updateUser(true, data['doctorID']);
                                } else if (value == 0) {
                                  updateUser(false, data['doctorID']);
                                  setState(() {});
                                }
                              }
                            },
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              try{
                                var userLocation =
                                    await GetLocation().getLocation();
                                Get.to(ViewMap(
                                  doctorLocation: LatLng.LatLng(
                                      data['DoctorLatitude'],
                                      data['DoctorLongitude']),
                                  userLocation: userLocation,
                                ));
                              }catch(e){
                                showErrorSnackbar('حصل خطا','حصل خطا اثنا جلب بيانات الموقع يرجى مراجعة فريق الدعم');
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/pin.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text("عرض الموقع",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              'د. ${data['name']}',
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(' ${data['title']}',
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 11)),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/medical.png",
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  "${data['speciality']}",
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/map.png",
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  "${data['city']}",
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/money.png",
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text("${data['price']} ريال ",
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 16)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          TextButton(
                              onPressed: () {
                                Get.to(Details(
                                  model: data,
                                ));
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(right: 30),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text('التفاصيل',
                                      style: TextStyle(
                                          color: CupertinoColors.white))))
                        ],
                      ),
                    ),
                  ),
                  Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  color: primaryColor),
                              padding: const EdgeInsets.only(
                                  right: 3, top: 3, left: 4),
                              child: const Text(
                                'الايام المتاحة',
                                style: TextStyle(color: CupertinoColors.white),
                              )),
                          Container(
                            width: 80,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: DaysAvailable(data['available']),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        );
      } else
        return SizedBox();
    }
    return SizedBox();
  }

  updateUser(favorite, DoctorID) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('Users');
      CollectionReference doctorCollection =
          FirebaseFirestore.instance.collection('doctors');
      QuerySnapshot DoctorquerySnapshot =
          await doctorCollection.where('doctorID', isEqualTo: DoctorID).get();
      print('____________-----------');

      DocumentSnapshot DocquerySnapshot = DoctorquerySnapshot.docs.first;
      String DoctordocumentId = DocquerySnapshot.id;
      if (favorite == true) {
        await doctorCollection.doc(DoctordocumentId).update({
          'lovers': FieldValue.arrayUnion([user?.email]),
        });

        await usersCollection.doc(user?.uid).update({
          'Favorite': FieldValue.arrayUnion([DoctorID]),
        });
      } else if (favorite == false) {
        await doctorCollection.doc(DoctordocumentId).update({
          'lovers': FieldValue.arrayRemove([user?.email]),
        });
        await usersCollection.doc(user?.uid).update({
          'Favorite': FieldValue.arrayRemove([DoctorID]),
        });
      }
    } catch (e) {
      print('something went wrong1:${e}');
    }
  }

  void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      icon: const Icon(Icons.error),
      title,
      message,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
