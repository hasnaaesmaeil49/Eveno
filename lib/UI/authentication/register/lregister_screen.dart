import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_images.dart';
import 'package:evently_app/utls/app_routes.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:evently_app/UI/tabs/tabs_widgets/custom_elevated_button.dart';
import 'package:evently_app/UI/tabs/tabs_widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:evently_app/UI/home/home_screen.dart'; // إضافة استدعاء الهوم اسكرين

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@(gmail\.com|yahoo\.com)$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8 && RegExp(r'[A-Za-z]').hasMatch(password);
  }

  Future<void> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // هنا التعديل: فتح الهوم وإزالة باقي الشاشات
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل تسجيل الدخول باستخدام جوجل')),
      );
    }
  }

  // ✅ تم تعديل هذه الدالة فقط
  Future<void> signUpWithEmailPassword() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الاسم مطلوب!')),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('البريد الإلكتروني مطلوب!')),
      );
      return;
    }

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('البريد الإلكتروني غير صحيح!')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة السر مطلوبة!')),
      );
      return;
    }

    if (!isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة السر يجب أن تكون ٨ أحرف على الأقل وتحتوي على حرف!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة السر وتأكيدها غير متطابقين!')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الحساب بنجاح!')),
      );

// الانتقال للهوم مباشرة
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );

    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ، حاول مرة أخرى.';
      if (e.code == 'email-already-in-use') {
        message = 'البريد الإلكتروني مستخدم بالفعل!';
      } else if (e.code == 'invalid-email') {
        message = 'صيغة البريد الإلكتروني غير صحيحة!';
      } else if (e.code == 'weak-password') {
        message = 'كلمة السر ضعيفة جدًا!';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
          AppLocalizations.of(context)!.register,
          style: Theme.of(context).brightness == Brightness.dark
              ? AppStyle.blue16bold
              : AppStyle.black16Bold,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.primaryDark
            : AppColor.whiteColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.babyBlueColor
              : AppColor.blackColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(AppImages.logo, height: height * 0.2),
              SizedBox(height: height * 0.02),
              CustomTextField(
                controller: nameController,
                style: Theme.of(context).brightness == Brightness.dark
                    ? AppStyle.white16Medium
                    : AppStyle.grey16Medium,
                borderColor: borderColor,
                hintText: AppLocalizations.of(context)!.name,
                prefixIcon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppImages.userIconDark
                      : AppImages.userIconLight,
                ),
              ),
              SizedBox(height: height * 0.02),
              CustomTextField(
                controller: emailController,
                style: Theme.of(context).brightness == Brightness.dark
                    ? AppStyle.white16Medium
                    : AppStyle.grey16Medium,
                borderColor: borderColor,
                hintText: AppLocalizations.of(context)!.email,
                prefixIcon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppImages.emailIconDark
                      : AppImages.emailIconLight,
                ),
              ),
              SizedBox(height: height * 0.02),
              CustomTextField(
                controller: passwordController,
                style: Theme.of(context).brightness == Brightness.dark
                    ? AppStyle.white16Medium
                    : AppStyle.grey16Medium,
                borderColor: borderColor,
                hintText: AppLocalizations.of(context)!.password,
                prefixIcon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppImages.passwordIconDark
                      : AppImages.passwordIconLight,
                ),
                suffixIcon: InkWell(
                  onTap: () => setState(() => obscurePassword = !obscurePassword),
                  child: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColor.babyBlueColor,
                  ),
                ),
                obscureText: obscurePassword,
              ),
              SizedBox(height: height * 0.02),
              CustomTextField(
                controller: confirmPasswordController,
                style: Theme.of(context).brightness == Brightness.dark
                    ? AppStyle.white16Medium
                    : AppStyle.grey16Medium,
                borderColor: borderColor,
                hintText: AppLocalizations.of(context)!.re_password,
                prefixIcon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppImages.passwordIconDark
                      : AppImages.passwordIconLight,
                ),
                suffixIcon: InkWell(
                  onTap: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                  child: Icon(
                    obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColor.babyBlueColor,
                  ),
                ),
                obscureText: obscureConfirmPassword,
              ),
              SizedBox(height: height * 0.02),
              CustomElevatedButton(
                text: AppLocalizations.of(context)!.create_account,
                textStyle: AppStyle.white20Medium,
                onClickedButton: signUpWithEmailPassword,
              ),
              SizedBox(height: height * 0.02),
              CustomElevatedButton(
                text: 'إنشاء حساب باستخدام جوجل',
                textStyle: AppStyle.white20Medium,
                onClickedButton: signUpWithGoogle,
              ),
              SizedBox(height: height * 0.02),
              InkWell(
                onTap: () => Navigator.of(context).pushReplacementNamed(AppRouting.routeLogin),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.already_have_account,
                        style: Theme.of(context).brightness == Brightness.dark
                            ? AppStyle.white16Medium
                            : AppStyle.black16Medium,
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.login,
                        style: AppStyle.blue16Medium.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.babyBlueColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: Container(
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColor.babyBlueColor, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(AppImages.americaIcon),
                      Image.asset(AppImages.egyptIcon),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}