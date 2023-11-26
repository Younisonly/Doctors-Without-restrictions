// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_care_app/view_model/screens_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/Inserting.dart';
import '../models/user_model.dart';
import '../widgets/constants.dart';
import 'Controller.dart';

class Auth extends GetxController {
  var leaveTime, workTime;
  String CertificateUrl = '';
  String PracticingCertificateUrl = '';
  String imageUrl = '';
  dynamic email,
      password,
      name,
      OldPassword,
      NewPassword,
      password_conformed,
      userType;
  var DoctorList;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _user = Rxn<User>();

  get user => _user.value?.email;
  final FirebaseStorage storage = FirebaseStorage.instance;
   var userEmail ;
  final String folderName = 'activation';


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    update();
    _user.bindStream(_auth.authStateChanges());
  }

  void signInWithEmailAndPassword() async {
// محاولة تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور المدخلة
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      update(); // تحديث الواجهة الرسومية
      storeUserData(email: email); // حفظ بيانات المستخدم

    final DocumentReference documentRef=FirebaseFirestore.instance.collection('Notifications').doc();
      final String docId = documentRef.id;
      documentRef.set({
        'Message':' تم تسجيل الدخول بنجاح بحساب ${email}',
        'Title':'مرحبا بك من جديد',
        'id':docId,
        'owner':email,
        'date':Timestamp.fromDate(DateTime.now()),
        'status':'unread'
      });
      Get.offAll(ControlView());
    } catch (e) {
// إذا فشل تسجيل الدخول ، فعرض رسالة الخطأ باستخدام GetX
      Get.snackbar(
        icon: const Icon(Icons.error),
        'Error login account',
        e.toString(),
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    Get.put(ScreenViewModel(),
        permanent: true); // إضافة عرض الشاشة إلى الـ GetX
  }

  Future createUserWithEmailAndPassword() async {

    if (userType == 'Doctor') {
      password = DoctorList['password'];
      password_conformed = DoctorList['confirmedPassword'];
      email = DoctorList['email'];
    }
    if (password == password_conformed) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((user) async {
          UserModel userModel;
          if (userType == 'patient') {
            userModel = UserModel(
                email: user.user?.email,
                name: name,
                userId: user.user?.uid,
                type: 0,
            Image: null);
            await FireStoreUser().addUserToFireStore(
                userModel); // إضافة بيانات المستخدم إلى قاعدة البيانات
            final DocumentReference documentRef=FirebaseFirestore.instance.collection('Notifications').doc();
            final String docId = documentRef.id;
            documentRef.set({
              'Message':' تم إنشاء حساب جديد بنجاح  ${email}',
              'Title':'مرحبا بك،',
              'id':docId,
              'owner':email,
              'date':Timestamp.fromDate(DateTime.now()),
              'status':'unread'
            });
          }
          else {
            FirebaseFirestore.instance.collection('Users').add({
              'email': user.user?.email,
              'name': DoctorList['name'],
              'userId': user.user?.uid,
              'type': 1,
            });
            userEmail= user.user?.email.toString();
            sendTimeOfDayToFirebase(DoctorList['leaveTime'], 'leave');
            sendTimeOfDayToFirebase(DoctorList['workTime'], 'start');
            await uploadFiles();
            FirebaseFirestore.instance.collection('doctors').add({
              'email': user.user?.email,
              'available': DoctorList['available'],
              'name': DoctorList['name'],
              'status':'inactive',
              'doctorID': user.user?.uid,
              'city': DoctorList['city'],
              'description': DoctorList['description'],
              'leaveTime': leaveTime,
              'location': DoctorList['location'],
              'phoneNumber': DoctorList['phoneNumber'],
              'price': DoctorList['price'],
              'speciality': DoctorList['speciality'],
              'title': DoctorList['title'],
              'workTime': workTime,
              'DoctorLatitude':DoctorList['DoctorLatitude'],
              'DoctorLongitude':DoctorList['DoctorLongitude'],
              'CertificateUrl': CertificateUrl,
              'PracticingCertificateUrl': PracticingCertificateUrl,
              'image': imageUrl,
              'doctorID': user.user?.uid,
              'lovers':[''],
              'raters': {'app@gmail.com':4},
              'joinDate':Timestamp.fromDate(DateTime.now()),
            });

            final DocumentReference documentRef=FirebaseFirestore.instance.collection('Notifications').doc();
            final String docId = documentRef.id;
            documentRef.set({
              'Message':' تم إنشاء حساب طبيب جديد بنجاح، لن يتم تفعيل الحساب كطبيب حتى يتم التاكد من البيانات. اذا لم يتم تفعيل حسابك تواصل مع فريق الدعم،قم بزياره https://www.DoctorsWithoutRestrictions.com لإدارت حجوزاتك',
              'Title':'مرحبا بك،',
              'id':docId,
              'owner':email,
              'date':Timestamp.fromDate(DateTime.now()),
              'status':'unread'
            });
          }
        });
        storeUserData(email: email);
        Get.offAll(ControlView());
      }
      catch (e) {
        print('|${e}|');
        Get.snackbar(
          icon: const Icon(Icons.error),
          'فشل انشاء الحساب',
          (e.toString() ==
              '[firebase_auth/invalid-email] The email address is badly formatted.')
              ? 'الايميل غير صالح الرجا تصحيحة '
              :
          e.toString(),
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      Get.put(ScreenViewModel(), permanent: true);
    }

    else {
      Get.snackbar(
        icon: const Icon(Icons.error),
        'خطا توافق كلمة المرور!',
        "كلمة المرور غير متوافقه, الرجاء تأكيد كلمة المرور",
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    // إضافة عرض الشاشة إلى الـ GetX
  }

  Future<void> updateUserData() async {
    try {
// الحصول على بيانات المستخدم الحالي
      final User? thisUser = _auth.currentUser;
      final String curentEmail = thisUser?.email ?? "";
      print(curentEmail);

// إعداد بيانات التحقق من الهوية
      AuthCredential credential = EmailAuthProvider.credential(
          email: curentEmail, password: OldPassword);

// التحقق من صحة بيانات التحقق من الهوية
      dynamic isDone = await thisUser?.reauthenticateWithCredential(credential);

// تحديث البريد الإلكتروني وكلمة المرور
      await thisUser?.updatePassword(NewPassword);

// تحديث بيانات المستخدم في قاعدة البيانات
// عرض رسالة النجاح باستخدام GetX
      Get.snackbar(
        icon: Icon(
          Icons.done_all,
          color: primaryColor,
        ),
        "تمت العمليه بنجاح",
        "تم تغيير كلمة المرور!",
        colorText: primaryColor,
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      final DocumentReference documentRef=FirebaseFirestore.instance.collection('Notifications').doc();
      final String docId = documentRef.id;
      documentRef.set({
        'Message':' تم تعديل كلمة المرور بنجاح للحساب ${email}',
        'Title':'مرحبا، تم التعديل',
        'id':docId,
        'owner':email,
        'date':Timestamp.fromDate(DateTime.now()),
        'status':'unread'
      });
    } catch (e) {
// عرض رسالة الخطأ باستخدام GetX
      Get.snackbar(
        icon: const Icon(Icons.error),
        'Error Editing account',
        e.toString(),
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> storeUserData({
    required String email,
  }) async {
    var UserInfo, name, Type;
// الحصول على بيانات المستخدم من قاعدة البيانات
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      UserInfo = value.docs[0].data();
      name = UserInfo['name'].toString();
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('name', name ?? '');
  }

  Future uploadFiles() async {
    // Upload File 1
     try {
      Reference CertificateRef = storage.ref().child(
          '$userEmail/$folderName/${DoctorList['CertificateName'].toString()}');
      UploadTask CertificateUploadTask = CertificateRef.putFile(
          DoctorList['Certificate']);
      TaskSnapshot CertificateSnapshot = await CertificateUploadTask
          .whenComplete(() => print('Certificate uploaded0000000000000000000000000000000000000000000000000000'));
      CertificateUrl = await CertificateSnapshot.ref.getDownloadURL();
    } catch(e) {
      print(e.toString());
    }
    try {
      Reference PracticingCertificateRef = storage.ref().child(
          '$userEmail/$folderName/${DoctorList['PracticingCertificateName'].toString()}');
      UploadTask PracticingCertificateUploadTask = PracticingCertificateRef
          .putFile(DoctorList['PracticingCertificate']);
      TaskSnapshot PracticingCertificateSnapshot = await PracticingCertificateUploadTask
          .whenComplete(() => print('PracticingCertificate uploaded000000000000000000000000000000000000'));
      PracticingCertificateUrl =
      await PracticingCertificateSnapshot.ref.getDownloadURL();
    } catch (e){
      print(e.toString());
    }
    // Upload File 2
    try {
      // Upload Image
      Reference imageRef = storage.ref().child(
          '$userEmail/$folderName/${DoctorList['ImageName'].toString()}');
      UploadTask imageUploadTask = imageRef.putFile(DoctorList['Image']);
      TaskSnapshot imageSnapshot = await imageUploadTask.whenComplete(() =>
          print('Image uploaded00000000000000000000000000000000'));
      imageUrl = await imageSnapshot.ref.getDownloadURL();

    } catch (e){
      print(e.toString());
      print('00000000000imageUrl00000000000');
    }



  }


  void sendTimeOfDayToFirebase(TimeOfDay time, type) async {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(
        now.year, now.month, now.day, time.hour, time.minute);
    if (type == 'leave') {
      leaveTime = Timestamp.fromDate(dateTime);
    }
    else {
      workTime = Timestamp.fromDate(dateTime);
    }
  }

}
