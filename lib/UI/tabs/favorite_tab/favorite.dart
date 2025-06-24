import 'package:evently_app/UI/tabs/home_tab/home_widgets/eventCard.dart';
import 'package:evently_app/UI/tabs/tabs_widgets/custom_text_field.dart';
import 'package:evently_app/firebase/event_model.dart';
import 'package:evently_app/providers/eventList_proider.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class favoriteTab extends StatelessWidget {
  const favoriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    var eventListProvider = Provider.of<EventListProvider>(context);
    List<Event> favoriteEvents = eventListProvider.favoriteEventList;
    //if (eventListProvider.favoriteEventList.isEmpty) {
      //eventListProvider.getFavoriteEvent();
    //}

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
              prefixIcon: const Icon(
                Icons.search,
                color: AppColor.babyBlueColor,
                size: 30,
              ),
            ),
          ),
          Expanded(
            child: favoriteEvents.isEmpty
                ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .no_favorite_events_found,
                    style: Theme.of(context).brightness == Brightness.dark
                        ? AppStyle.white16bold
                        : AppStyle.black16Bold,
                  ),
                  const Icon(
                    Icons.sentiment_dissatisfied,
                    size: 40,
                    color: AppColor.redColor,
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: favoriteEvents.length,
              itemBuilder: (context, index) {
                final event = favoriteEvents[index];
                return EventCard(event: event); // نفس الكارد عشان يظهر بنفس الديزاين
              },
            )
          ),
        ],
      ),
    );
  }
}