// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../view_model/Controller.dart';

class ConfirmAppointment extends StatefulWidget {
  ConfirmAppointment({required this.appointmentInfo, required this.doctorInfo});

  var doctorInfo;
  var appointmentInfo;

  @override
  State<ConfirmAppointment> createState() => _ConfirmAppointmentState(
      appointmentInfo: appointmentInfo, doctorInfo: doctorInfo);
}

class _ConfirmAppointmentState extends State<ConfirmAppointment> {
  var doctorInfo;
  var appointmentInfo;
  bool isLoading = false;

  _ConfirmAppointmentState(
      {required this.appointmentInfo, required this.doctorInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
          child: ListView(
            children: [
              Center(
                  child: Image.asset(
                'assets/images/certificate.png',
                width: 250,
                height: 250,
              )),
              const Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, right: 40, left: 40),
                child: Text(
                  "الرجاء التاكد من صحة بيانات الحجز، اذا كانت صحيحة الرجاء تاكيد الحجز.",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 185, 255, 1),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20))
                      ),
                      child: const Text(
                        'بيانات الحجز',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 15,
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
                              height: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'د. ${doctorInfo['name']}',
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(' ${doctorInfo['title']}',
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 11)),
                                    ),
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
                                          "${doctorInfo['speciality']}",
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
                                          "${doctorInfo['location']}",
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                          style:
                                              const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
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
                                        child: Text(
                                            "${doctorInfo['price']} ريال ",
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 16)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 20),
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
                      child: Row(
                        children: [
                          Image.asset('assets/images/clock.png',
                              width: 30, height: 30),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              ' الموعد: ${appointmentInfo['appointmentTime']}  ${appointmentInfo['appointmentDate']}')
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, top: 20, bottom: 20),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 20),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'أسم المريض: ${appointmentInfo['patientName']}',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'رقم المريض: ${appointmentInfo['patientNumber']}',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'جنس المريض: ${appointmentInfo['patientGender']}',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'ملاحظات المريض: ${appointmentInfo['patientNote']}',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'العمر : ${appointmentInfo['age']} ',
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.only(right: 40, left: 40),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 185, 255, 1),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.grey,
                            blurRadius: 7,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: submitInfo,
                        child: const Text(
                          'تاكيد',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        isLoading?
        Positioned(
          top: 10,right: 10,left: 10,bottom: 10,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)

                ),
                width: 120.0,
                height: 120.0,
                child: Center(
                  child: SpinKitSpinningLines(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
            ))
            :Container(),
      ]),
    );
  }

  void submitInfo() {
    setState(() {
      isLoading = true;
    });

    final firestoreInstance = FirebaseFirestore.instance;
    final ApointmentsCollection = firestoreInstance.collection('Appointments');

    ApointmentsCollection.where('patientName',
            isEqualTo: appointmentInfo['patientName'])
        .where('appointmentID', isEqualTo: appointmentInfo['appointmentID'])
        .where('doctorId', isEqualTo: doctorInfo['doctorID'])
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        showErrorSnackbar('حدثت مشكلة', 'يوجد حجز مسبق بهذا الاسم');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;

      appointmentInfo['appointmentID'] = ApointmentsCollection.doc().id;
      appointmentInfo['patientEmail'] = user?.email;

      var reference = FirebaseFirestore.instance
          .collection('Appointments')
          .doc('appointmentsNO');
      DocumentSnapshot snapshot = await reference.get();
      var fieldValue = snapshot.get('number') + 1 as int;
      appointmentInfo['appointmentsNo'] = fieldValue;

      await reference.update({'number': fieldValue});

      ApointmentsCollection.add(appointmentInfo).then((_) {
        showSuccessSnackbar(
            'تم الحجز بنجاح', 'قم بتصفح مواعيدك من صفحة المواعيد');
        final DocumentReference documentRef =
            FirebaseFirestore.instance.collection('Notifications').doc();
        final String docId = documentRef.id;
        documentRef.set({
          'Message':
              ' تم تسجيل حجز جديد لدى الطبيب د. ${doctorInfo['name']}  ${appointmentInfo['appointmentTime']}  ${appointmentInfo['appointmentDate']}',
          'Title': 'تم تسجيل حجز جديد',
          'id': docId,
          'owner': user?.email,
          'date': Timestamp.fromDate(DateTime.now()),
          'status': 'unread'
        });
        setState(() {
          isLoading = false;
        });
        Get.offAll(ControlView());
      }).catchError((error) {
        showErrorSnackbar('حدثت مشكلة', 'الرجاء مراجعة فريق الدعم$error');
        setState(() {
          isLoading = false;
        });
      });
    }).catchError((error) {
      print(error);
      showErrorSnackbar('حدثت مشكلة', '$errorالرجاء مراجعة فريق الدعم');
      setState(() {
        isLoading = false;
      });
    });
  }

  void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      icon:
          const Icon(Icons.done_all_sharp, color: CupertinoColors.activeGreen),
      title,
      message,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
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
