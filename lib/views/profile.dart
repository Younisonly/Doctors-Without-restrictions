// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import '../view_model/auth.dart';
import '../widgets/constants.dart';

class Profile extends StatefulWidget {
  Profile({required this.userData});

  var userData;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ConfPassController= TextEditingController();
  final TextEditingController _newPassController= TextEditingController();
  final TextEditingController _oldPassController= TextEditingController();

  bool changeName = false;
  bool changePass = false;

  @override
  Widget build(BuildContext context) {
    print(widget.userData['Image']);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('حسابي'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    top: 70,
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 90),
                      padding: EdgeInsets.only(right: 10, left: 10, bottom: 15),
                      decoration: BoxDecoration(
                        // خصائص تحكم في شكل الحاوية الخارجية
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            offset: Offset(0, 0), // موقع الظل
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Text(widget.userData['name']),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.userData['email'])
                        ],
                      ),
                    )),
                Positioned(
                    top: 20,
                    right: (MediaQuery.of(context).size.width - 90) / 2,
                    child: Container(
                      height: 90,
                      child: GestureDetector(
                        onTap: _showImagePickerDialog,
                        child: Stack(
                          children: [
                            Positioned(
                                child: CircleAvatar(
                                  backgroundColor: primaryColor,
                            radius: 40,
                                    backgroundImage:(widget.userData['Image']!=null)?NetworkImage(widget.userData['Image'])
                                        :(_image != null)
                                        ?FileImage( File(_image!.path), )as ImageProvider<Object>?

                                        :AssetImage('assets/images/doctorDefault.png')

                                    ),

                                ),

                            Positioned(
                              top: 60,
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        const BoxShadow(
                                            blurRadius: 50,
                                            color: Colors.grey,
                                            offset: Offset(0, 0))
                                      ]),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 40,
              right: 40,
            ),
            padding: EdgeInsets.only(right: 20, left: 20),
            decoration: BoxDecoration(
              // خصائص تحكم في شكل الحاوية الخارجية
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  offset: Offset(0, 0), // موقع الظل
                ),
              ],
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('تعديل الاسم'),
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _nameController.text = widget.userData['name'];
                        changeName = !changeName;
                      });
                    },
                  )
                ],
              ),
              Visibility(
                  visible: changeName,
                  child: Column(
                    children: [
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
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
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: primaryColor,
                            ),
                            child: TextButton(
                                onPressed: () async {
                                  if(_nameController.text!=widget.userData['name']){
                                    try {
                                      final QuerySnapshot querySnapshot =
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .where('email',
                                          isEqualTo: user?.email)
                                          .get();

                                      if (querySnapshot.docs.isNotEmpty) {
                                        final DocumentSnapshot documentSnapshot =
                                        querySnapshot.docs[0];
                                        final String documentID =
                                            documentSnapshot.id;
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(documentID)
                                            .update(
                                            {'name': _nameController.text});
                                      }
                                      showErrorSnackbar('تمت العملية بنجاح','تم تعديل البيانات بنجاح');


                                    }catch(e){
                                      showErrorSnackbar('حصل خطا','  لم يتم تعديل البيانات بنجاح');
                                    }
                                  }
                                  else{
                                    showErrorSnackbar('تعديل غير صحيح','  لم يتم تعديل الاسم، قم بتغييرالاسم لتتمكن من التعديل');

                                  }

                                },
                                child: Text('تعديل',
                                    style: TextStyle(color: Colors.white))),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  changeName = !changeName;
                                });
                              },
                              child: Text('إلغا',
                                  style: TextStyle(color: primaryColor)))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
            ]),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 40,
              right: 40,
            ),
            padding: EdgeInsets.only(right: 20, left: 20),
            decoration: BoxDecoration(
              // خصائص تحكم في شكل الحاوية الخارجية
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  offset: Offset(0, 0), // موقع الظل
                ),
              ],
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('تعديل كلمة السر'),
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _nameController.text = widget.userData['name'];
                        changePass = !changePass;
                      });
                    },
                  )
                ],
              ),
              Visibility(
                  visible: changePass,
                  child: Column(
                    children: [
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                            hintText: 'كلمة المرور القديمة',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: primaryColor,
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          controller: _oldPassController,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                            hintText: ' كلمة المرور الجديدة',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: primaryColor,
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          controller: _newPassController,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                            hintText: 'تاكيد كلمة المرور',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: primaryColor,
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          controller: _ConfPassController,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: primaryColor,
                            ),
                            child: TextButton(
                                onPressed: () async {
                                  if(_newPassController.text==''||_ConfPassController.text==''||_oldPassController.text=='') {
                                    showErrorSnackbar('لم تتم العملية','يجب ملاء جميع الحقول');

                                  }
                                  else{
                                    if (_newPassController.text ==
                                        _ConfPassController.text) {
                                      var controller = Get.put(Auth());
                                      controller.OldPassword =
                                          _oldPassController.text;
                                      controller.NewPassword =
                                          _newPassController.text;
                                      controller.updateUserData();
                                    }
                                    else {
                                      showErrorSnackbar('لم تتم العملية',
                                          'يجب ان تتطابق كلمات المرور');
                                    }

                                  }
                                },
                                child: Text('تعديل',
                                    style: TextStyle(color: Colors.white))),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  changePass = !changePass;
                                });
                              },
                              child: Text('إلغا',
                                  style: TextStyle(color: primaryColor)))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
            ]),
          )
        ],
      ),
    );
  }

  Future<void> _showImagePickerDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: const Center(
            child: Text(
              'إختر صورة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/doctorChoose.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: Icon(
                    Icons.camera,
                    color: primaryColor,
                  ),
                  label: Text(
                    'Camera',
                    style: TextStyle(color: primaryColor),
                  ),
                  onPressed: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(ctx).pop();
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),
                  child: TextButton.icon(
                    icon: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _getImage(ImageSource.gallery);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                child: const Text(
                  'الغاء',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    final picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        widget.userData['Image']=null;
        _image = File(pickedImage.path);
      });
      try {
        final String fileName = '/${widget.userData['email']}/image';

        final firebase_storage.Reference ref = firebase_storage.FirebaseStorage
            .instance.ref().child(fileName);

        final firebase_storage.UploadTask uploadTask = ref.putFile(
            File(pickedImage.path));

        final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

        final String downloadURL = await taskSnapshot.ref.getDownloadURL();

        print('Image uploaded successfully. Download URL: $downloadURL');
        final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection('Users')
            .where('email',
            isEqualTo: user?.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot documentSnapshot =
          querySnapshot.docs[0];
          final String documentID =
              documentSnapshot.id;
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(documentID)
              .update(
              {'Image':downloadURL });
        }
        setState(() {
_image;        });
        showErrorSnackbar('تمت العملية بنجاح','تم تعديل الصورة بنجاح');

      } catch (e) {
        print('Error uploading image: $e');
      }
    }}


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
