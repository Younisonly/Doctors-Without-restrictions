// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_care_app/views/about_The_App/Terms.dart';
import 'package:medical_care_app/views/profile.dart';
import 'package:medical_care_app/views/support_page.dart';
import 'package:medical_care_app/views/wlcome_page.dart';
import 'package:medical_care_app/widgets/constants.dart';

import '../view_model/auth.dart';
import 'about_The_App/AboutTheApp.dart';
import 'about_The_App/Privacy.dart';
import 'about_The_App/call_us.dart';
import 'favorite.dart';
import 'notifications.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Map userInfo = {};

class Sidebar extends StatefulWidget {
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    userData();
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text((Get.find<Auth>().user != null)
                      ? userInfo['name'] ?? ''
                      : 'زائر'),
                  accountEmail: Text((Get.find<Auth>().user != null)
                      ? userInfo['email'] ?? ''
                      : 'visitor'),
                  currentAccountPicture: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: (userInfo['Image'] == null)
                          ? const AssetImage('assets/images/doctor (10).png')
                          : NetworkImage(
                              userInfo['Image'],
                            ) as ImageProvider<Object>?,
                    ),
                  ),
                  currentAccountPictureSize: const Size(90, 90),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/mountains.jpg',
                        ),
                        fit: BoxFit.cover),
                    color: primaryColor,
                  ),
                ),
                ListTile(
                  title: const Text('حسابي'),
                  leading: Icon(
                    Icons.account_circle_rounded,
                    color: (Get.find<Auth>().user == null)
                        ? Colors.grey
                        : primaryColor,
                  ),
                  onTap: () {
                    if (Get.find<Auth>().user == null) {
                      Get.to(const Welcome_page());
                    } else {
                      Get.to(Profile(userData: userInfo));
                    }
                  },
                ),
                ListTile(
                  title: const Text('المفضلة'),
                  leading: Icon(
                    Icons.favorite,
                    color: (Get.find<Auth>().user == null)
                        ? Colors.grey
                        : Colors.red,
                  ),
                  onTap: () {
                    if (Get.find<Auth>().user == null) {
                      Get.to(const Welcome_page());
                    } else {
                      Get.to(const Favorite());
                    }
                  },
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الإشعارات'),
                      (Get.find<Auth>().user != null)?
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Notifications')
                              .where('status', isEqualTo: 'unread').where('owner',isEqualTo:user?.email).
                              snapshots(),
                          builder: (context, snapshot) {
                            var unreadAmount=0;
                            if (snapshot.data != null) {
                              for (var doc in snapshot.data!.docs) {
                                var data = doc.data() as Map<dynamic, dynamic>;
                                unreadAmount+=1;
                              }
                            }
                            return (unreadAmount>0)? Container(
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red,
                              ),
                              child: Center(child: Text(unreadAmount.toString(),style: const TextStyle(color: CupertinoColors.white),)),
                            ):Container();
                          })
                          :SizedBox(),
                    ],
                  ),
                  leading: Icon(
                    Icons.notifications_sharp,
                    color: (Get.find<Auth>().user == null)
                        ? Colors.grey
                        : Colors.amber,
                  ),
                  onTap: () {
                    if (Get.find<Auth>().user == null) {
                      Get.to(const Welcome_page());
                    } else {
                      Navigator.of(context).pop();
                      Get.to(Notifications());
                    }
                  },
                ),
                ListTile(
                  title: const Text('عن التطبيق'),
                  leading: Image.asset('assets/images/book.png', width: 30),
                  onTap: () {
                    if (Get.find<Auth>().user == null) {
                      Get.to(const Welcome_page());
                    } else {
                      Get.to(aboutTheApp());
                    }
                  },
                ),
                ListTile(
                  title: const Text('سياسة الخصوصية'),
                  leading: Image.asset('assets/images/shield.png', width: 30),
                  onTap: () {
                    Get.to(Privacy());
                  },
                ),
                ListTile(
                  title: const Text('شروط الاستخدام'),
                  leading:
                      Image.asset('assets/images/agreement.png', width: 30),
                  onTap: () {
                    Get.to(Terms());
                  },
                ),
                ListTile(
                  title: const Text('إتصل بنا'),
                  leading:
                  Image.asset('assets/images/contact-us.png', width: 30),
                  onTap: () {
                    Get.to(callUs());
                  },
                ),
                ListTile(
                  title: const Text('فريق الدعم'),
                  leading: Icon(
                    Icons.help,
                    color: primaryColor,
                  ),
                  onTap: () {
                    Get.to(SupportTeam());
                  },
                ),
                Get.find<Auth>().user == null
                    ? ListTile(
                        title: const Text('تسجيل الدخول'),
                        leading: Icon(
                          Icons.login_rounded,
                          color: primaryColor,
                        ),
                        onTap: () {
                          Get.to(const Welcome_page());
                        },
                      )
                    : ListTile(
                        title: const Text('تسجيل الخروج'),
                        leading: Icon(
                          Icons.logout,
                          color: primaryColor,
                        ),
                        onTap: () {
                          signOut(context);
                        },
                      ),
              ],
            ),
          ),
          const Text(
            textAlign: TextAlign.center,
            'CopyRights© 2023  Doctors Without Restrictions Team All rights reserved',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }

  signOut(context) {
    showDialog(
      // إضافة عنصر نافذة الحوار
      context: context,
      builder: (context) => AlertDialog(
        titlePadding:
            const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
        // تعيين هوامش العناصر داخل الحوار
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          // تعيين شكل الحوار
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
                Text(' تسجل الخروج', // إضافة عنصر النص
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
        content: SizedBox(
          height: 230,
          child: Column(
            children: [
              Image.asset('assets/images/doctor (2).png', width: 190),
              const Text('هل انت متأكد من تسجيل الخروج؟'),
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
                  setState(() {
                    final User? user = _auth.currentUser;
                    user?.email;
                    print('---------------------____________________');
                    _auth.signOut();
                    userInfo.clear();
                  });

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('خروج', // إضافة عنصر النص
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

  Future<void> userData() async {
    final User? user = _auth.currentUser;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: user?.email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      userInfo = querySnapshot.docs[0].data() as Map<String, dynamic>;
    }

    print(user?.email);
    print(userInfo);
    print('0000000000000000000000000');
  }
}
