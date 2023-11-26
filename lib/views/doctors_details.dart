// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:medical_care_app/views/wlcome_page.dart';
import 'package:medical_care_app/widgets/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../view_model/auth.dart';
import '../widgets/location.dart';
import 'HaveAppointment.dart';
import 'chat.dart';
import 'map.dart';

class Details extends StatefulWidget {
  final Map<dynamic, dynamic> model;

  Details({required this.model});

  @override
  State<Details> createState() => _DetailsState(model: model);
}

class _DetailsState extends State<Details> {
  final Map<dynamic, dynamic> model;
  var RoomInfo;
  bool roomReady = false;
  bool isLoading = false;

  _DetailsState({required this.model});

  @override
  Widget build(BuildContext context) {
    var rating = model["raters"];
    List<dynamic> lovers = model["lovers"];
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    print(user?.email);
    double faverate = 0;
    if (lovers.contains(user?.email)) {
      faverate = 1;
    }
    final stars = (rating.values.reduce((value, element) => value + element)) /
        rating.length;
    Timestamp startTime = model['workTime'];
    DateTime dateTime = startTime.toDate();
    DateFormat StartTimeFormat = DateFormat('hh:mm a', 'ar_SA');
    String workTime = StartTimeFormat.format(dateTime);

    Timestamp EndTime = model['leaveTime'];
    DateTime EndDateTime = EndTime.toDate();
    DateFormat EndtimeFormat = DateFormat('hh:mm a', 'ar_SA');
    String leaveTime = EndtimeFormat.format(EndDateTime);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Scaffold(
          body: ListView(
            children: [
              Container(
                height: 270,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      // Adjust the border radius as needed
                      child: (model['image'] == '')
                          ? Image.asset('assets/images/doctor (10).png')
                          : Image.network(
                              model['image'],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Get.find<Auth>().user == null) {
                          Get.to(const Welcome_page());
                        } else {
                          RatingDialog(context);
                        }
                      },
                      child: Container(
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: RatingBar.builder(
                        initialRating: faverate,
                        itemBuilder: (context, index) => FaIcon(
                          Icons.favorite,
                          color: Get.find<Auth>().user == null
                              ? Colors.grey
                              : Colors.red,
                        ),
                        itemCount: 1,
                        allowHalfRating: false,
                        itemSize: 25.0,
                        unratedColor: Colors.grey[300],
                        onRatingUpdate: (double value) {
                          if (Get.find<Auth>().user == null) {
                            setState(() {
                              faverate = 0;
                            });
                            Get.to(const Welcome_page());
                          } else {
                            if (value == 1) {
                              updateUser(true, model['doctorID']);
                            } else if (value == 0) {
                              updateUser(false, model['doctorID']);
                            }
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: (model['email'] == user?.email)
                                    ? Colors.grey
                                    : const Color.fromRGBO(0, 185, 255, 1),
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                                onPressed: () async {
                                  if (model['email'] == user?.email) {
                                    Get.snackbar(
                                      icon: const Icon(Icons.error),
                                      ' لايمكن انشاء محادثه ',
                                      'لايمكنك انشاء محادثة مع نفسك ',
                                      colorText: Colors.black,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                  else if (Get.find<Auth>().user == null){
                                    Get.snackbar(
                                      icon: const Icon(Icons.error),
                                      ' لايمكن انشاء محادثه ',
                                      'قم بتسجيل الدخول لتتمكن من الدردشة مع الطبيب ',
                                      colorText: Colors.black,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    Get.to(const Welcome_page());
                                  }
                                  else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await setUpRoom();
                                    setState(() {
                                      isLoading = false;
                                    });
                                    print(RoomInfo);
                                    print(roomReady);
                                    if (roomReady == false) {
                                      Get.snackbar(
                                        icon: const Icon(Icons.error),
                                        'خطاء غير متوقع',
                                        'خطا في تجهيز غرفه المحتدثة ',
                                        colorText: Colors.black,
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    } else {
                                      print(RoomInfo);
                                      Get.to(Chat(
                                        roomData: RoomInfo,
                                      ));
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.chat_outlined,
                                  color: Colors.white,
                                ))),
                        const SizedBox(width: 50),
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 197, 105, 1),
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                                onPressed: () {
                                  launchPhoneApp(model['phoneNumber']);
                                },
                                // launchPhoneApp(model['phoneNumber']),
                                icon: const Icon(
                                  Icons.call,
                                  color: CupertinoColors.white,
                                )))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                height: 370,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      right: 15,
                      left: 15,
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 40,
                          left: 15,
                          right: 15,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.grey,
                              blurRadius: 7,
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          height: 240,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  'د. ${model['name']}',
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(' ${model['title']}',
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 11)),
                              ),
                              const SizedBox(height: 10),
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
                                      "${model['speciality']}",
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
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
                                      "${model['location']}",
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    var userLocation =
                                        await GetLocation().getLocation();
                                    setState(() {
                                      isLoading = false;
                                    });
                                    try{
                                      Get.to(ViewMap(
                                        doctorLocation: LatLng.LatLng(
                                            model['DoctorLatitude'],
                                            model['DoctorLongitude']),
                                        userLocation: userLocation,
                                      ));
                                    }catch(e){
                                      showErrorSnackbar('حصل خطا','حصل خطا اثنا جلب بيانات الموقع يرجئ مراجعة فريق الدعم');
                                    }

                                  },
                                  child: Container(
                                    width: 200,
                                    margin: EdgeInsets.only(
                                      top: 20,
                                      right:
                                          (MediaQuery.of(context).size.width -
                                                  270) /
                                              2,
                                    ),
                                    padding: const EdgeInsets.only(
                                        right: 45, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/pin.png",
                                          height: 25,
                                          width: 25,
                                        ),
                                        const SizedBox(width: 5),
                                        const Text("عرض الموقع",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: (MediaQuery.of(context).size.width - 148) / 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.grey,
                              blurRadius: 7,
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.only(
                          right: 20,
                          bottom: 10,
                          top: 10,
                          left: 20,
                        ),
                        margin: const EdgeInsets.all(10),
                        child: const Text(
                          'معلومات الطبيب',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    ),
                    isLoading
                        ? Positioned(
                            child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20)),
                              width: 120.0,
                              height: 120.0,
                              child: const Center(
                                child: SpinKitSpinningLines(
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ))
                        : Container(),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.grey,
                      blurRadius: 7,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.grey,
                            blurRadius: 7,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(7),
                            topLeft: Radius.circular(7)),
                      ),
                      padding: const EdgeInsets.only(
                        right: 20,
                        bottom: 10,
                        top: 10,
                        left: 20,
                      ),
                      child: const Center(
                        child: Text(
                          'الايام المتاحة',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    ),
                    DaysAvailable(model['available']),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7),
                            bottomRight: Radius.circular(7)),
                        color: Color.fromRGBO(0, 185, 255, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('اوقات الدوام:',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '   ${workTime}  الى  ${leaveTime}   ',
                            style: const TextStyle(
                                color: CupertinoColors.white, fontSize: 18),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    right: 15, left: 15, top: 40, bottom: 20),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.grey,
                      blurRadius: 7,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.grey,
                            blurRadius: 7,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.only(
                        right: 20,
                        bottom: 10,
                        top: 10,
                        left: 20,
                      ),
                      child: const Center(
                        child: Text(
                          'نبذه عن الطبيب',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(20),
                        child: Text(model['description'])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${model['price']} ريال ',
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width - 250,
              child: TextButton(
                onPressed: () {
                  if (Get.find<Auth>().user == null) {
                    Get.to(const Welcome_page());
                  } else {
                    Get.to(HaveAppointment(DoctorInfo: model));
                  }
                },
                child: const Text(
                  'احجز الان',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
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
    return IntrinsicHeight(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: available.length, // Number of items in the grid
          itemBuilder: (BuildContext context, int index) {
            Color? color;
            String valid = '';
            if (available[index] == 1) {
              color = const Color.fromRGBO(0, 185, 255, 1);
              valid = "متاح";
            } else if (available[index] == 0) {
              color = Colors.redAccent;
              valid = "غير متاحة";
            }
            return Container(
                height: 50,
                margin: const EdgeInsets.only(left: 5, top: 10, right: 5),
                padding: const EdgeInsets.only(bottom: 1.7),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 9,
                        offset: const Offset(0, 0),
                        color: Colors.grey.shade400)
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: CupertinoColors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: (MediaQuery.of(context).size.width - 10) / 4,
                      padding: const EdgeInsets.only(top: 7, bottom: 7),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Text(
                        Days[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('${valid}')
                  ],
                ));
          },
        ),
      ),
    );
  }

  launchPhoneApp(phoneNumber) async {
    final url = 'tel:$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch phone app');
    }
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
      print(DoctordocumentId);
      print('____________-----------');
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

  Future<void> setUpRoom() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    Map<String, dynamic> mainData = {};
    for (final DocumentSnapshot mainDocumentSnapshot in querySnapshot.docs) {
      if (mainDocumentSnapshot.exists) {
        mainData = await mainDocumentSnapshot.data() as Map<String, dynamic>;
      }
    }

    if ((mainData['email1'] == user?.email &&
            mainData['email2'] == model['email']) ||
        (mainData['email1'] == model['email'] &&
            mainData['email2'] == user?.email)) {
      print('here1');

      roomReady = true;
      RoomInfo = mainData;

      return;
    } else {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('rooms');
      DocumentReference documentRef = collection.doc();
      String newDocumentId = documentRef.id;
      var userData;
      final QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: user?.email)
          .get();

      for (final DocumentSnapshot documentSnapshot in userQuerySnapshot.docs) {
        if (documentSnapshot.exists) {
          userData = documentSnapshot.data() as Map<String, dynamic>;
        }
      }

      Map<String, dynamic> data = {
        'LastMessageTime': Timestamp.fromDate(DateTime.now()),
        'RoomID': newDocumentId,
        'Status': 'active',
        'careatedAt': Timestamp.fromDate(DateTime.now()),
        'email1': user?.email,
        'email2': model['email'],
        'image1': userData['Image'],
        'image2': model['image'],
        'lastMessage': 'no Messages yet!',
        'messagesNO': 0,
        'name1': userData['name'],
        'name2': model['name'],
      };
      print('here2');
      await documentRef.set(data).then((_) {
        roomReady = true;
        RoomInfo = data;
        print('Document added with ID: $newDocumentId');

        // Further operations with the document
      }).catchError((error) {
        print('Failed to add document: $error');
        // Handle any errors
      });
      return;
    }
  }

  void RatingDialog(context) {
    double stars = 0.0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding:
            const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Container(
          // إضافة عنصر عنوان الحوار
          decoration: BoxDecoration(
            // تعيين خصائص العنوان
            color: primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // تعيين محاذاة العناصر
              children: [
                SizedBox(width: 10),
                Text('قيم طبيبك', // إضافة عنصر النص
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
        content: SizedBox(
          height: 260,
          child: Column(
            children: [
              Image.asset('assets/images/happy.png', width: 150),
              const Text('هل تود تقييم خدمات هذ الطبيب؟'),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: RatingBar.builder(
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 30.0,
                  initialRating: 0,
                  minRating: 0,
                  unratedColor: Colors.grey[300],
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  onRatingUpdate: (double value) {
                    stars = value;
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    Query query = firestore
                        .collection('doctors')
                        .where('doctorID', isEqualTo: model['doctorID']);
                    query.get().then((querySnapshot) {
                      if (querySnapshot.size > 0) {
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        final User? user = _auth.currentUser;
                        DocumentSnapshot? documentSnapshot =
                            querySnapshot.docs[0];

                        if (documentSnapshot != null &&
                            documentSnapshot.exists) {
                          Map<String, dynamic>? dataMap =
                              documentSnapshot.data() as Map<String, dynamic>?;

                          if (dataMap != null &&
                              dataMap.containsKey('raters')) {
                            Map<String, dynamic>? ratersMap =
                                dataMap['raters'] as Map<String, dynamic>?;
                            if (ratersMap != null) {
                              ratersMap['${user?.email}'] = stars;

                              // Update the document with the updated 'raters' map
                              documentSnapshot.reference
                                  .update({'raters': ratersMap}).then((value) {
                                setState(() {});
                                print('Map item updated successfully.');
                              }).catchError((error) {
                                print('Failed to update map item: $error');
                              });
                            } else {
                              print(
                                  "The 'raters' map does not exist in the document.");
                            }
                          } else {
                            print(
                                "The 'raters' field does not exist in the document.");
                          }
                        } else {
                          print('The document does not exist.');
                        }
                      } else {
                        print('Document not found.');
                      }
                    }).catchError((error) {
                      print('Failed to fetch documents: $error');
                    });
                  },
                ),
              )
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                // إضافة زر النص
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('إلغاء', style: TextStyle(color: primaryColor)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {});

                  Navigator.of(context).pop();
                },
                child: const Text('تقييم', // إضافة عنصر النص
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
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
