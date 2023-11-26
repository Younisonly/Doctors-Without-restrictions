// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewAppointment extends StatelessWidget {
  var doctorInfo;
  var appointmentInfo;
   ReviewAppointment({required this.appointmentInfo,required this.doctorInfo}) ;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 5),
                child: Image.asset(
                  'assets/images/doctorChoose.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                    top: 10, bottom: 10, right: 40, left: 40),
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 40,
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 197, 105, 1),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20))),
                      child: const Text(
                        'بيانات الحجز',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                children: [
                                  Center(
                                    child: Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'د. ${ doctorInfo['name']}',
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
                                      child: Text(
                                          ' ${doctorInfo['title']}',
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
                                          style: const TextStyle(fontSize: 14),
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
                                            overflow:
                                            TextOverflow.visible,
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
