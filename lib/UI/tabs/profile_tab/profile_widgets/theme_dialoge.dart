
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
class ThemeDialoge extends StatefulWidget {
  const ThemeDialoge({super.key});

  @override
  State<ThemeDialoge> createState() => _ThemeDialogeState();
}

class _ThemeDialogeState extends State<ThemeDialoge> {
  @override
  Widget build(BuildContext context) {
    var themeProvide=Provider.of<AppThemeProvider>(context);
    return AlertDialog(
                backgroundColor: AppColor.bgColorWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              AppLocalizations.of(context)!.theme,
              style: AppStyle.black20Bold,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: themeProvide.appTheme== ThemeMode.dark? selectedItem(AppLocalizations.of(context)!.dark):unSelectedItem(AppLocalizations.of(context)!.dark),
                  onTap: () {
                    themeProvide.changeTheme(ThemeMode.dark);
                    Navigator.pop(context); 
                  },
                ),
                ListTile(
                  title: themeProvide.appTheme==ThemeMode.light?selectedItem(AppLocalizations.of(context)!.light):unSelectedItem(AppLocalizations.of(context)!.light),
                  onTap: () {
                    themeProvide.changeTheme(ThemeMode.light);
                    Navigator.pop(context); 
                  },
                ),
              ],
            ),
          );
        }

        Widget selectedItem(String text){
          return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                            text,
                        style: AppStyle.blue20bold,
                      ),
                      const Icon(Icons.check,color: AppColor.blueColor,size: 25,),
                    ],
                  );
        }
        Widget unSelectedItem(String text){
            return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                         text,
                        style: AppStyle.black20Bold,
                      ),
                     
                    ],
                  );
        }
}
