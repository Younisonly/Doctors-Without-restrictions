// Copy Right Warning message
// copy_right_warning = "All rights reserved. Unauthorized copying is prohibited."

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/constants.dart';


class Terms extends StatefulWidget {
  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  var _switchValue = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title:  Text(
            (_switchValue==true)?
            "شروط الاستخدام":'Terms of Use',
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
                  child:(_switchValue == true)
                      ? Column(
                    children: [
                      // عنوان المقالة
                      Padding(
                        padding: const EdgeInsets.only(top:15),
                        child: Text(
                          'شروط الاستخدام',
                          style: TextStyle(
                              fontSize: 15, color: primaryColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          """
يرجى قراءة هذه الشروط بعناية قبل استخدام التطبيق. تنظم هذه الشروط الوصول إلى التطبيق واستخدامه. من خلال استخدام التطبيق، فإنك توافق على الالتزام بموجب هذه الشروط.

استخدام التطبيق:
أ. الأهلية: يجب أن تكون على الأقل في سن 13 عامًا لاستخدام التطبيق. من خلال استخدام التطبيق، فإنك تعلن وتضمن أنك تستوفي متطلبات الأهلية.
ب. الترخيص: بشرط الامتثال لهذه الشروط، نمنحك ترخيصًا محدودًا غير حصري وغير قابل للنقل وقابل للسحب للوصول إلى التطبيق واستخدامه للاستخدام الشخصي غير التجاري.
ج. السلوك المحظور: توافق على عدم الانخراط في أي سلوك قد يعطل أو يتداخل مع عمل التطبيق، أو أن يكون غير قانوني أو ضار أو مسيء أو مشهودًا على نحو آخر.

الملكية الفكرية:
أ. الملكية: التطبيق ومحتواه، بما في ذلك ولكن دون الاقتصار على النص والرسومات والصور والشعارات والبرامج، مملوكة لنا أو للمرخصين الخاصين بنا ومحمية بواسطة قوانين الملكية الفكرية.
ب. القيود: قد لا تقوم بنسخ أو تعديل أو توزيع أو بيع أو تأجير أو إنشاء أعمال مشتقة استنادًا إلى التطبيق أو محتواه دون الحصول على موافقتنا الكتابية المسبقة.

محتوى المستخدم:
أ. الترخيص: عن طريق تقديم أو نشر أي محتوى من خلال التطبيق، فإنك تمنحنا ترخيصًا غير حصري وخاليًا من الرسوم وعالميًا ودائمًا ولا يمكن السحب منه لاستخدام واستنساخ وتعديل وتكييف ونشر وتوزيع وعرض مثل هذا المحتوى.
ب. المسؤولية: أنت وحدك مسؤول عن المحتوى الذي تقدمه أو تنشره على التطبيق. تمثل وتضمن أن لديك جميع الحقوق اللازمة لمنح الترخيص المذكور أعلاه.

الخصوصية:
أ. سياسة الخصوصية: جمعنا واستخدمنا وكشفنا لمعلوماتك الشخصية يخضع لسياسة الالخصوصية الخاصة بنا. من خلال استخدام التطبيق، فإنك توافق على جمعنا واستخدامنا لمعلوماتك الشخصية على النحو الموضح في سياسة الخصوصية.
ب. الخدمات الخاصة بأطراف ثالثة: قد يتكامل التطبيق مع خدمات أطراف ثالثة أو يحتوي على روابط إلى مواقع ويب لأطراف ثالثة. نحن لسنا مسؤولين عن ممارسات الخصوصية أو محتوى مثل هذه الأطراف الثالثة.

إخلاء المسؤولية عن الضمان:
أ. يتم توفير التطبيق على أساس "كما هو" و "حسب التوفر" دون أي ضمانات من أي نوع، سواء صريحة أم ضمنية. نحن لا نضمن أن التطبيق سيكون غير منقطع أو خالي من الأخطاء أو آمن.
ب. نخلي نحن عن جميع الضمانات، بما في ذلك ولكن لا تقتصر على ضمانات التسويق، واللياقة لغرض معين، وعدم انتهاك الحقوق.

تحديد المسؤولية:
أ. إلى أقصى حد يسمح به القانون المعمول به، فإننا لا نتحمل أي مسؤولية عن الأضرار غير المباشرة أو العرضية أو الخاصة أو العقابية، أو أي خسارة أرباح أو عوائد، سواء تكبدها مباشرة أو غير مباشرة.
ب. في أي حالة، لا يجوز أن تتجاوز المسؤولية الإجمالية لدينا المبلغ الذي دفعته أنت، إن وجد، للوصول إلى أو استخدام التطبيق.

التعديل والإنهاء:
أ. نحتفظ بالحق في تعديل أو تعليق أو إنهاء التطبيق أو هذه الشروط في أي وقت ولأي سبب دون إشعار مسبق.
ب. يمكنك إنهاء هذه الشروط عن طريق التوقف عن استخدام التطبيق وحذفه من جهازك.

القانون المعمول به وتسوية المنازعات:
أ. يجب أن تحكم هذه الشروط وتفسر وفقًا لقوانين [السلطة القضائية]. أي نزاع ينشأ عنها أو يتعلق بها يجب أن يُقدَم إلى القضاء الحصري لمحاكم [السلطة القضائية].

القابلية للفصل:
إذا تبين أن أي بند في هذه الشروط غير صالح أو غير قانوني أو غير قابل للنفاذ، فإن البنود المتبقية ستظل سارية وفعالة.

الاتفاقية الكاملة:
تشكل هذه الشروط اتفاقية كاملة بينك وبينا فيما يتعلق باستخدامك للتطبيق، وتستبدل جميع الاتفاقات السابقة أو المتعلقة بنفس الموضوع.

إذا كان لديك أي أسئلة أو مخاوف بشأن هذه الشروط، يرجى الاتصال بنا عبر معلومات الاتصال المقدمة.

باستخدام التطبيق، فإنك تقر بأنك قد قرأت وفهمت وتوافق على الالتزام بشروط الاستخدام هذه.
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
                        padding: const EdgeInsets.only(top:15),
                        child: Text(
                          'Terms of Use',
                          style: TextStyle(
                              fontSize: 13, color: primaryColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          textAlign: TextAlign.left,
                          textDirection:TextDirection.ltr,
                          """
                         
Please read these Terms of Use ("Terms") carefully before using the app. These Terms govern your access to and use of the App. By using the App, you agree to be bound by these Terms.

Use of the App:
a. Eligibility: You must be at least 13 years old to use the App. By using the App, you represent and warrant that you meet the eligibility requirements.
b. License: Subject to your compliance with these Terms, we grant you a limited, non-exclusive, non-transferable, revocable license to access and use the App for your personal, non-commercial use.
c. Prohibited Conduct: You agree not to engage in any conduct that may disrupt or interfere with the functioning of the App, or that is unlawful, harmful, abusive, defamatory, or otherwise objectionable.

Intellectual Property:
a. Ownership: The App and its content, including but not limited to text, graphics, images, logos, and software, are owned by us or our licensors and are protected by intellectual property laws.
b. Restrictions: You may not copy, modify, distribute, sell, lease, or create derivative works based on the App or its content without our prior written consent.

User Content:
a. License: By submitting or posting any content through the App, you grant us a non-exclusive, royalty-free, worldwide, perpetual, and irrevocable license to use, reproduce, modify, adapt, publish, distribute, and display such content.
b. Responsibility: You are solely responsible for the content you submit or post on the App. You represent and warrant that you have all necessary rights to grant the aforementioned license.

Privacy:
a. Privacy Policy: Our collection, use, and disclosure of your personal information are governed by our Privacy Policy. By using the App, you consent to our collection and use of your personal information as described in the Privacy Policy.
b. Third-Party Services: The App may integrate with third-party services or contain links to third-party websites. We are not responsible for the privacy practices or content of such third parties.

Disclaimer of Warranty:
a. The App is provided on an "as is" and "as available" basis without warranties of any kind, whether express or implied. We do not warrant that the App will be uninterrupted, error-free, or secure.
b. We disclaim all warranties, including but not limited to warranties of merchantability, fitness for a particular purpose, and non-infringement.

Limitation of Liability:
a. To the maximum extent permitted by applicable law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly.
b. In no event shall our total liability exceed the amount paid by you, if any, for accessing or using the App.

Modification and Termination:
a. We reserve the right to modify, suspend, or terminate the App or these Terms at any time and for any reason without prior notice.
b. You may terminate these Terms by ceasing to use the App and deleting it from your device.

Governing Law and Dispute Resolution:
a. These Terms shall be governed by and construed in accordance with the laws of [jurisdiction]. Any dispute arising out of or relating to these Terms shall be submitted to the exclusive jurisdiction of the courts of [jurisdiction].

Severability:
If any provision of these Terms is held to be invalid, illegal, or unenforceable, the remaining provisions shall continue in full force and effect.

Entire Agreement:
These Terms constitute the entire agreement between you and us regarding the App and supersede all prior or contemporaneous understandings and agreements.

If you have any questions or concerns about these Terms, please contact us through the provided contact information.

By using the App, you acknowledge that you have read, understood, and agree to be bound by these Terms of Use.""",
                          style: TextStyle(
                              overflow: TextOverflow.clip, height: 1.5),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }}