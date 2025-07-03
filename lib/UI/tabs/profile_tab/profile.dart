// import 'package:Eveno/UI/tabs/profile_tab/profile_widgets/language_dialoge.dart';
// import 'package:Eveno/UI/tabs/profile_tab/profile_widgets/theme_dialoge.dart';
// import 'package:Eveno/providers/app_language_provider.dart';
// import 'package:Eveno/providers/app_theme_provider.dart';
// import 'package:Eveno/utls/app_colo.dart';
// import 'package:Eveno/utls/app_images.dart';
// import 'package:Eveno/utls/app_style.dart';
// import 'package:flutter/material.dart';
// import 'package:Eveno/l10n/app_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:Eveno/UI/authentication/login/login_screen.dart';
// import 'package:Eveno/UI/tabs/profile_tab/my_events.dart';
//
// class ProfileTab extends StatefulWidget {
//   const ProfileTab({super.key});
//
//   @override
//   State<ProfileTab> createState() => _ProfileTabState();
// }
//
// class _ProfileTabState extends State<ProfileTab> {
//   @override
//   Widget build(BuildContext context) {
//     var languageProvider = Provider.of<AppLanguageProvider>(context);
//     var themeProvider = Provider.of<AppThemeProvider>(context);
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     TextStyle textstyle = Theme.of(context).brightness == Brightness.dark ? AppStyle.white24Bold : AppStyle.black20Bold;
//
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // الـ Header (تقليص الحجم)
//           Container(
//             padding: EdgeInsets.only(
//               top: height * 0.015, // تقليص المسافة العلوية
//               left: width * 0.02,
//               right: width * 0.02,
//             ),
//             height: height * 0.18, // تقليص الارتفاع لـ 18%
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45)),
//               color: AppColor.babyBlueColor,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 SizedBox(width: width * 0.02), // تقليص المسافة الجانبية
//                 Image.asset(
//                   AppImages.profileFill,
//                   height: 60, // تحديد ارتفاع الصورة
//                   width: 60,  // تحديد عرض الصورة
//                 ),
//                 SizedBox(width: width * 0.015), // تقليص المسافة بين الصورة والنص
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("hi, dear", style: AppStyle.white24Bold), // تقليص حجم النص
//                       Text(
//                         "welcome to your profile",
//                         style: AppStyle.white16Medium, // تقليص حجم النص
//                         maxLines: 1, // تحديد سطر واحد
//                         overflow: TextOverflow.ellipsis, // إذا زاد، يقطع بـ "..."
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // الجزء السفلي (البيانات)
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: width * 0.04,
//                 vertical: height * 0.02,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     AppLocalizations.of(context)!.language,
//                     style: textstyle,
//                   ),
//                   SizedBox(height: height * 0.015), // تقليص المسافة
//                   GestureDetector(
//                     onTap: showLanguageDialog,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: width * 0.02,
//                         vertical: height * 0.01,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: AppColor.babyBlueColor,
//                           width: width * 0.008,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             languageProvider.appLanguage == "en"
//                                 ? AppLocalizations.of(context)!.english
//                                 : AppLocalizations.of(context)!.arabic,
//                             style: AppStyle.blue20bold,
//                           ),
//                           const Icon(
//                             Icons.arrow_drop_down,
//                             size: 35,
//                             color: AppColor.babyBlueColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: height * 0.015), // تقليص المسافة
//                   Text(
//                     AppLocalizations.of(context)!.theme,
//                     style: textstyle,
//                   ),
//                   SizedBox(height: height * 0.015), // تقليص المسافة
//                   GestureDetector(
//                     onTap: showThemeDialog,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: width * 0.02,
//                         vertical: height * 0.01,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: AppColor.babyBlueColor,
//                           width: width * 0.008,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             themeProvider.appTheme == ThemeMode.light
//                                 ? AppLocalizations.of(context)!.light
//                                 : AppLocalizations.of(context)!.dark,
//                             style: AppStyle.blue20bold,
//                           ),
//                           const Icon(
//                             Icons.arrow_drop_down,
//                             size: 35,
//                             color: AppColor.babyBlueColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: height * 0.015), // تقليص المسافة
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => const MyeventsPage()),
//                       );
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: width * 0.02,
//                         vertical: height * 0.01,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: AppColor.babyBlueColor,
//                           width: width * 0.008,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             AppLocalizations.of(context)!.my_events,
//                             style: AppStyle.blue20bold,
//                           ),
//                           const Icon(
//                             Icons.arrow_drop_down,
//                             size: 35,
//                             color: AppColor.babyBlueColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: width * 0.04,
//               vertical: height * 0.02,
//             ),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: width * 0.04,
//                   vertical: height * 0.02,
//                 ),
//                 backgroundColor: AppColor.babyBlueColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(AppImages.logoutIcon),
//                   SizedBox(width: width * 0.02),
//                   Text(AppLocalizations.of(context)!.logout, style: AppStyle.white24Bold),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showLanguageDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => LanguageDialoge(),
//     );
//   }
//
//   void showThemeDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => ThemeDialoge(),
//     );
//   }
// }
import 'package:Eveno/UI/tabs/profile_tab/profile_widgets/language_dialoge.dart';
import 'package:Eveno/UI/tabs/profile_tab/profile_widgets/theme_dialoge.dart';
import 'package:Eveno/providers/app_language_provider.dart';
import 'package:Eveno/providers/app_theme_provider.dart';
import 'package:Eveno/utls/app_colo.dart';
import 'package:Eveno/utls/app_images.dart';
import 'package:Eveno/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Eveno/UI/authentication/login/login_screen.dart';
import 'package:Eveno/UI/tabs/profile_tab/my_events.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    extractUsernameFromEmail();
  }

  void extractUsernameFromEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      final email = user.email!;
      final name = email.split('@').first;
      setState(() {
        _username = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextStyle textstyle = Theme.of(context).brightness == Brightness.dark ? AppStyle.white24Bold : AppStyle.black20Bold;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: height * 0.015,
              left: width * 0.02,
              right: width * 0.02,
            ),
            height: height * 0.18,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45)),
              color: AppColor.babyBlueColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: width * 0.02),
                Image.asset(
                  AppImages.profileFill,
                  height: 60,
                  width: 60,
                ),
                SizedBox(width: width * 0.015),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hi, ${_username.isNotEmpty ? _username : 'dear'} ♥',
                        style: AppStyle.white24Bold,
                      ),
                      Text(
                        "welcome to your profile",
                        style: AppStyle.white16Medium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: textstyle,
                  ),
                  SizedBox(height: height * 0.015),
                  GestureDetector(
                    onTap: showLanguageDialog,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColor.babyBlueColor,
                          width: width * 0.008,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languageProvider.appLanguage == "en"
                                ? AppLocalizations.of(context)!.english
                                : AppLocalizations.of(context)!.arabic,
                            style: AppStyle.blue20bold,
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 35,
                            color: AppColor.babyBlueColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  Text(
                    AppLocalizations.of(context)!.theme,
                    style: textstyle,
                  ),
                  SizedBox(height: height * 0.015),
                  GestureDetector(
                    onTap: showThemeDialog,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColor.babyBlueColor,
                          width: width * 0.008,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            themeProvider.appTheme == ThemeMode.light
                                ? AppLocalizations.of(context)!.light
                                : AppLocalizations.of(context)!.dark,
                            style: AppStyle.blue20bold,
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 35,
                            color: AppColor.babyBlueColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MyeventsPage()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColor.babyBlueColor,
                          width: width * 0.008,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.my_events,
                            style: AppStyle.blue20bold,
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 35,
                            color: AppColor.babyBlueColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.02,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),
                backgroundColor: AppColor.babyBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logoutIcon),
                  SizedBox(width: width * 0.02),
                  Text(AppLocalizations.of(context)!.logout, style: AppStyle.white24Bold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => LanguageDialoge(),
    );
  }

  void showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => ThemeDialoge(),
    );
  }
}