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
import 'package:evently_app/UI/home/home_screen.dart';

import '../../../dialog_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8;
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
          AppLocalizations.of(context)!.login,
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'من فضلك أدخل البريد الإلكتروني';
                    } else if (!isValidEmail(value.trim())) {
                      return 'صيغة البريد الإلكتروني غير صحيحة';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك أدخل كلمة المرور';
                    } else if (!isValidPassword(value)) {
                      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                CustomElevatedButton(
                  text: AppLocalizations.of(context)!.login,
                  textStyle: AppStyle.white20Medium,
                  onClickedButton: () async {
                    if (_formKey.currentState!.validate()) {
                      final email = emailController.text;
                      final password = passwordController.text;
                      try {
                        DialogUtils.showLoading(
                            context: context, message: 'Loading');
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        DialogUtils.hideLoading(context);
                        DialogUtils.showMessage(
                            context: context,
                            content: 'تم تسجيل الدخول بنجاج',
                            title: 'تسجيل الدخول',
                            posName: 'ok',
                            posAction: () =>
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (route) => false,
                                ));
                      } on FirebaseAuthException catch (e) {
                        String message = 'فشل تسجيل الدخول.';
                        if (e.code == 'user-not-found') {
                          message = 'لا يوجد حساب بهذا البريد.';
                        } else if (e.code == 'wrong-password') {
                          message = 'كلمة المرور غير صحيحة.';
                        } else if (e.code == 'invalid-email') {
                          message = 'صيغة البريد الإلكتروني غير صحيحة.';
                        }
                        DialogUtils.hideLoading(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      } catch (e) {
                        print('خطأ غير متوقع: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'حدث خطأ غير متوقع. برجاء المحاولة لاحقًا.')),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: height * 0.02),
                CustomElevatedButton(
                  text: 'تسجيل باستخدام جوجل',
                  textStyle: AppStyle.white20Medium,
                  onClickedButton: () async {
                    try {
                      DialogUtils.showLoading(
                          context: context, message: 'جاري تسجيل الدخول...');
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
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                              (route) => false,
                            );
                          },
                        );
                      }
                    } catch (e) {
                      DialogUtils.hideLoading(context);
                      print('Google Sign-In Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('فشل تسجيل الدخول باستخدام جوجل')),
                      );
                    }
                  },
                ),
                SizedBox(height: height * 0.02),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(AppRouting.routeRegister),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.doNotHaveAccount,
                          style: Theme.of(context).brightness == Brightness.dark
                              ? AppStyle.white16Medium
                              : AppStyle.black16Medium,
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.register,
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
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed(AppRouting.routeForgetPassword),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.forget_password2,
                      style: AppStyle.blue16Medium.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.babyBlueColor,
                      ),
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
