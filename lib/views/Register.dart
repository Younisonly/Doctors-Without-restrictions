// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../view_model/auth.dart';
import '../widgets/constants.dart';
import 'Login.dart';

class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Auth>(
      init: Auth(),
      builder: (controller) => Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(children: [
            SizedBox(
              height: 800,
              // MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                      top: -440,
                      left: ((700 - (MediaQuery.of(context).size.width)) / 2) *
                          -1,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: 700,
                        height: 700,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(130, 137, 234, 1),
                            borderRadius: BorderRadius.circular(700)),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 150, bottom: 75),
                              child: Image.asset("assets/images/doctor.png",
                                  height: 190, width: 200),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 100,
                              ),
                              child: SizedBox(
                                height: 130,
                                child: Column(
                                  children: [
                                    Text(
                                      " إنشاء حساب",
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "للمواصلة...            ",
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    top: 180,
                    left: (MediaQuery.of(context).size.width - 320) / 2,
                    // right: 35,
                    child: Container(
                      width: 320,
                      height: 480,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 20,
                                color: Colors.grey,
                                offset: Offset(0, 0))
                          ]),
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          Text(
                            'Register',
                            style: TextStyle(color: primaryColor, fontSize: 28),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 12),
                                hintText: 'الاسم',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                prefixIcon:  Icon(
                                  Icons.person,
                                  color: primaryColor,
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'الرجاء ملأ الحقل!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                controller.name = value;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 12),
                                hintText: 'البريد الإلكتروني',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                prefixIcon:  Icon(
                                  Icons.email,
                                  color: primaryColor,
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'الرجاء ملأ الحقل!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                controller.email = value;
                              },
                            ),
                          ),
                          const SizedBox(height:10),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 12),
                                hintText: 'كلمة السر',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                errorStyle: TextStyle(color: Colors.red),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                prefixIcon:  Icon(
                                  Icons.lock,
                                  color: primaryColor,
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'الرجاء ملأ الحقل!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                controller.password = value;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 12),
                                hintText: 'تأكيد كلمة السر',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                errorStyle: TextStyle(color: Colors.red),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                prefixIcon:  Icon(
                                  Icons.lock_reset,
                                  color: primaryColor,
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'الرجاء ملأ الحقل!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                controller.password_conformed = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 630,
                    left: (MediaQuery.of(context).size.width - 150) / 2,
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () {
                          _formKey.currentState?.save();
                          if (_formKey.currentState!.validate()) {
                            controller.userType = 'patient';
                            controller.createUserWithEmailAndPassword();
                          }
                        },
                        child: const Text(
                          'إنشاء',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 686,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "لديك حساب بالفعل؟",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.off(Login(type: 'user'));
                              },
                              child: Text(
                                'سجل الدخول',
                                style: TextStyle(fontSize: 16),
                              )),
                        ],
                      ))
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
