// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:medical_care_app/views/reviewAppointment.dart';
import 'package:medical_care_app/widgets/constants.dart';
import '../widgets/location.dart';
import 'EditAppointment.dart';
import 'map.dart';

class Appointments extends StatefulWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var doctorInfo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: primaryColor, // Set the background color of the TabBar
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                // Set the color of the selected tab indicator
                labelColor: Colors.white,
                // Set the color of the selected tab label
                unselectedLabelColor: Colors.grey.shade50,
                tabs: [
                  const Tab(
                      icon: Icon(Icons.info_outline_rounded), text: 'غير مؤكد'),
                  const Tab(icon: Icon(Icons.done_all_outlined), text: 'مؤكد'),
                  const Tab(
                      icon: Icon(Icons.watch_later_outlined), text: 'مؤجل'),
                  const Tab(icon: Icon(Icons.cancel_outlined), text: 'ملغي'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Appointments')
                        .where('patientID', isEqualTo: user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final unConfirmedCount = checkAppointmentsIfNull(
                            snapshot.data, 'unConfirmedCount');

                        if (unConfirmedCount == 0) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/doctor (5).png',
                                    width: 300,
                                    height: 300,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'لا يوجد اي مواعيد غير مؤكدة بعد!',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index].data()
                                as Map<dynamic, dynamic>;
                            if (data['status'] == 'unConfirmed' &&
                                data['patientID'] == user?.uid) {
                              getDoctorData(data);
                              return appointmentsList(data);
                            }
                            return Container();
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemCount: snapshot.data!.docs.length,
                        );
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Appointments')
                        .where('patientID', isEqualTo: user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final ConfirmedCount = checkAppointmentsIfNull(
                            snapshot.data, 'ConfirmedCount');

                        if (ConfirmedCount == 0) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/doctor (4).png',
                                    width: 300,
                                    height: 300,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'لا يوجد اي مواعيد مؤكدة بعد!',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index].data()
                            as Map<dynamic, dynamic>;
                            if (data['status'] == 'Confirmed' &&
                                data['patientID'] == user?.uid) {
                              return appointmentsList(data);
                            }
                            return Container();
                          },
                          separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                          itemCount: snapshot.data!.docs.length,
                        );
                      }
                    },
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Appointments')
                        .where('patientID', isEqualTo: user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final LateCount =
                            checkAppointmentsIfNull(snapshot.data, 'LateCount');

                        if (LateCount == 0) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/doctor (3).png',
                                    width: 300,
                                    height: 300,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'لا يوجد اي مواعيد مؤجلة بعد!',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index].data()
                                as Map<dynamic, dynamic>;
                            if (data['status'] == 'Delayed' &&
                                data['patientEmail'] == user?.email) {
                              return appointmentsList(data);
                            }
                            return Container();
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemCount: snapshot.data!.docs.length,
                        );
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Appointments')
                        .where('patientID', isEqualTo: user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final CancelCount = checkAppointmentsIfNull(
                            snapshot.data, 'CancelCount');

                        if (CancelCount == 0) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/doctor (3).png',
                                    width: 300,
                                    height: 300,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'لا يوجد اي مواعيد ملغية بعد!',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index].data()
                                as Map<dynamic, dynamic>;
                            if (data['status'] == 'Canceled' &&
                                data['patientID'] == user?.uid) {
                              return appointmentsList(data);
                            }
                            return Container();
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemCount: snapshot.data!.docs.length,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDoctorData(data) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .where('doctorID', isEqualTo: data['doctorId'])
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doctorData =  snapshot.docs.first.data() as Map<String, dynamic>;
      doctorInfo = doctorData;
      print(doctorInfo);
    }
  }

  Widget appointmentsList(data) {
    return GestureDetector(
      onTap: () {
        Get.to(
            ReviewAppointment(appointmentInfo: data, doctorInfo: doctorInfo));
      },
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              height: 210,
              width: 420,
              decoration: BoxDecoration(
                borderRadius: (data['status'] == 'unConfirmed' ||
                        data['status'] == 'Confirmed' ||
                        data['status'] == 'Delayed')
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))
                    : BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                    color: Colors.grey,
                    blurRadius: 7,
                    offset: Offset(0, 0), // موقع الظل
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ' رقم الحجز  ${data['appointmentsNo']}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(' حجز بإسم: ${data['patientName']} '),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/stethoscope.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text('د. ${data['doctorName']}'),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/money.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text('${data['price']}'),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/clock.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                '${data['appointmentTime']}      ${data['appointmentDate']}',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/map.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  '${data['doctorLocation']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 7, bottom: 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (data['status'] == 'Canceled')
                            ? const SizedBox()
                            : GestureDetector(
                                onTap: () {
                                  Get.to(EditAppointment(
                                    appointmentInfo: data,
                                  ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(0, 197, 105, 1),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Image.asset('assets/images/edit.png',
                                      width: 20, height: 20),
                                ),
                              ),
                        const SizedBox(
                          height: 5,
                        ),
                        (data['status'] == 'Canceled')
                            ? const SizedBox()
                            : GestureDetector(
                                onTap: () async {
                                  deleteAppointment(context, data);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade700,
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Image.asset('assets/images/delete.png',
                                      width: 20, height: 20),
                                ),
                              ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 197, 105, 1),
                                borderRadius: BorderRadius.circular(7)),
                            child: Image.asset('assets/images/information.png',
                                width: 20, height: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var userLocation =
                                await GetLocation().getLocation();
                            print(userLocation);
                            print(userLocation);
                            Get.to(ViewMap(
                              doctorLocation: LatLng.LatLng(
                                  data['DoctorLatitude'],
                                  data['DoctorLongitude']),
                              userLocation: userLocation,
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 197, 105, 1),
                                borderRadius: BorderRadius.circular(7)),
                            child: Image.asset('assets/images/pin.png',
                                width: 20, height: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          (data['status'] == 'unConfirmed')
              ? Container(
                  width: 420,
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  padding: const EdgeInsets.only(
                      top: 10, right: 8, left: 8, bottom: 10),
                  decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            'هذا الحجز غير مؤكد! لا تقم بزيارة الطبيب حتى يتم تاكيد الحجز',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.visible,
                          )),
                    ],
                  ),
                )
              : (data['status'] == 'Confirmed')
                  ? Container(
                      width: 420,
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      padding: const EdgeInsets.only(
                          top: 10, right: 8, left: 8, bottom: 10),
                      decoration: const BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                'تم تأكيد هذا الحجز من قبل الطبيب الرجاء الإلتزام بالموعد',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                overflow: TextOverflow.visible,
                              )),
                        ],
                      ),
                    )
                  : (data['status'] == 'Delayed')
                      ? Container(
                          width: 420,
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          padding: const EdgeInsets.only(
                              top: 10, right: 8, left: 8, bottom: 10),
                          decoration: const BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'تم تغيير الموعد من قبل الطبيب الرجاء التاكيد والموافقة على التعديل ليتم اعتماد موعدكم او قم بتعديل الموعد السابق!',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                        overflow: TextOverflow.visible,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryColor,
                                ),
                                child: TextButton(
                                  child: const Text(
                                    'اوافق',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    FirebaseFirestore firestore =
                                        FirebaseFirestore.instance;

                                    QuerySnapshot snapshot = await firestore
                                        .collection(
                                            'Appointments') // Replace with your collection name
                                        .where('appointmentID',
                                            isEqualTo: data['appointmentID'])
                                        .get();

                                    for (QueryDocumentSnapshot doc
                                        in snapshot.docs) {
                                      String documentId = doc.id;
                                      // Update the desired fields
                                      await firestore
                                          .collection('Appointments')
                                          .doc(documentId)
                                          .update({'status': 'Confirmed'});
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      : Container()
        ],
      ),
    );
  }

  int checkAppointmentsIfNull(QuerySnapshot? snapshot, type) {
    int unConfirmedCount = 0;
    int ConfirmedCount = 0;
    int CancelCount = 0;
    int LateCount = 0;

    if (snapshot != null) {
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<dynamic, dynamic>;
        if (data['status'] == 'unConfirmed') {
          unConfirmedCount++;
        }
        if (data['status'] == 'Confirmed') {
          ConfirmedCount++;
        }
        if (data['status'] == 'Canceled') {
          CancelCount++;
        }
        if (data['status'] == 'Delayed') {
          LateCount++;
        }
      }
    }
    if (type == 'unConfirmedCount')
      return unConfirmedCount;
    else if (type == 'ConfirmedCount')
      return ConfirmedCount;
    else if (type == 'LateCount')
      return LateCount;
    else
      return CancelCount;
  }

  deleteAppointment(BuildContext context, data) {
    showDialog(
      // إضافة عنصر نافذة الحوار
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            titlePadding:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 30),
            // تعيين هوامش العناصر داخل الحوار
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              // تعيين شكل الحوار
              borderRadius: BorderRadius.circular(10),
            ),
            title: Container(
              // إضافة عنصر عنوان الحوار
              decoration: const BoxDecoration(
                // تعيين خصائص العنوان
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('حذف موعد', // إضافة عنصر النص
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white)),
                ),
              ),
            ),
            content: Column(children: [
              Image.asset(
                'assets/images/doctor (3).png',
                width: 90,
                height: 90,
              ),
              const Text('هل انت متأكد من حذف هذا الموعد؟'),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(0, 197, 105, 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 7,
                          offset: Offset(0, 0), // موقع الظل
                        ),
                      ],
                    ),
                    child: TextButton(
                      // إضافة زر النص
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('إلغاء',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 7,
                          offset: Offset(0, 0), // موقع الظل
                        ),
                      ],
                    ),
                    child: TextButton(
                      // إضافة زر النص
                      onPressed: () async {
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        Navigator.of(context).pop();

                        QuerySnapshot snapshot = await firestore
                            .collection(
                                'Appointments') // Replace with your collection name
                            .where('appointmentID',
                                isEqualTo: data['appointmentID'])
                            .get();

                        for (QueryDocumentSnapshot doc in snapshot.docs) {
                          String documentId = doc.id;
                          // Update the desired fields
                          await firestore
                              .collection('Appointments')
                              .doc(documentId)
                              .update({'status': 'Canceled'});
                        }
                      },
                      child: const Text('حذف',
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
