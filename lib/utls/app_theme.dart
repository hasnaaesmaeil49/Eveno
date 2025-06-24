import 'package:evently_app/utls/app_colo.dart';
import 'package:flutter/material.dart';

class AppTheme{
  static final ThemeData lightTheme=ThemeData(
    scaffoldBackgroundColor: AppColor.whiteColor,
    brightness: Brightness.light,
    primaryColor: AppColor.babyBlueColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
       showUnselectedLabels: true,
       selectedItemColor: AppColor.whiteColor,
       unselectedItemColor: AppColor.whiteColor,
       elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.babyBlueColor,
      shape: StadiumBorder(
        side: BorderSide(
          color: AppColor.whiteColor,
          width: 4,
        )
      ),
      
    ),
  );
  static final ThemeData darkTheme=ThemeData(
    scaffoldBackgroundColor: AppColor.primaryDark,
    brightness: Brightness.dark,
    primaryColor: AppColor.primaryDark,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
       showUnselectedLabels: true,
       selectedItemColor: AppColor.whiteColor,
       unselectedItemColor: AppColor.whiteColor,
       elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.primaryDark,
      shape: StadiumBorder(
        side: BorderSide(
          color: AppColor.whiteColor,
          width: 4,
        )
      ),
      
    ),
  );
  
}