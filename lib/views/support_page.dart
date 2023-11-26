// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:medical_care_app/widgets/constants.dart';

class SupportTeam extends StatefulWidget {
  SupportTeam({Key? key}) : super(key: key);

  @override
  State<SupportTeam> createState() => _SupportTeamState();
}

class _SupportTeamState extends State<SupportTeam> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _detailsController = TextEditingController();

  bool submit = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فريق الدعم'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Stack(children: [
        ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            Image.asset(
              'assets/images/technical-support.png',
              width: 170,
              height: 170,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'مرحبا، قم بملء الحقول كي نتعرف على المشكله وحلها باقرب وقت!',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText: (_nameController.text == '' && submit == true)
                      ? 'الرجا ملء الحقل'
                      : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'الاسم',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: primaryColor,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                controller: _nameController,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText: (_emailController.text == '' && submit == true)
                      ? 'الرجا ملء الحقل'
                      : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'بريد الإكتروني صالح',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: primaryColor,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                controller: _emailController,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText: (_detailsController.text == '' && submit == true)
                      ? 'الرجا ملء الحقل'
                      : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: '    قم بسرد كل تفاصيل المشكلة',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                controller: _detailsController,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              margin: EdgeInsets.only(
                  right: (MediaQuery.of(context).size.width - 140) / 2,
                  left: (MediaQuery.of(context).size.width - 140) / 2),
              constraints: BoxConstraints(maxWidth: 100),
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(15)),
              child: TextButton(
                child: Text(
                  'إرسال',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  setState(() {
                    FocusScope.of(context).unfocus();

                    submit = true;
                    isLoading = true;
                  });

                  if (_emailController.text != '' &&
                      _detailsController.text != '' &&
                      _nameController.text != '' &&
                      _emailController.text.contains('@gmail.com')) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('reports')
                          .add({
                        'status': 'unchecked',
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'report': _detailsController.text,
                        'sendAt': Timestamp.fromMillisecondsSinceEpoch(
                            DateTime.now().millisecondsSinceEpoch)
                      });
                      setState(() {
                        submit = false;
                        isLoading = false;
                      });
                      final DocumentReference documentRef=FirebaseFirestore.instance.collection('Notifications').doc();
                      final String docId = documentRef.id;
                      documentRef.set({
                        'Title':'تم استلام استفسارك',
                        'Message':''' عزيزي ${_nameController.text},

شكرًا لك على التواصل مع فريق الدعم الخاص بنا. لقد تم استلام رسالتك . نحن نقدر تواصلك معنا.

فريقنا يقوم حاليًا بمراجعة استفسارك وسنقوم بإرسال تحديثات والتواصل معك بشأن تقدم وحل طلبك.

للحفاظ على تواصلكم المستمر، سنرسل تحديثات منتظمة إلى عنوان البريد الإلكتروني المرتبط بحسابك. يُرجى التأكد من التحقق من صندوق الوارد الخاص بك بانتظام للحصول على أي إشعارات من فريق الدعم لدينا.

إذا كانت لديك أي معلومات إضافية أو أسئلة تتعلق بطلبك، يُرجى الرد على البريد الإلكتروني. سيكون وكلاء الدعم لدينا سعداء بتقديم المساعدة.

نحن ندرك أهمية استفسارك، ونحن نسعى لتقديم استجابة في الوقت المناسب. يُرجى ملاحظة أن أوقات الاستجابة قد تختلف اعتمادًا على تعقيد المشكلة، ولكن تأكد من أننا ملتزمون بمعالجة استفسارك في أقرب وقت ممكن.

شكرًا لصبرك وتفهمك.

مع خالص التحية،
فريق الدعم ''',
                        'id':docId,
                        'owner':_emailController.text,
                        'date':Timestamp.fromDate(DateTime.now()),
                        'status':'unread'
                      });

                      _nameController.clear();
                      _detailsController.clear();
                      _emailController.clear();

                      showErrorSnackbar(' تمت العمليه بنجاح!',
                          ' سوف تتم موافاتك ببقية التفاصيل على البريد الإلكتروني');
                    } catch (e) {
                      showErrorSnackbar('لم تتم العمليه!',
                          'حصل خطا غير متوقع نرجوا المحاولة لاحقا');
                    }
                  } else {
                    isLoading = false;
                    showErrorSnackbar('خطا في المدخلات',
                        'الرجاء لتاكد من صحه المدخلات!');
                  }
                },
              ),
            ),
            SizedBox(height: 25)
          ],
        ),
        if (isLoading)
          Stack(
            children: [
              Positioned(
                  child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20)),
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
            ],
          ),
      ]),
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
