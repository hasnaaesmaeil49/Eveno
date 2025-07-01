// import 'package:Eveno/UI/tabs/favorite_tab/favorite.dart';
// import 'package:Eveno/UI/tabs/home_tab/home.dart';
// import 'package:Eveno/UI/tabs/map_tab/map.dart';
// import 'package:Eveno/UI/tabs/profile_tab/profile.dart';
// import 'package:Eveno/providers/eventList_proider.dart';
// import 'package:Eveno/utls/app_colo.dart';
// import 'package:Eveno/utls/app_images.dart';
// import 'package:Eveno/utls/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:Eveno/l10n/app_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:Eveno/providers/app_theme_provider.dart';
// import 'package:Eveno/providers/app_language_provider.dart';
// import'package:Eveno/UI/tabs/home_tab/home_widgets/eventCard.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int selectedIndex = 0;
//
//   List<Widget> tabs = const [
//     HomeTab(),
//     MapTab(),
//     favoriteTab(),
//     ProfileTab(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<AppThemeProvider>(context);
//     final languageProvider = Provider.of<AppLanguageProvider>(context);
//     var events = Provider.of<EventListProvider>(context).eventList;
//     ListView.builder(
//       itemCount: events.length,
//       itemBuilder: (context, index) {
//         return EventCard(event: events[index]);
//       },
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).brightness == Brightness.dark
//             ? AppColor.primaryDark
//             : AppColor.babyBlueColor,
//         //title: Text(AppLocalizations.of(context)!.home,
//         //style: const TextStyle(color: AppColor.whiteColor)),
//         //centerTitle: true,
//         //iconTheme: const IconThemeData(color: AppColor.whiteColor),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.wb_sunny),
//             onPressed: () {
//               final newTheme = themeProvider.appTheme == ThemeMode.dark
//                   ? ThemeMode.light
//                   : ThemeMode.dark;
//               themeProvider.changeTheme(newTheme);
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.language),
//             onPressed: () {
//               final currentLang = languageProvider.appLanguage;
//               final newLang = currentLang == 'en' ? 'ar' : 'en';
//               languageProvider.changeLanguage(newLang);
//             },
//           ),
//         ],
//       ),
//       body: tabs[selectedIndex],
//       bottomNavigationBar: Theme(
//         data: Theme.of(context).copyWith(
//           canvasColor: AppColor.transparentColor,
//         ),
//         child: BottomAppBar(
//           padding: EdgeInsets.zero,
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 4,
//           color: Theme.of(context).primaryColor,
//           child: BottomNavigationBar(
//             items: [
//               buildBottomNavItem(AppImages.home,
//                   AppLocalizations.of(context)!.home, AppImages.homeFill, 0),
//               buildBottomNavItem(AppImages.map,
//                   AppLocalizations.of(context)!.map, AppImages.mapFill, 1),
//               buildBottomNavItem(AppImages.heart,
//                   AppLocalizations.of(context)!.love, AppImages.heartFill, 2),
//               buildBottomNavItem(AppImages.profile,
//                   AppLocalizations.of(context)!.profile, AppImages.profileFill, 3),
//             ],
//             currentIndex: selectedIndex,
//             onTap: (index) {
//               setState(() {
//                 selectedIndex = index;
//               });
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).pushNamed(AppRouting.routeAddEvent);
//         },
//         child: const Icon(
//           Icons.add,
//           size: 25,
//           color: AppColor.whiteColor,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
//
//   BottomNavigationBarItem buildBottomNavItem(
//       String image, String label, String fullImage, int index) {
//     return BottomNavigationBarItem(
//       icon:
//       ImageIcon(AssetImage(selectedIndex == index ? fullImage : image)),
//       label: label,
//     );
//   }
// }
//
// import 'package:Eveno/UI/tabs/favorite_tab/favorite.dart';
// import 'package:Eveno/UI/tabs/home_tab/home.dart';
// import 'package:Eveno/UI/tabs/map_tab/map.dart';
// import 'package:Eveno/UI/tabs/profile_tab/profile.dart';
// import 'package:Eveno/providers/eventList_proider.dart';
// import 'package:Eveno/utls/app_colo.dart';
// import 'package:Eveno/utls/app_images.dart';
// import 'package:Eveno/utls/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:Eveno/l10n/app_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:Eveno/providers/app_theme_provider.dart';
// import 'package:Eveno/providers/app_language_provider.dart';
// import 'package:Eveno/UI/tabs/home_tab/home_widgets/eventCard.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int selectedIndex = 0;
//
//   List<Widget> tabs = const [
//     HomeTab(),
//     MapTab(),
//     favoriteTab(),
//     ProfileTab(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<AppThemeProvider>(context);
//     final languageProvider = Provider.of<AppLanguageProvider>(context);
//     var events = Provider.of<EventListProvider>(context).eventList;
//
//     ListView.builder(
//       itemCount: events.length,
//       itemBuilder: (context, index) {
//         return EventCard(event: events[index]);
//       },
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).brightness == Brightness.dark
//             ? AppColor.primaryDark
//             : AppColor.babyBlueColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.wb_sunny),
//             onPressed: () {
//               final newTheme = themeProvider.appTheme == ThemeMode.dark
//                   ? ThemeMode.light
//                   : ThemeMode.dark;
//               themeProvider.changeTheme(newTheme);
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.language),
//             onPressed: () {
//               final currentLang = languageProvider.appLanguage;
//               final newLang = currentLang == 'en' ? 'ar' : 'en';
//               languageProvider.changeLanguage(newLang);
//             },
//           ),
//           // Search icon
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               _showSearchScreen(context);
//             },
//           ),
//         ],
//       ),
//       body: tabs[selectedIndex],
//       bottomNavigationBar: Theme(
//         data: Theme.of(context).copyWith(
//           canvasColor: AppColor.transparentColor,
//         ),
//         child: BottomAppBar(
//           padding: EdgeInsets.zero,
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 4,
//           color: Theme.of(context).primaryColor,
//           child: BottomNavigationBar(
//             items: [
//               buildBottomNavItem(AppImages.home,
//                   AppLocalizations.of(context)!.home, AppImages.homeFill, 0),
//               buildBottomNavItem(AppImages.map,
//                   AppLocalizations.of(context)!.map, AppImages.mapFill, 1),
//               buildBottomNavItem(AppImages.heart,
//                   AppLocalizations.of(context)!.love, AppImages.heartFill, 2),
//               buildBottomNavItem(AppImages.profile,
//                   AppLocalizations.of(context)!.profile, AppImages.profileFill, 3),
//             ],
//             currentIndex: selectedIndex,
//             onTap: (index) {
//               setState(() {
//                 selectedIndex = index;
//               });
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).pushNamed(AppRouting.routeAddEvent);
//         },
//         child: const Icon(
//           Icons.add,
//           size: 25,
//           color: AppColor.whiteColor,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
//
//   BottomNavigationBarItem buildBottomNavItem(
//       String image, String label, String fullImage, int index) {
//     return BottomNavigationBarItem(
//       icon: ImageIcon(AssetImage(selectedIndex == index ? fullImage : image)),
//       label: label,
//     );
//   }
//
//   // Function to show search screen
//   void _showSearchScreen(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(AppLocalizations.of(context)!.searchEvents),
//         content: TextField(
//           onChanged: (value) {
//             // No filtering here, just collecting input
//           },
//           decoration: InputDecoration(
//             hintText: AppLocalizations.of(context)!.searchHint,
//             prefixIcon: const Icon(Icons.search),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text(AppLocalizations.of(context)!.close),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:Eveno/UI/tabs/favorite_tab/favorite.dart';
import 'package:Eveno/UI/tabs/home_tab/home.dart';
import 'package:Eveno/UI/tabs/map_tab/map.dart';
import 'package:Eveno/UI/tabs/profile_tab/profile.dart';
import 'package:Eveno/providers/eventList_proider.dart';
import 'package:Eveno/utls/app_colo.dart';
import 'package:Eveno/utls/app_images.dart';
import 'package:Eveno/utls/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:Eveno/providers/app_theme_provider.dart';
import 'package:Eveno/providers/app_language_provider.dart';
import 'package:Eveno/UI/tabs/home_tab/home_widgets/eventCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  String searchQuery = ''; // To store the search input

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
          // Search icon
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchScreen(context);
            },
          ),
        ],
      ),
      body: selectedIndex == 0
          ? HomeTab() // Pass searchQuery to HomeTab if needed
          : tabs[selectedIndex],
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
      icon: ImageIcon(AssetImage(selectedIndex == index ? fullImage : image)),
      label: label,
    );
  }

  // Function to show search screen
  void _showSearchScreen(BuildContext context) {
    String tempQuery = ''; // Temporary variable to hold input
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.searchEvents),
        content: TextField(
          onChanged: (value) {
            tempQuery = value; // Update tempQuery as user types
          },
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchHint,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.close),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                searchQuery = tempQuery; // Update searchQuery with the input
              });
              Navigator.pop(context);
              // Notify HomeTab to filter events
              if (selectedIndex == 0) {
                final homeTabState = context.findAncestorStateOfType< HomeTabState>();
                if (homeTabState != null) {
                  homeTabState.applySearchFilter(searchQuery);
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }
}
