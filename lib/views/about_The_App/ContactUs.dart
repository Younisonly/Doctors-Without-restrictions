// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/constants.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // دالة build هي المسؤولة عن بناء وعرض واجهة التطبيق
    return Scaffold(
        appBar: AppBar(
          // شريط العنوان في الجزء العلوي من الواجهة
          title: const Text(
            "Contact Us?",
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          // عنصر يتيح للمستخدم التمرير في الواجهة في حال تعدى محتواها حجم الشاشة
          child: Column(
            children: [
              Padding(
                // هامش داخلي للعنصر الداخلي
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    // خصائص تحكم في شكل الحاوية الخارجية
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        offset: Offset(0, 6), // موقع الظل
                      ),
                    ],

                  ),
                ),
              ),
              Padding(
                // هامش داخلي للعنصر الداخلي الثاني
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    // خصائص تحكم في شكل الحاوية الخارجية
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        offset: Offset(0, 6), // موقع الظل
                      ),
                    ],
                  ),
                  child: Padding(
                    // هامش داخلي للعنصر الداخلي الثالث
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                         Text(
                          'Contact Us!',
                          // عنوان داخلي للعنصر الداخلي الثالث
                          style: TextStyle(fontSize: 14, color: primaryColor),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            // خصائص تحكم في شكل الحاوية الداخلية الأولى
                            borderRadius:
                            BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(0,4), // موقع الظل
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children:  [
                                Icon(
                                  Icons.email,
                                  color: primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Check.It@gmail.com",
                                    style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            // خصائص تحكم في شكل الحاوية الداخلية الثانية
                            borderRadius:
                            BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(0,4), // موقع الظل
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children:  [
                                Icon(
                                  Icons.facebook,
                                  color: primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'https://www.facebook.com/check.It',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            // خصائص تحكم في شكل الحاوية الداخلية الثالثة
                            borderRadius:
                            BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(0,4), // موقع الظل
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children:  [
                                FaIcon(
                                  FontAwesomeIcons.twitter,
                                  color: primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  ' https://twitter.com/check.It',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            // خصائص تحكم في شكل الحاوية الداخلية الرابعة
                            borderRadius:
                            BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(0,4), // موقع الظل
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children:  [
                                FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  color: primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  ' https://linkedin.com/check.It',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }}
