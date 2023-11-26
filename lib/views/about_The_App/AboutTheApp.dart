// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/constants.dart';

class aboutTheApp extends StatefulWidget {
  @override
  State<aboutTheApp> createState() => _aboutTheAppState();
}

class _aboutTheAppState extends State<aboutTheApp> {
  var _switchValue = false;

  @override
  // صفحه Terms of use
  Widget build(BuildContext context) {
    // دالة build هي المسؤولة عن بناء وعرض واجهة التطبيق
    return Scaffold(
        appBar: AppBar(
          // شريط العنوان في الجزء العلوي من الواجهة
          title:  Text(
            (_switchValue==true)?
            "عن التطبيق":'About the App',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          // عنصر يتيح للمستخدم التمرير في الواجهة في حال تعدى محتواها حجم الشاشة
          child: Column(
            children: [
              Switch(
                value: _switchValue,
                onChanged: (value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
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
                    child: (_switchValue == true)
                        ? Column(
                            children: [
                              // عنوان المقالة
                              Padding (
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  'عن التطبيق',
                                  style: TextStyle(
                                      fontSize: 15, color: primaryColor),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  """ تطبيقناهو تطبيق يسهل عملية عملية الرعاية الصحية والمواعيد مع الأطباء. يتيح للمستخدمين البحث عن الأطباء المؤهلين ومشاهدة مواقعهم على الخريطة، وحجز المواعيد بسهولة عبر الهاتف المحمول. يوفر التطبيق أيضًا ميزات الدردشة والمكالمة الفيديو لتسهيل التواصل بين المستخدمين والأطباء.

مع تطبيقنا، يمكنك:

البحث عن أطباء مؤهلين: يوفر التطبيق قاعدة بيانات تضم مجموعة واسعة من الأطباء المؤهلين في مختلف التخصصات. يمكنك البحث عن الأطباء المناسبين وعرض معلوماتهم الشخصية وتقييمات المرضى السابقين.

حجز المواعيد بسهولة: يوفر التطبيق واجهة سهلة الاستخدام لحجز المواعيد مع الأطباء المفضلين لديك. يمكنك اختيار التوقيت المناسب وتأكيد الموعد على الفور من خلال التطبيق.

التواصل المباشر: يمكنك استخدام ميزات الدردشة والمكالمة الفيديو للتواصل المباشر مع الأطباء. يمكنك طرح الأسئلة، وطلب المشورة الطبية، ومشاركة التقارير الطبية، والحصول على التوجيهات اللازمة - كل ذلك من خلال التطبيق.

سرية وأمان البيانات: نحرص على حماية خصوصية معلوماتك الشخصية ونضمن سرية بياناتك. نحن نتبع ممارسات أمان قوية لحماية معلوماتك وضمان سلامتها.

تطبيقنا هو شريكك في رحلتك نحو الرعاية الصحية المحسّنة وتسهيل التواصل مع الأطباء. قم بتنزيل التطبيق الآن واستمتع بتجربة سلسة ومريحة للحصول على الرعاية الصحية التي تحتاجها.""",
                                  style: TextStyle(
                                      overflow: TextOverflow.clip, height: 1.5),
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              // عنوان المقالة
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  'About the App',
                                  style: TextStyle(
                                      fontSize: 15, color: primaryColor),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                  """Our app is an advanced application designed to facilitate the process of accessing healthcare and booking appointments with doctors. It allows users to search for qualified doctors, view their locations on a map, and easily schedule appointments through their mobile devices. The app also provides chat and video call features to facilitate communication between users and doctors.

With our app, you can:

Find qualified doctors:The app provides a comprehensive database of qualified doctors in various specialties. You can search for suitable doctors and view their personal information and ratings from previous patients.

Easily book appointments: The app offers a user-friendly interface for scheduling appointments with your preferred doctors. You can choose a convenient time and instantly confirm the appointment through the app.

Direct communication: You can use the chat and video call features to communicate directly with doctors. You can ask questions, seek medical advice, share medical reports, and receive necessary guidance, all through the app.

Data privacy and security: We prioritize the protection of your personal information and ensure the confidentiality of your data. We follow strong security practices to safeguard your information and ensure its safety.

Our app is your companion in your journey towards improved healthcare and facilitates seamless communication with doctors. Download the app now and enjoy a smooth and convenient experience for accessing the healthcare you need.""",
                                  style: TextStyle(
                                      overflow: TextOverflow.clip, height: 1.5),
                                ),
                              )
                            ],
                          )),
              ),
            ],
          ),
        ));
  }
}
