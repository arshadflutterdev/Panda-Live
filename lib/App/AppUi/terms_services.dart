import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms of Service"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            _termsText,
            style: const TextStyle(
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
