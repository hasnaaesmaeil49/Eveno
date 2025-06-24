import 'package:evently_app/providers/app_language_provider.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
class LanguageDialoge extends StatefulWidget {
  const LanguageDialoge({super.key});

  @override
  State<LanguageDialoge> createState() => _LanguageDialogeState();
}

class _LanguageDialogeState extends State<LanguageDialoge> {
  @override
  Widget build(BuildContext context) {
    var languageProvide=Provider.of<AppLanguageProvider>(context);
    return AlertDialog(
                backgroundColor: AppColor.bgColorWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              AppLocalizations.of(context)!.language,
              style: AppStyle.black20Bold,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: languageProvide.appLanguage=="en" ? selectedItem(AppLocalizations.of(context)!.english):unSelectedItem(AppLocalizations.of(context)!.english), 
                  onTap: () {
                    languageProvide.changeLanguage("en");
                    Navigator.pop(context); 
                  },
                ),
                ListTile(
                  title: languageProvide.appLanguage=="ar" ? selectedItem(AppLocalizations.of(context)!.arabic):unSelectedItem(AppLocalizations.of(context)!.arabic), 
                  onTap: () {
                    languageProvide.changeLanguage("ar");
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
