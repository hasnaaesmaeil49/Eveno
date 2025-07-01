import 'package:Eveno/UI/authentication/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Eveno/utls/app_colo.dart';
import 'package:Eveno/utls/app_images.dart';
import 'package:Eveno/utls/app_routes.dart';
import 'package:Eveno/utls/app_style.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:Eveno/UI/home/home_screen.dart';
import 'package:Eveno/UI/tabs/tabs_widgets/custom_elevated_button.dart';

import '../../../dialog_utils.dart';
import '../../tabs/tabs_widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@(gmail\.com|yahoo\.com)$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8 && RegExp(r'[A-Za-z]').hasMatch(password);
  }

  Future<UserCredential> signInWithGoogle() async {
   final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signUpWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      DialogUtils.showLoading(context: context, message: 'loading');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(
          context: context,
          content: ' تم إنشاء الحساب بنجاح!',
          posName: 'ok',
          title: 'انشاء حساب',
          posAction: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              ));
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ، حاول مرة أخرى.';
      if (e.code == 'email-already-in-use') {
        message = 'البريد الإلكتروني مستخدم بالفعل!';
      } else if (e.code == 'invalid-email') {
        message = 'صيغة البريد الإلكتروني غير صحيحة!';
      } else if (e.code == 'weak-password') {
        message = 'كلمة السر ضعيفة جدًا!';
      }
      DialogUtils.hideLoading(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Color borderColor = Theme.of(context).brightness == Brightness.dark
        ? AppColor.babyBlueColor
        : AppColor.greyColor;
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
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: height * 0.02),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                    validator: (value) =>
                        value!.isEmpty ? 'الاسم مطلوب!' : null),
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
                  validator: (value) => value!.isEmpty
                      ? 'البريد الإلكتروني مطلوب!'
                      : ((!isValidEmail(value))
                          ? 'البريد الإلكتروني غير صحيح!'
                          : null),
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
                    onTap: () =>
                        setState(() => obscurePassword = !obscurePassword),
                    child: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColor.babyBlueColor,
                    ),
                  ),
                  obscureText: obscurePassword,
                  validator: (value) => value!.isEmpty
                      ? 'كلمة السر مطلوبة!'
                      : (!isValidPassword(value) ? 'كلمة السر ضعيفة!' : null),
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
                    onTap: () => setState(
                        () => obscureConfirmPassword = !obscureConfirmPassword),
                    child: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColor.babyBlueColor,
                    ),
                  ),
                  obscureText: obscureConfirmPassword,
                  validator: (value) => value != passwordController.text
                      ? 'كلمة السر غير متطابقة!'
                      : null,
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
                  onClickedButton: () async {
                    try {
                      DialogUtils.showLoading(context: context, message: 'جاري تسجيل الدخول...');
                      final userCredential = await signInWithGoogle();
                      DialogUtils.hideLoading(context);

                      if (userCredential.user != null) {
                        DialogUtils.showMessage(
                          context: context,
                          title: 'نجاح',
                          content: 'تم تسجيل الدخول باستخدام جوجل بنجاح',
                          posName: 'موافق',
                          posAction: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                                  (route) => false,
                            );
                          },
                        );
                      }
                    } catch (e) {
                      DialogUtils.hideLoading(context);
                      print('Google Sign-In Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('فشل تسجيل الدخول باستخدام جوجل')),
                      );
                    }
                  },
                ),
                SizedBox(height: height * 0.02),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(AppRouting.routeLogin),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .already_have_account,
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
                      border:
                          Border.all(color: AppColor.babyBlueColor, width: 2),
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
      ),
    );
  }
}
