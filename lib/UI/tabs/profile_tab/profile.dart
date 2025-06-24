import 'package:evently_app/UI/tabs/profile_tab/profile_widgets/language_dialoge.dart';
import 'package:evently_app/UI/tabs/profile_tab/profile_widgets/theme_dialoge.dart';
import 'package:evently_app/providers/app_language_provider.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_images.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:evently_app/UI/authentication/login/login_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
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
              top: height * 0.02,
              left: width * 0.02,
              right: width * 0.02,
            ),
            height: height * 0.23,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45)),
              color: AppColor.babyBlueColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: width * 0.03,),
                Image.asset(AppImages.profileFill),
                SizedBox(width: width * 0.02,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("hi,dear", style: AppStyle.white24Bold),
                      Text(
                        "welcome to your profile",
                        style: AppStyle.white16Medium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.02
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.language,
                  style: textstyle,
                ),
                SizedBox(height: height * 0.02),
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
                SizedBox(height: height * 0.02),
                Text(
                  AppLocalizations.of(context)!.theme,
                  style: textstyle,
                ),
                SizedBox(height: height * 0.02),
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
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),
                backgroundColor: AppColor.babyBlueColor, // <--- غيرت اللون هنا فقط
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
                children: [
                  Image.asset(AppImages.logoutIcon),
                  SizedBox(width: width * 0.02,),
                  Text(AppLocalizations.of(context)!.logout, style: AppStyle.white24Bold,),
                ],
              ),
            ),
          )
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