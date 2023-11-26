
// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar_controller.dart';
import 'package:intl/intl.dart';
import '../widgets/constants.dart';
import 'confirmAppointment.dart';

class HaveAppointment extends StatefulWidget {
  var DoctorInfo;

  HaveAppointment({required this.DoctorInfo});

  @override
  State<HaveAppointment> createState() =>
      _HaveAppointmentState(DoctorInfo: DoctorInfo);
}

class _HaveAppointmentState extends State<HaveAppointment> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedGender = '';
  bool _formSubmitted = false;
  final List<String> genders = ['ذكر', 'انثى'];
  Widget gradView = Container();
  var DoctorInfo;
  int selectedIndex = -1;
  String selectedText = '';
  String formattedSelectedDate = '';
  DateTime? selectedBirthday;
  int age = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  _HaveAppointmentState({required this.DoctorInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'أحجز طبيبك',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Image.asset('assets/images/report (1).png', width: 200, height: 200),
          const Center(child: Text('الرجاء ملء الحقول بشكل دقيق')),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: 'أسم المريض',
                    errorText: _formSubmitted && !_validateName()
                        ? 'الرجاء ادخال الاسم الثلاثي'
                        : null,
                  ),
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    counterText: '',
                    errorText: _formSubmitted && !_validateNumber()
                        ? 'يرخا ادخل رقم هاتف صحيح'
                        : null,
                  ),
                  maxLength: 9,
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  spacing: 26, // Adjust the spacing between items as needed
                  children: genders.map((String gender) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: gender,
                          activeColor: primaryColor,
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value.toString();
                            });
                          },
                        ),
                        Text(gender),
                        const SizedBox(width: 8.0),
                        Image.asset(
                          gender == 'ذكر'
                              ? 'assets/images/male-gender.png'
                              : 'assets/images/venus.png',
                          width: 20.0,
                          height: 20.0,
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                Column(
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
                          'ملاحظات',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _noteController,
                      maxLines: null,
                      // Allows for multiple lines
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        hintText: 'أدخل ملاحظاتك(إختياري)',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20, left: 20, right: 10, bottom: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 185, 255, 1),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 7,
                                offset: Offset(0, 0))
                          ]),
                      child: TextButton(
                        onPressed: () {
                          selectDate(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              color: CupertinoColors.white,
                            ),
                            Text(
                              'حدد تاريخ الحجز',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(formattedSelectedDate == ''
                        ? 'لم يتم اختيار تاريخ'
                        : formattedSelectedDate),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row (
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20, left: 20, right: 10, bottom: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 185, 255, 1),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 7,
                                offset: Offset(0, 0))
                          ]),
                      child: TextButton(
                        onPressed: () => birthdayDate(context),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cake,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'حدد تاريخ ميلاد',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      selectedBirthday != null
                          ? ' ${DateFormat('dd/MM/yyyy').format(selectedBirthday!)}'
                          : 'لم يتم تحديد تاريخ ميلاد',
                    ),
                  ],
                ),
                Text('العمر: $age years'),
                const SizedBox(height: 20),
                Column(
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
                          'إختر وقت الحجز ',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 0),
                                blurRadius: 7)
                          ]),
                      height: 350,
                      child: generateTimeIntervals(),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  margin: const EdgeInsets.only(
                      left: 30, right: 30, top: 40, bottom: 20),
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 185, 255, 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      final User? user = _auth.currentUser;
                      _formSubmitted = true;
                      if(!_validateName()){
                        error_message('خطا في المدخلات','الرجاء ادخال الاسم الثلاثي');}
                     else if(!_validateNumber()){
                        error_message('خطا في المدخلات','يجب ان يتكون الرقم من 9 ارقام');
                     }

                      else if (_selectedGender == '') {
                        error_message('خطاء في المدخلات', 'الرجاء اختيار الجنس');
                      }
                      else if (formattedSelectedDate == '') {
                        error_message(
                            'خطاء في المدخلات', 'الرجاء اختيار تاريخ الحجز');
                      }
                      else if (age <=0) {
                        error_message(
                            'خطاء في المدخلات', 'الرجاء اختيار تاريخ ميلاد صحيح');
                      }
                      else if (selectedText == '') {
                        error_message(
                            'خطاء في المدخلات', 'الرجاء اختيار وقت الحجز');
                      }
                      else if (_phoneNumberController.text.length < 9) {
                      } else if (!_validateName()) {
                      } else {
                        String name = _nameController.text;
                        String number = _phoneNumberController.text;
                        String Note = _noteController.text;
                        final appointmentData = {
                          'patientName': name,
                          'patientNumber': number,
                          'appointmentTime': selectedText,
                          'patientGender': _selectedGender,
                          'patientNote': Note,
                          'appointmentDate': formattedSelectedDate,
                          'doctorsWorkTime': DoctorInfo['workTime'],
                          'doctorsLeaveTime': DoctorInfo['leaveTime'],
                          'doctorId': DoctorInfo['doctorID'],
                          'doctorName': DoctorInfo['name'],
                          'price': DoctorInfo['price'],
                          'doctorLocation': DoctorInfo['location'],
                          'DoctorLatitude': DoctorInfo['DoctorLatitude'],
                          'DoctorLongitude': DoctorInfo['DoctorLatitude'],
                          'patientID': user?.uid,
                          'status': 'unConfirmed',
                          'dateOfReservation': DateTime.now(),
                          'timeIndex': selectedIndex,
                          'birthday':selectedBirthday,
                          'age':age
                        };
                        print(appointmentData);
                        Get.to(ConfirmAppointment(
                            appointmentInfo: appointmentData,
                            doctorInfo: DoctorInfo));
                      }
                    },
                    child: const Text(
                      'أحجز',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  bool _validateName() {
    final String input = _nameController.text;
    final List<String> values = input.split(RegExp('[ ]'));
    return values.length >= 3;
  }

  bool _validateNumber() {
    final String input = _phoneNumberController.text;
    if (input.length == 9) {
      return true;
    } else
      return false;
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

  Widget generateTimeIntervals() {
    List<DateTime> timeIntervals = [];
    DateTime startTime = DoctorInfo['workTime'].toDate();
    DateTime endTime = DoctorInfo['leaveTime'].toDate();

    DateTime currentTime = startTime;

    while (currentTime.isBefore(endTime)) {
      timeIntervals.add(currentTime);
      currentTime = currentTime.add(const Duration(minutes: 30));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        childAspectRatio: 2,
      ),
      itemCount: timeIntervals.length,
      itemBuilder: (context, index) {
        final time = timeIntervals[index];

        final startTimeFormatted = DateFormat('hh:mm a', 'ar')
            .format(time)
            .replaceAll('AM', 'ص')
            .replaceAll('PM', 'م');

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
              selectedText = startTimeFormatted;
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin:
                const EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 10),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: selectedIndex == index
                  ? const Color.fromRGBO(0, 185, 255, 1) // Selected color
                  : Colors.transparent, // Default color
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              '$startTimeFormatted ',
              style: TextStyle(
                color: selectedIndex == index ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        formattedSelectedDate = selectedDate != null
            ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
            : 'No date selected';
      });
    }
  }

  Future<void> birthdayDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedBirthday) {
      setState(() {
        selectedBirthday = picked;
        calculateAge();
      });
    }
  }

  void calculateAge() {
    print(selectedBirthday);
    if (selectedBirthday != null) {
      final now = DateTime.now();
      final ageDifference = now.difference(selectedBirthday!);
      age = (ageDifference.inDays / 365).floor();
      print(age);
    } else {
      age = 0;
    }
  }
}
