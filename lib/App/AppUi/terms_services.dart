import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: isArabic
            ? Text(
                "شروط الخدمة",
                style: AppStyle.arabictext.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              )
            : const Text("Terms of Service"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            isArabic ? _termsTextArabic : _termsText,
            style: isArabic
                ? AppStyle.arabictext.copyWith(
                    fontSize: 18,
                    height: 1.6,
                    color: Colors.black87,
                  )
                : const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
          ),
        ),
      ),
    );
  }
}

const String _termsText = '''
Welcome to PandaLive. By downloading, accessing, or using the PandaLive mobile application (“App”), you agree to be bound by these Terms of Service (“Terms”). If you do not agree, please do not use the App.

1. Acceptance of Terms
By creating an account or using PandaLive, you confirm that you have read, understood, and agreed to these Terms.

2. Eligibility
You must be at least 13 years old to use PandaLive. If you are under 18, you may use the App only with parental or guardian consent.

3. User Accounts
You are responsible for maintaining the confidentiality of your account information. PandaLive reserves the right to suspend or terminate accounts that violate these Terms.

4. User Conduct
You agree not to upload or stream illegal, abusive, harmful, hateful, or inappropriate content. Any misuse of the App may result in account suspension.

5. Live Streaming & Content
Users are solely responsible for the content they stream or share. PandaLive does not guarantee the accuracy or legality of user-generated content and may remove content at its discretion.

6. Donations / Support
Any support or donation made through external links is voluntary. PandaLive does not process payments inside the App and is not responsible for third-party payment services.

7. Intellectual Property
All logos, trademarks, and app content belong to PandaLive. You may not copy or distribute any content without permission.

8. Termination
PandaLive may suspend or terminate your access at any time if you violate these Terms.

9. Disclaimer
The App is provided “as is” and “as available” without warranties of any kind.

10. Limitation of Liability
PandaLive is not liable for loss of data, unauthorized access, or user-generated content.

11. Changes to Terms
PandaLive may update these Terms at any time. Continued use of the App means you accept the updated Terms.

12. Contact Us
If you have any questions, contact us at:
Email: regolive0@gmail.com
''';

const String _termsTextArabic = '''
مرحبًا بك في PandaLive. من خلال تنزيل أو الوصول إلى أو استخدام تطبيق PandaLive للهاتف المحمول ("التطبيق")، فإنك توافق على الالتزام بشروط الخدمة هذه ("الشروط"). إذا كنت لا توافق، يرجى عدم استخدام التطبيق.

1. قبول الشروط
بإنشاء حساب أو استخدام PandaLive، فإنك تؤكد أنك قرأت وفهمت ووافقت على هذه الشروط.

2. الأهلية
يجب أن يكون عمرك 13 عامًا على الأقل لاستخدام PandaLive. إذا كنت دون 18 عامًا، فلا يجوز لك استخدام التطبيق إلا بموافقة أحد الوالدين أو الوصي.

3. حسابات المستخدمين
أنت مسؤول عن الحفاظ على سرية معلومات حسابك. تحتفظ PandaLive بالحق في تعليق أو إنهاء الحسابات التي تنتهك هذه الشروط.

4. سلوك المستخدم
توافق على عدم تحميل أو بث أي محتوى غير قانوني أو مسيء أو ضار أو يحض على الكراهية أو غير لائق. أي إساءة استخدام للتطبيق قد تؤدي إلى تعليق الحساب.

5. البث المباشر والمحتوى
يتحمل المستخدمون وحدهم مسؤولية المحتوى الذي يبثونه أو يشاركونه. لا تضمن PandaLive دقة أو قانونية المحتوى الذي ينشئه المستخدمون وقد تقوم بإزالته وفقًا لتقديرها.

6. التبرعات / الدعم
أي دعم أو تبرع يتم عبر روابط خارجية هو أمر طوعي. لا تقوم PandaLive بمعالجة المدفوعات داخل التطبيق ولا تتحمل مسؤولية خدمات الدفع التابعة لجهات خارجية.

7. الملكية الفكرية
جميع الشعارات والعلامات التجارية ومحتوى التطبيق مملوكة لـ PandaLive. لا يجوز لك نسخ أو توزيع أي محتوى دون إذن.

8. إنهاء الخدمة
يجوز لـ PandaLive تعليق أو إنهاء وصولك في أي وقت إذا انتهكت هذه الشروط.

9. إخلاء المسؤولية
يتم توفير التطبيق "كما هو" و"حسب توفره" دون أي ضمانات من أي نوع.

10. تحديد المسؤولية
لا تتحمل PandaLive المسؤولية عن فقدان البيانات أو الوصول غير المصرح به أو المحتوى الذي ينشئه المستخدمون.

11. التغييرات على الشروط
يجوز لـ PandaLive تحديث هذه الشروط في أي وقت. استمرارك في استخدام التطبيق يعني موافقتك على الشروط المحدثة.

12. تواصل معنا
إذا كانت لديك أي أسئلة، يرجى التواصل معنا عبر:
البريد الإلكتروني: regolive0@gmail.com
''';
