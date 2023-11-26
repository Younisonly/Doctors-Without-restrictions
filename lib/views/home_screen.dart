// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:medical_care_app/views/wlcome_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../view_model/Controller.dart';
import '../view_model/auth.dart';
import '../view_model/screens_view_model.dart';
import '../widgets/constants.dart';
import '../widgets/custom_text.dart';
import 'SideBar.dart';
import 'doctors.dart';
import 'doctors_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Sidebar(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30.0),
              ),
            ),
            title: const Text('اطباء بلا قيود'),
            centerTitle: true,
            backgroundColor: primaryColor,
          ),
        ),

        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, left: 1, right: 20),
              child: Column(
                children: [
                  _listViewCategory(),
                  const ADs(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "الاحدث: ",
                        color: Colors.black,
                      ),
                      GetBuilder<ScreenViewModel>(
                        init: ScreenViewModel(),
                        builder: (controller) => TextButton(
                            onPressed: () {
                              category="الكل";
                              // controller.currentScreen = Doctors();
                              controller.changeSelectedValue(0);
                              Get.offAll(ControlView());
                            },
                            child: Container(
                              width: 50,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                  child: Text(
                                'الكل',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  latest()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listViewCategory() {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Specialties').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index].data()
                      as Map<String, dynamic>?;
                  if (data != null) {
                    return GetBuilder<ScreenViewModel>(
                      init: ScreenViewModel(),
                      builder: ((controller) => GestureDetector(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey.shade100,
                                ),
                                height: 60,
                                width: 60,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(data['image']),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              CustomText(
                                text: data['name'],
                                fontSize: 12,
                              ),
                            ],
                          ),
                          onTap: () {
                            category=data['name'];
                            controller.changeSelectedValue(0);
                            Get.offAll( ControlView());
                          })),
                    );
                  } else {
                    return const Placeholder();
                  }
                },
                separatorBuilder: (context, index) => const SizedBox(
                  width: 20,
                ),
                itemCount: snapshot.data?.docs.length ?? 0,
              ),
            );
          }
        });
  }

  Widget latest() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctors')
          // .orderBy('joinDate', descending: true)
          .where('lovers',isNull: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SizedBox(
            height: 290,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>?;
                var rating = data?["raters"];
                List<dynamic> lovers = data?["lovers"];
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final User? user = _auth.currentUser;
                double faverate = 0;
                if (lovers.contains(user?.email)) {
                  faverate = 1;
                }
                final stars =
                    (rating.values.reduce((value, element) => value + element))/rating.length;

                if (data != null) {
                  if(data['status']=='active'){
                    return GestureDetector(
                      onTap: () async {
                        Get.to(Details(model: data as Map<dynamic, dynamic>));
                      },
                      child: SizedBox(
                        width: 280,
                        child: ListView(
                          children: [
                            Container(
                              height: 260,
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 22,
                                      left: 10,
                                      child: Container(
                                        height: 200,
                                        width: 220,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 9,
                                                offset: const Offset(0, 0),
                                                color: Colors.grey.shade400)
                                          ],
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 55, top: 10),
                                                child: RatingBarIndicator(
                                                  rating: stars,
                                                  itemBuilder: (context, index) =>
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                  itemCount: 5,
                                                  itemSize: 20.0,
                                                  unratedColor: Colors.grey[300],
                                                  direction: Axis.horizontal,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 15, top: 10),
                                                child: RatingBar.builder(
                                                  initialRating: faverate,
                                                  itemBuilder: (context, index) =>
                                                      const FaIcon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      ),
                                                  itemCount: 1,
                                                  allowHalfRating: false,
                                                  itemSize: 25.0,
                                                  unratedColor: Colors.grey[300],
                                                  onRatingUpdate: (double value) {
                                                    if (Get
                                                        .find<Auth>()
                                                        .user == null) {
                                                      setState(() {
                                                        faverate = 0;
                                                      });
                                                      Get.to(const Welcome_page());
                                                    }
                                                    else {
                                                      if (value == 1) {
                                                        print(data['doctorID']);

                                                        updateUser(true, data['doctorID']);
                                                      }
                                                      else if (value == 0) {
                                                        updateUser(false, data['doctorID']);

                                                      }
                                                    }
                                                  },
                                                ),
                                              )
                                            ]),
                                            Container(
                                                margin: const EdgeInsets.only(top: 10),
                                                child: Text(
                                                  data['speciality'],
                                                  style: TextStyle(
                                                      color:
                                                      Colors.grey.shade600),
                                                )),
                                            Container(
                                                alignment: Alignment.centerRight,
                                                margin: const EdgeInsets.only(
                                                    top: 15, right: 15),
                                                child: Text(
                                                  ' د/  ${data['name']} ',
                                                  textDirection:
                                                  TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                )),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 15, top: 10),
                                              child: Row(
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
                                                      overflow:
                                                      TextOverflow.visible,
                                                      style:
                                                      const TextStyle(fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 15, top: 10),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/money.png",
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    fit: FlexFit.loose,
                                                    child: Text(
                                                        "${data['price']} ريال ",
                                                        softWrap: true,
                                                        overflow:
                                                        TextOverflow.visible,
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 16)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Positioned(
                                      top: 0,
                                      right: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(90),
                                            boxShadow: [
                                              const BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(4, 6),
                                                  blurRadius: 7)
                                            ]),
                                        width: 90,
                                        height: 90,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white38,
                                          radius: 45 ,
                                          backgroundImage:
                                          (data['image']=='')
                                              ?const AssetImage('assets/images/doctor (10).png')
                                              : NetworkImage(data['image']) as ImageProvider<Object>?,

                                        ),

                                        // /

                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );

                  }
                  else {
                    return const SizedBox();
                  }
                }
                else {
                  return const SizedBox();
                }
              },
              separatorBuilder: (context, index) => const SizedBox(width: 0),
              itemCount: snapshot.data?.docs.length ?? 0,
            ),
          );
        }
      },
    );
  }
  updateUser(favorite, DoctorID) async {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    try {

    CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
      CollectionReference doctorCollection = FirebaseFirestore.instance.collection('doctors');
      QuerySnapshot DoctorquerySnapshot = await doctorCollection.where('doctorID', isEqualTo: DoctorID).get();
    print('____________-----------');

      DocumentSnapshot DocquerySnapshot = DoctorquerySnapshot.docs.first;
      String DoctordocumentId = DocquerySnapshot.id;
      print(DoctordocumentId);
print('____________-----------');
      if(favorite==true){
        await doctorCollection.doc(DoctordocumentId)
            .update({'lovers': FieldValue.arrayUnion([user?.email]),});

        await usersCollection.doc(user?.uid).update(
            {
              'Favorite': FieldValue.arrayUnion([DoctorID]),
            });

      }
      else if(favorite==false){
        await doctorCollection.doc(DoctordocumentId)
            .update({'lovers': FieldValue.arrayRemove([user?.email]),});
        await usersCollection.doc(user?.uid).update(
            {
              'Favorite': FieldValue.arrayRemove([DoctorID]),
            });
      }

    }catch(e){
      print('something went wrong1:${e}');
    }
  }

}

class ADs extends StatefulWidget {
  const ADs({Key? key}) : super(key: key);

  @override
  State<ADs> createState() => _ADsState();
}

class _ADsState extends State<ADs> {
  List AdsUrls = [];
  int actveIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getAdImages(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (AdsUrls.length <= 0) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    actveIndex = index;
                  });
                },
              ),
              itemCount: AdsUrls.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final AdUrl = AdsUrls[index];
                return buildImage(AdUrl, index, context);
              },
            ),
            const SizedBox(height: 10),
            buildIndecator(),
          ],
        );
      },
    );
  }

  Future<void> getAdImages() async {
    var images = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('ADs').get();
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> data = document.data();
        if (data.containsKey('image')) {
          String imageUrl = data['image'];
          images.add(imageUrl);
          AdsUrls = images;
        }
      });
    } catch (e) {
      print('Error retrieving AD images: $e');
    }
  }

  Widget buildImage(String adUrl, int index, context) {
    return Container(

      decoration: BoxDecoration(
          image: DecorationImage(
            image:
            NetworkImage(adUrl),
            fit: BoxFit.cover,
          ),

          color: Colors.purple.shade200,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
      height: 200,
      width: MediaQuery.of(context).size.width - 10,
      margin: const EdgeInsets.symmetric(horizontal: 0.1),

    );
  }

  buildIndecator() {
    return AnimatedSmoothIndicator(
      activeIndex: actveIndex,
      count: AdsUrls.length,
      effect: WormEffect(
          dotHeight: 10,
          dotWidth: 10,
          dotColor: Colors.purple.shade300,
          activeDotColor: primaryColor),
    );
  }


}
