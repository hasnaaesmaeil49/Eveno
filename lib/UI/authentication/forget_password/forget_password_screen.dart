import 'package:evently_app/UI/tabs/tabs_widgets/custom_elevated_button.dart';
import 'package:evently_app/UI/tabs/tabs_widgets/custom_text_field.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_images.dart';
import 'package:evently_app/utls/app_routes.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('من فضلك أدخل البريد الإلكتروني!')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.')),
      );
      Navigator.of(context).pushReplacementNamed(AppRouting.routeLogin);
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ، حاول مرة أخرى.';
      if (e.code == 'user-not-found') {
        message = 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني!';
      } else if (e.code == 'invalid-email') {
        message = 'صيغة البريد الإلكتروني غير صحيحة!';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).brightness == Brightness.dark
        ? AppColor.babyBlueColor
        : AppColor.greyColor;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.forget_password2,
          style: Theme.of(context).brightness == Brightness.dark
              ? AppStyle.blue16bold
              : AppStyle.black16Bold,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.primaryDark
            : AppColor.whiteColor,
        iconTheme: Theme.of(context).brightness == Brightness.dark
            ? const IconThemeData(color: AppColor.babyBlueColor)
            : IconThemeData(color: AppColor.blackColor),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                AppImages.forgetpasswordLight,
                height: height * 0.35,
              ),
              SizedBox(height: height * 0.02),
              CustomTextField(
                controller: emailController,
                style: Theme.of(context).brightness == Brightness.dark
                    ? AppStyle.white16Medium
                    : AppStyle.grey16Medium,
                borderColor: borderColor,
                hintText: AppLocalizations.of(context)!.email,
                prefixIcon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(AppImages.emailIconDark)
                    : Image.asset(AppImages.emailIconLight),
              ),
              SizedBox(height: height * 0.02),
              CustomElevatedButton(
                text: AppLocalizations.of(context)!.reset_password,
                textStyle: AppStyle.white20Medium,
                onClickedButton: resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}