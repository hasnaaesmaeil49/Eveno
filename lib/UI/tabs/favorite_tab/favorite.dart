// import 'package:Eveno/UI/tabs/home_tab/home_widgets/eventCard.dart';
// import 'package:Eveno/UI/tabs/tabs_widgets/custom_text_field.dart';
// import 'package:Eveno/firebase/event_model.dart';
// import 'package:Eveno/providers/eventList_proider.dart';
// import 'package:Eveno/utls/app_colo.dart';
// import 'package:Eveno/utls/app_style.dart';
// import 'package:flutter/material.dart';
// import 'package:Eveno/l10n/app_localizations.dart';
// import 'package:provider/provider.dart';
//
// class favoriteTab extends StatelessWidget {
//   const favoriteTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     var eventListProvider = Provider.of<EventListProvider>(context);
//     List<Event> favoriteevents = eventListProvider.favoriteEventList;
//     //if (eventListProvider.favoriteEventList.isEmpty) {
//       //eventListProvider.getFavoriteEvent();
//     //}
//
//     Color appBarColor = Theme.of(context).brightness == Brightness.dark
//         ? AppColor.primaryDark
//         : AppColor.whiteColor;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: appBarColor,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: CustomTextField(
//               hintText: AppLocalizations.of(context)!.search_for_event,
//               hintStyle: AppStyle.blue16bold,
//               style: AppStyle.blue16Medium,
//               borderColor: AppColor.babyBlueColor,
//               prefixIcon: const Icon(
//                 Icons.search,
//                 color: AppColor.babyBlueColor,
//                 size: 30,
//               ),
//             ),
//           ),
//           Expanded(
//             child: favoriteevents.isEmpty
//                 ? Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     AppLocalizations.of(context)!
//                         .no_favorite_events_found,
//                     style: Theme.of(context).brightness == Brightness.dark
//                         ? AppStyle.white16bold
//                         : AppStyle.black16Bold,
//                   ),
//                   const Icon(
//                     Icons.sentiment_dissatisfied,
//                     size: 40,
//                     color: AppColor.redColor,
//                   ),
//                 ],
//               ),
//             )
//                 : ListView.builder(
//               itemCount: favoriteevents.length,
//               itemBuilder: (context, index) {
//                 final event = favoriteevents[index];
//                 return EventCard(event: event); // نفس الكارد عشان يظهر بنفس الديزاين
//               },
//             )
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:Eveno/UI/tabs/home_tab/home_widgets/eventCard.dart';
import 'package:Eveno/UI/tabs/tabs_widgets/custom_text_field.dart';
import 'package:Eveno/firebase/event_model.dart';
import 'package:Eveno/providers/eventList_proider.dart'; // صيغة صحيحة للاسم
import 'package:Eveno/utls/app_colo.dart';
import 'package:Eveno/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  _FavoriteTabState createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  String searchQuery = ''; // متغير الحالة للبحث

  void _showSearchScreen(BuildContext context) {
    String tempQuery = ''; // متغير مؤقت لتخزين الإدخال
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.searchevents),
        content: TextField(
          onChanged: (value) {
            tempQuery = value; // تحديث tempQuery أثناء الكتابة
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
            onPressed: (){
              _showSearchScreen(context);
            },
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _applySearchFilter(String query) {
    // منطق فلترة الأحداث هنا
    final eventListProvider = Provider.of<EventListProvider>(context, listen: false);
    if (query.isNotEmpty) {
      eventListProvider.favoriteEventList = eventListProvider.favoriteEventList
          .where((event) => event.eventName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      eventListProvider.getFavoriteEvent(); // إعادة تحميل الأحداث إذا كان البحث فارغًا
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final eventListProvider = Provider.of<EventListProvider>(context);
    if (eventListProvider.favoriteEventList.isEmpty) {
      eventListProvider.getFavoriteEvent();
    }

    Color appBarColor = Theme.of(context).brightness == Brightness.dark
        ? AppColor.primaryDark
        : AppColor.whiteColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomTextField(
              hintText: AppLocalizations.of(context)!.search_for_event,
              hintStyle: AppStyle.blue16bold,
              style: AppStyle.blue16Medium,
              borderColor: AppColor.babyBlueColor,
              // prefixIcon: const Icon(
              //   Icons.search,
              //   color: AppColor.babyBlueColor,
              //   size: 30,
              // ),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: AppColor.babyBlueColor),
                onPressed: () {
                  _showSearchScreen(context);
                },
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // تحديث البحث مباشرة
                  _applySearchFilter(value); // تطبيق الفلترة فورًا
                });
              },
            ),
          ),
          Expanded(
            child: eventListProvider.favoriteEventList.isEmpty
                ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.no_favorite_events_found,
                    style: Theme.of(context).brightness == Brightness.dark
                        ? AppStyle.white16bold
                        : AppStyle.black16Bold,
                  ),
                  const Icon(Icons.sentiment_dissatisfied, size: 40, color: AppColor.redColor),
                ],
              ),
            )
                : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return EventCard(event: eventListProvider.favoriteEventList[index]);
              },
              itemCount: eventListProvider.favoriteEventList.length,
            ),
          ),
        ],
      ),
    );
  }
}