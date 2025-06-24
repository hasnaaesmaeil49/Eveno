import 'package:evently_app/UI/tabs/favorite_tab/favorite.dart';
import 'package:evently_app/UI/tabs/home_tab/home.dart';
import 'package:evently_app/UI/tabs/map_tab/map.dart';
import 'package:evently_app/UI/tabs/profile_tab/profile.dart';
import 'package:evently_app/providers/eventList_proider.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_images.dart';
import 'package:evently_app/utls/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/providers/app_language_provider.dart';
import'package:evently_app/UI/tabs/home_tab/home_widgets/eventCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<Widget> tabs = const [
    HomeTab(),
    MapTab(),
    favoriteTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);
    final languageProvider = Provider.of<AppLanguageProvider>(context);
    var events = Provider.of<EventListProvider>(context).eventList;
    ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(event: events[index]);
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.primaryDark
            : AppColor.babyBlueColor,
        //title: Text(AppLocalizations.of(context)!.home,
        //style: const TextStyle(color: AppColor.whiteColor)),
        //centerTitle: true,
        //iconTheme: const IconThemeData(color: AppColor.whiteColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.wb_sunny),
            onPressed: () {
              final newTheme = themeProvider.appTheme == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
              themeProvider.changeTheme(newTheme);
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final currentLang = languageProvider.appLanguage;
              final newLang = currentLang == 'en' ? 'ar' : 'en';
              languageProvider.changeLanguage(newLang);
            },
          ),
        ],
      ),
      body: tabs[selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColor.transparentColor,
        ),
        child: BottomAppBar(
          padding: EdgeInsets.zero,
          shape: const CircularNotchedRectangle(),
          notchMargin: 4,
          color: Theme.of(context).primaryColor,
          child: BottomNavigationBar(
            items: [
              buildBottomNavItem(AppImages.home,
                  AppLocalizations.of(context)!.home, AppImages.homeFill, 0),
              buildBottomNavItem(AppImages.map,
                  AppLocalizations.of(context)!.map, AppImages.mapFill, 1),
              buildBottomNavItem(AppImages.heart,
                  AppLocalizations.of(context)!.love, AppImages.heartFill, 2),
              buildBottomNavItem(AppImages.profile,
                  AppLocalizations.of(context)!.profile, AppImages.profileFill, 3),
            ],
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRouting.routeAddEvent);
        },
        child: const Icon(
          Icons.add,
          size: 25,
          color: AppColor.whiteColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BottomNavigationBarItem buildBottomNavItem(
      String image, String label, String fullImage, int index) {
    return BottomNavigationBarItem(
      icon:
      ImageIcon(AssetImage(selectedIndex == index ? fullImage : image)),
      label: label,
    );
  }
}