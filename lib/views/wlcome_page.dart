// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medical_care_app/widgets/constants.dart';
import 'Login.dart';

class Welcome_page extends StatelessWidget {
  const Welcome_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:Colors.grey[400],

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ Colors.deepPurple,primaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 10,bottom: 10),
                width: 350,height: 650,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/log-in.png',
                      // Replace with your own image path
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'مرحباً بك،',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'قم بتسجيل الدخول للاستفادة من خدماتنا',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                        padding:
                            EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 50),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ Colors.deepPurple,primaryColor],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                            onPressed: () {
                              Get.to(Login(type: 'user',));
                            },
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(color: Colors.white),
                            ))),
                    SizedBox(height: 30),
                    OutlinedButton(
                      onPressed: () {
                        // Handle register button tap
                        Get.to(Login(type: 'Doctor'));
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor),
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 45,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'تسجيل كطبيب',
                        style: TextStyle(fontSize: 18, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
