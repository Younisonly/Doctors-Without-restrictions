// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:medical_care_app/views/select_Location.dart';
import '../view_model/auth.dart';
import '../widgets/constants.dart';
import '../widgets/custom_text.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/location.dart';

class RegisterDoctor extends StatefulWidget {
  RegisterDoctor({Key? key}) : super(key: key);
  Map<String, double>? LatLng;

  @override
  State<RegisterDoctor> createState() => _RegisterDoctorState();
}

class _RegisterDoctorState extends State<RegisterDoctor> {
  var category = 'إختر تخصص';
  var CertificateName;
  var ImageName;
  var PracticingCertificateName;
  var _leaveTime;
  var _workTime;
  List<int> _available = List.generate(7, (_) => 0);
  var name, email, password, password_conformed;
  int currentStep = 0;
  Map<String, dynamic> DoctorList = {};
  bool submited = false;
  bool detailsSubmited = false;
  bool confirmSubmited = false;
  var categoryItems = [];
  var _arabicDayNames = DateFormat.EEEE('ar').dateSymbols.STANDALONEWEEKDAYS;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _graduationYearController =
      TextEditingController();
  var PracticingCertificate, Certificate, _image;

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == steps().length - 1;
    return Scaffold(
        body: Theme(
      data: Theme.of(context)
          .copyWith(colorScheme: ColorScheme.light(primary: primaryColor)),
      child: SafeArea(
          child: GetBuilder<Auth>(
        init: Auth(),
        builder: (controller) => Stepper(
          type: StepperType.horizontal,
          steps: steps(),
          currentStep: currentStep,
          onStepContinue: () {
            if (currentStep == 0) {
              setState(() {
                FocusManager.instance.primaryFocus?.unfocus();
                submited = true;
              });
              if (_validatePassword() && _validateEmail()) {
                if (_confirmPasswordController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty &&
                    _nameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty &&
                    _numberController.text.isNotEmpty) {
                  print(_emailController.text);
                  DoctorList.addAll({
                    'phoneNumber': _numberController.text,
                    'email': _emailController.text,
                    'name': _nameController.text,
                    'password': _passwordController.text,
                    'confirmedPassword': _confirmPasswordController.text
                  });
                  print(DoctorList);
                  setState(() {
                    currentStep += 1;
                  });
                }
              }
            } else if (currentStep == 1) {
              setState(() {
                detailsSubmited = true;
              });

              if (_priceController.text.isEmpty &&
                  _titleController.text.isEmpty &&
                  _cityController.text.isEmpty &&
                  _descriptionController.text.isEmpty) {
              } else if (_leaveTime == null) {
                error_message(
                    'خطاء في المدخلات', 'الرجاء اختيار وقت إنتهاء الدوام');
              } else if (_workTime == null) {
                error_message('خطاء في المدخلات', 'الرجاء اختيار وقت الدوام');
              } else if (category == 'إختر تخصص') {
                error_message('خطاء في المدخلات', 'الرجاء اختيار التخصص');
              } else if (_locationController == '' ||
                  _locationController == null) {
                error_message('خطاء في المدخلات', 'الرجاء كتابه الموقع');
              } else if (widget.LatLng == null) {
                error_message('خطاء في المدخلات', 'الرجاء اختيار الموقع');
              } else {
                DoctorList.addAll({
                  'leaveTime': _leaveTime,
                  'workTime': _workTime,
                  'speciality': category,
                  'description': _descriptionController.text,
                  'city': _cityController.text,
                  'title': _titleController.text,
                  'price': _priceController.text,
                  'location': _locationController.text,
                  'available': _available,
                  'Image': _image,
                  'ImageName': ImageName,
                  'DoctorLongitude': widget.LatLng!['longitude'],
                  'DoctorLatitude': widget.LatLng!['latitude'],
                });
                print(DoctorList);
                setState(() {
                  currentStep += 1;
                });
              }
            } else if (isLastStep) {
              controller.userType = 'Doctor';
              setState(() {
                confirmSubmited = true;
                controller.DoctorList = DoctorList;
              });

              if (_universityController.text.isEmpty &&
                  _levelController.text.isEmpty &&
                  _graduationYearController.text.isEmpty) {
              } else if (PracticingCertificate == null) {
                error_message(
                    'خطاء في المدخلات', 'الرجاء تحديد شهادة مزاوله مهنة ');
              } else if (Certificate == null) {
                error_message('خطاء في المدخلات', 'الرجاء  تحديد شهادة الجامعة');
              } else {
                DoctorList.addAll({
                  'university': _universityController.text,
                  'level': _levelController.text,
                  'graduationYear': _graduationYearController.text,
                  'description': _descriptionController.text,
                  'PracticingCertificate': PracticingCertificate,
                  'Certificate': Certificate,
                  'CertificateName': CertificateName,
                  'PracticingCertificateName': PracticingCertificateName,
                  'status': 'unactivated'
                });

                controller.createUserWithEmailAndPassword();
              }
            }
          },
          onStepCancel: () {
            currentStep == 0
                ? null
                : setState(() {
                    currentStep -= 1;
                  });
          },
          controlsBuilder:
              (BuildContext context, ControlsDetails? controlsDetails) {
            return Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: (isLastStep)
                          ? const Text('تأكيد')
                          : const Text('التالي'),
                      onPressed: controlsDetails?.onStepContinue,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  if (currentStep != 0)
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('رجوع'),
                        onPressed: controlsDetails?.onStepCancel,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      )),
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _numberController.dispose();
    _priceController.dispose();
    _titleController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _universityController.dispose();
    _levelController.dispose();
    _graduationYearController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  List<Step> steps() {
    return [
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text('حسابي'),
        content: Column(
          children: [
            Image.asset('assets/images/medical-report.png',
                width: 170, height: 170),
            const SizedBox(height: 20),
            const Text('الرجاء ملء الحقول بشكل صحيح'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText: (submited == true && _nameController.text == '')
                      ? 'الرجاء ملء الحقل'
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText: (submited == true && _numberController.text == '')
                      ? 'الرجاء ملء الحقل'
                      : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'رقم الهاتف',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: primaryColor,
                  ),
                ),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black),
                controller: _numberController,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'البريد الإلكتروني',
                  errorText: (submited == true && _emailController.text == '')
                      ? 'الرجاء ملء الحقل'
                      : (submited == true && !_validateEmail())
                          ? 'يجب ان يحتوي الايميل على(gmail.com@) '
                          : null,
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'كلمة السر',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText: (submited == true &&
                          _passwordController.text == '')
                      ? 'الرجاء ملء الحقل'
                      : (submited == true &&
                              _passwordController.text.length <= 6)
                          ? 'يجب ان تحتوي كلمة المرور على اكثر من ست حروف، رموز، ارقام'
                          : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: primaryColor,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                obscureText: true,
                controller: _passwordController,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'تأكيد كلمة السر',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText: (submited == true &&
                          _confirmPasswordController.text == '')
                      ? 'الرجاء ملء الحقل'
                      : submited == true && !_validatePassword()
                          ? 'الرجاء ادخل كلمة سر مطابقه'
                          : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  prefixIcon: Icon(
                    Icons.lock_reset,
                    color: primaryColor,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                obscureText: true,
                controller: _confirmPasswordController,
              ),
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text('التفاصيل'),
        content: Column(
          children: [
            Container(
              height: 130,
              child: GestureDetector(
                onTap: _showImagePickerDialog,
                child: Stack(
                  children: [
                    Positioned(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _image != null
                                ? Image.file(
                                    File(_image!.path),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/doctorDefault.png'))),
                    Positioned(
                      top: 100,
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
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText:
                      (detailsSubmited == true && _priceController.text == '')
                          ? 'الرجاء ملء الحقل'
                          : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'تكلفة المعاينة',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  prefixIcon: Image.asset(
                    'assets/images/money (1).png',
                    width: 30,
                    height: 20,
                  ),
                ),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black),
                controller: _priceController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 150,
              child: FutureBuilder(
                future: Getcategory(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).unfocus();
                      },
                      child: DropdownButton(
                        isExpanded: true,
                        hint: const CustomText(
                            text: "category",
                            color: Colors.black,
                            fontSize: 12),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            category = newValue.toString();
                          });
                        },
                        underline: Container(height: 2, color: primaryColor),
                        value: category,
                        items: categoryItems.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(
                              valueItem,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        dropdownColor: Colors.grey[200],
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText:
                      (detailsSubmited == true && _titleController.text == '')
                          ? 'الرجاء ملء الحقل'
                          : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  hintText: 'وصف التخصص',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                style: const TextStyle(color: Colors.black),
                controller: _titleController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText:
                      (detailsSubmited == true && _cityController.text == '')
                          ? 'الرجاء ملء الحقل'
                          : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'المحافظة',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  prefixIcon: Image.asset(
                    'assets/images/placeholder.png',
                    width: 15,
                    height: 15,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                controller: _cityController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.grey,
                        blurRadius: 7,
                        offset: Offset(0, 0),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.only(
                    right: 25,
                    bottom: 10,
                    top: 10,
                    left: 25,
                  ),
                  child: const Center(
                    child: Text(
                      'نبذة عنك',
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  // Allows for multiple lines
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: 'المزيد من التفاصيل عنك (إختياري)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 23),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextButton(
                    child: Text(
                      'تحديد وقت الدوام ',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _selectWorkTime(context, 'workTime');
                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                (_workTime == null)
                    ? Text('لم يتم تحديد وقت  الدوام')
                    : Text('${_workTime?.format(context)}')
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextButton(
                    child: Text(
                      'تحديد وقت انتهاء الدوام ',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _selectWorkTime(context, 'leave');
                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                (_leaveTime == null)
                    ? Text('لم يتم تحديد وقت إنتهاءالدوام')
                    : Text('${_leaveTime?.format(context)}')
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 255,
              // padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 7,
                          offset: Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.only(
                      right: 25,
                      bottom: 10,
                      top: 10,
                      left: 25,
                    ),
                    child: const Center(
                      child: Text(
                        'حدد ايام الدوام',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(7, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_available[index] == 0) {
                              _available[index] = 1;
                            } else {
                              _available[index] = 0;
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _available[index] == 1
                                ? Colors.green
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              _arabicDayNames[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 170,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/pin.png',
                      width: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'حدد الموقع',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () async {
                  var userLocation = await GetLocation().getLocation();
                  var Locationresult = await Get.to<Map<String, double>>(
                      selectLocation(userLocation: userLocation));
                  widget.LatLng = Locationresult as Map<String, double>;
                  print(widget.LatLng);
                  print("____________________");
                },
              ),
            ),
            SizedBox(height: 20),
            (widget.LatLng == null)
                ? Text('لم يتم اختيار موقع!')
                : Text('تم اختيار موقع'),
            SizedBox(height: 20),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.grey,
                        blurRadius: 7,
                        offset: Offset(0, 0),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.only(
                    right: 25,
                    bottom: 10,
                    top: 10,
                    left: 25,
                  ),
                  child: const Center(
                    child: Text(
                      'الموقع بالتفصيل',
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                  ),
                ),
                TextField(
                  controller: _locationController,
                  maxLines: null,
                  // Allows for multiple lines
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.red),
                    errorText: (detailsSubmited == true &&
                            _locationController.text == '')
                        ? 'الرجاء ملء الحقل'
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 30),
                    hintText: 'المزيد من التفاصيل عن موقع العيادة',
                    hintStyle: const TextStyle(color: Colors.grey),
                    // focusedBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: ),
                    // ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      Step(
        isActive: currentStep >= 2,
        title: const Text('التأكيد'),
        content: Column(
          children: [
            Image.asset(
              'assets/images/certificate.png',
              width: 150,
            ),
            Text('لتفعيل حسابك كطبيب الرجاء ملء الحقول التاليه بمعلومات دقيقة!'),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText: (confirmSubmited == true &&
                          _universityController.text == '')
                      ? 'الرجاء ملء الحقل'
                      : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'الجامعة',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  prefixIcon: Image.asset(
                    'assets/images/mortarboard.png',
                    width: 10,
                    height: 10,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                controller: _universityController,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText:
                      (confirmSubmited == true && _levelController.text == '')
                          ? 'الرجاء ملء الحقل'
                          : null,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'المستوى الجامعي',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  prefixIcon: Image.asset(
                    'assets/images/mortarboard.png',
                    width: 10,
                    height: 10,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                controller: _levelController,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.red),
                    errorText: (confirmSubmited == true &&
                            _graduationYearController.text == '')
                        ? 'الرجاء ملء الحقل'
                        : null,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: 'سنه التخرج',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_month,
                      color: primaryColor,
                      size: 28,
                    )),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: _graduationYearController,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                        onPressed: () {
                          chooseFile('Certificate');
                        },
                        child: Text(
                          'الشهاده الجامعية',
                          style: TextStyle(color: Colors.white),
                        ))),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 200,
                  child: Text(
                      overflow: TextOverflow.ellipsis,
                      (Certificate == null)
                          ? 'لم يتم تحديد شهادة'
                          : '${CertificateName}'),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                        onPressed: () {
                          chooseFile('PracticingCertificate');
                        },
                        child: Text(
                          'شهاده مزاولة مهنة ',
                          style: TextStyle(color: Colors.white),
                        ))),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 200,
                  child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      (PracticingCertificate == null)
                          ? 'لم يتم تحديد شهادة مزاولة مهنه'
                          : '${PracticingCertificateName}'),
                )
              ],
            )
          ],
        ),
      ),
    ];
  }

  void chooseFile(choosen) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      File name = File(result.files.single.name!);

      if (choosen == 'Certificate') {
        Certificate = File(file.path);
        setState(() {
          var cleanedName = name.toString();
          CertificateName = cleanedName.replaceFirst('File:', '');
        });
      } else if (choosen == 'PracticingCertificate') {
        {
          PracticingCertificate = File(file.path);
          setState(() {
            var cleanedName = name.toString();
            PracticingCertificateName = cleanedName.replaceFirst('File:', '');
          });
        }
      }
    }
  }

  Future<void> _selectWorkTime(BuildContext context, type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (type == 'leave') {
          _leaveTime = picked;
        } else {
          _workTime = picked;
        }
      });
    }
  }

  bool _validateEmail() {
    final String input = _emailController.text;
    if (input.contains('@gmail.com')) {
      return true;
    } else {
      return false;
    }
  }

  bool _validatePassword() {
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;
    if (password.length >= 6) {
      if (password == confirmPassword) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        File name = File(pickedImage.name);
        var cleanedName = name.toString();
        ImageName = cleanedName.replaceFirst('File:', '');
      });
    }
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

  Getcategory() async {
    var data;
    await FirebaseFirestore.instance
        .collection('Specialties')
        .get()
        .then((value) {
      categoryItems.clear();
      categoryItems.add('إختر تخصص');
      for (int i = 0; i < value.docs.length; i++) {
        data = value.docs[i].data();
        categoryItems.add(data['name'].toString());
      }
    });
  }

  SnackbarController error_message(title, content) {
    return Get.snackbar(
      icon: const Icon(Icons.error),
      title,
      content,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
