// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/constants.dart';

class Privacy extends StatefulWidget {
  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  var _switchValue=false;

  @override
  // صفحه privacy policy
  Widget build(BuildContext context) {
    // دالة build هي المسؤولة عن بناء وعرض واجهة التطبيق
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text(
                        (_switchValue==true)?
            "سياسة الخصوصية":'Privacy Policy',
            style: TextStyle(fontSize: 16),
          ),
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
                // عنصر يتيح إضافة هوامش داخلية للعناصر الداخلية في الواجهة
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    // خصائص تحكم في شكل ومظهر العنصر الخارجي (الحاوية)
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
                    Padding(
                      padding: const EdgeInsets.only(top:15),
                      child: Text(
                        'سياسة الخصوصية',
                        style: TextStyle(
                            fontSize: 15, color: primaryColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        """ في MedicalCare، نقدر ونعتبر خصوصية مستخدمينا أمرًا هامًا ونعطيه الأولوية. توضح سياسة الخصوصية هذه كيفية جمعنا واستخدامنا وكشفنا وحماية معلوماتك الشخصية عند استخدام تطبيقنا المحمول MedicalCare. من خلال استخدام تطبيقنا، فإنك توافق على الممارسات الموضحة في هذه السياسة.

المعلومات التي نجمعها:

المعلومات الشخصية: عند إنشاء حساب أو استخدام ميزات معينة في تطبيقنا، قد نجمع معلومات شخصية مثل اسمك وعنوان بريدك الإلكتروني ورقم الاتصال وتفاصيل أخرى ذات الصلة.
معلومات الاستخدام: قد نجمع معلومات حول كيفية استخدامك لتطبيقنا، بما في ذلك الميزات التي تستخدمها والإجراءات التي تتخذها ومدة استخدامك.
معلومات الجهاز: قد نجمع معلومات حول الجهاز الذي تستخدمه للوصول إلى تطبيقنا، بما في ذلك نوع الجهاز ونظام التشغيل ومعرّفات الجهاز الفريدة ومعلومات الشبكة المحمولة.

استخدام المعلومات:

تخصيص تجربتك: قد نستخدم المعلومات المجمعة لتخصيص تجربتك وتقديم محتوى ذو صلة وتحسين خدماتنا.
التواصل: قد نستخدم معلومات الاتصال الخاصة بك للتواصل معك بشأن تذكيرات المواعيد والتحديثات والعروض الترويجية ومعلومات أخرى ذات الصلة.
التحليلات والتحسينات: قد نستخدم المعلومات المجمعة لأغراض تحليلية، مثل تحليل أنماط الاستخدام وحل المشكلات وتحسين أداء ووظائف تطبيقنا.
الامتثال القانوني: قد نستخدم أو نكشف عن معلوماتك للامتثال للقوانين واللوائح والإجراءات القانونية أو طلبات الجهات الحكومية التي يمكن تنفيذها.

مشاركة المعلومات:

مزودي الخدمة الخارجيين: قد نشارك معلوماتك مع مزودي خدمات الطرف الثالث الموثوق بهم الذين يساعدوننا في تشغيل تطبيقنا ومزاولة أعمالنا وتقديم الخدمات لك. يلتزم هؤلاء المزودون بالمزودي خدمات الطرف الثالث بالحفاظ على سرية معلوماتك.
البيانات المجمعة أو المجهولة: قد نجمع المعلومات المجمعة أو المجهولة ونستخدمها لأغراض إحصائية وبحثية أو نشاركها مع أطراف ثالثة لأغراض متنوعة، بما في ذلك التسويق والإعلان.

أمان البيانات:

نقوم بتنفيذ تدابير تقنية وتنظيمية مناسبة لحماية معلوماتك الشخصية من الوصول غير المصرح به أو الكشف أو التغيير أو الإتلاف.
على الرغم من جهودنا، يرجى ملاحظة أنه لا يوجد أي طريقة لنقل البيانات عبر الإنترنت أو التخزين الإلكتروني تكون 100٪ آمنة. لا يمكننا ضمان الأمان المطلق لمعلوماتك.

خصوصية الأطفال:

تطبيقنا غير مخصص للاستخدام من قبل الأفراد الذين تقل أعمارهم عن 13 عام. نحن لا نقوم بجمع معلومات شخصية عن الأطفال بشكل معرف. إذا علمنا أننا قد جمعنا معلومات شخصية عن طفل بدون موافقة الوالدين، فسنتخذ الخطوات اللازمة لإزالة تلك المعلومات من خوادمنا.

تغييرات في سياسة الخصوصية:

نحتفظ بالحق في تعديل سياسة الخصوصية هذه في أي وقت. نشجعك على مراجعة هذه السياسة بشكل دوري للحصول على معلومات حول كيفية جمعنا واستخدامنا وحماية معلوماتك.

اتصل بنا:

إذا كان لديك أي أسئلة أو مخاوف أو طلبات بخصوص سياسة الخصوصية هذه أو استخدام معلوماتك الشخصية، يرجى الاتصال بنا.
من خلال استخدام تطبيقنا، فإنك تقر بأنك قد قرأت وفهمت سياسة الخصوصية هذه وتوافق على جمع واستخدام وكشف معلوماتك كما هو موضح فيها.
""",
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
                        'Privacy Policy',
                        style: TextStyle(
                            fontSize: 15, color: primaryColor),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                        """
At MedicalCare, we value and prioritize the privacy of our users. This Privacy Policy outlines how we collect, use, disclose, and safeguard your personal information when you use our mobile application MedicalCare. By using our app, you consent to the practices described in this policy.

Information We Collect:

Personal Information: When you create an account or use certain features of our app, we may collect personal information such as your name, email address, contact number, and other relevant details.
Usage Information: We may collect information about how you use our app, including the features you access, the actions you take, and the duration of your usage.
Device Information: We may collect information about the device you use to access our app, including the device type, operating system, unique device identifiers, and mobile network information.
Use of Information:

Personalize Your Experience: We may use the collected information to personalize your experience, provide relevant content, and improve our services.
Communication: We may use your contact information to communicate with you regarding appointment reminders, updates, promotional offers, and other relevant information.
Analytics and Improvements: We may use the collected information for analytical purposes, such as analyzing usage patterns, troubleshooting issues, and enhancing the performance and functionality of our app.
Legal Compliance: We may use or disclose your information to comply with applicable laws, regulations, legal processes, or enforceable governmental requests.
Information Sharing:

Third-Party Service Providers: We may share your information with trusted third-party service providers who assist us in operating our app, conducting our business, and providing services to you. These providers are obligated to maintain the confidentiality of your information.
Aggregated or Anonymized Data: We may aggregate or anonymize the collected information and use it for statistical and research purposes or share it with third parties for various purposes, including marketing and advertising.
Data Security:

We implement appropriate technical and organizational measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction.
Despite our efforts, please be aware that no method of data transmission over the Internet or electronic storage is 100% secure. We cannot guarantee the absolute security of your information.
Children's Privacy:

Our app is not intended for use by individuals under the age of 13. We do not knowingly collect personal information from children. If we become aware that we have collected personal information from a child without parental consent, we will take steps to remove that information from our servers.
Changes to the Privacy Policy:

We reserve the right to modify this Privacy Policy at any time. We encourage you to review this policy periodically to stay informed about how we collect, use, and protect your information.
Contact Us:

If you have any questions, concerns, or requests regarding this Privacy Policy or the use of your personal information, please contact us.
By using our app, you acknowledge that you have read and understood this Privacy Policy and agree to the collection, use, and disclosure of your information as described herein.""",

                        style: TextStyle(
                            overflow: TextOverflow.clip, height: 1.5),
                      ),
                    )
                  ],
                )
                ),
              ),
            ],
          ),
        ));
  }
}
