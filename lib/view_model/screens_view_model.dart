import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/appointments.dart';
import '../views/Rooms.dart';
import '../views/doctors.dart';
import '../views/home_screen.dart';
import '../views/wlcome_page.dart';
import 'Controller.dart';
import 'auth.dart';

// ملف اداره التنقل في الصفحات

// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

class ScreenViewModel extends GetxController {

@override
  void onInit() {
    // TODO: implement onInit
  Get.put(Auth(), permanent: true);

  getUserInfo();
    super.onInit();
  }
  int navigatorValue = 1 ;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String Type = '';
  late String email='';
  late String name='';
  Map<dynamic, dynamic> UserInfo = {};
  Widget currentScreen = HomeScreen();

  // get navigatorValue => _navigatorValue;


changeSelectedValue(int selectedValue) async {

  switch (selectedValue) {
    case 0: {
      navigatorValue = selectedValue;

      currentScreen = Doctors();
      ControlView();
      update();
      break;
    }
    case 1: {
      navigatorValue = selectedValue;

      currentScreen = HomeScreen();
      ControlView();
      update();
      break;
    }
    case 2: {
      if(Get
          .find<Auth>()
          .user == null){
        Get.to(const Welcome_page());
        ControlView();

        update();
        break;

      }
else{
        navigatorValue = selectedValue;

        currentScreen = Rooms();
        ControlView();
        update();
        break;

      }

    }
    case 3: {
      if(Get
          .find<Auth>()
          .user == null){
        Get.to(const Welcome_page());
        ControlView();

        update();
        break;
      }
      else{
        navigatorValue = selectedValue;

        currentScreen = Appointments();
        ControlView();
        update();
        break;

      }

    }
  }
}
getUserInfo() async {
  // الحصول على معلومات المستخدم من قاعدة البيانات
  final User? user = _auth.currentUser;
  print(user?.email);
  await FirebaseFirestore.instance.collection('Users').where(
      'email', isEqualTo: user?.email).get().then((value) {
    // إذا تم العثور على معلومات المستخدم ، يتم تحديث المتغيرات المحلية
    print(value);
    print("------------------------------------------------");
    UserInfo = value.docs[0].data();
    email = UserInfo['email'].toString();
    name=UserInfo['name'].toString();
    // تحديث الواجهة بعد تحديث المتغيرات المحلية
    print(Type);
    update();
    return;
  });
}
}
