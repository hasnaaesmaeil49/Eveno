import 'package:evently_app/UI/tabs/home_tab/home_widgets/eventCard.dart';
import 'package:evently_app/UI/tabs/home_tab/home_widgets/tab_event_widget.dart';
import 'package:evently_app/providers/eventList_proider.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_images.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:evently_app/UI/tabs/edit_event/edit_event.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    var eventListProvide = Provider.of<EventListProvider>(context);
    eventListProvide.getEventNameList(context);
    if (eventListProvide.eventList.isEmpty) {
      eventListProvide.getAllEvents();
    }

    TextStyle textstyleDark = Theme.of(context).brightness == Brightness.dark
        ? AppStyle.black16Bold
        : AppStyle.blue16bold;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Color appBarColor = Theme.of(context).brightness == Brightness.dark
        ? AppColor.primaryDark
        : AppColor.babyBlueColor;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcome_back,
                    style: AppStyle.white14Bold,
                  ),
                  Text(
                    "Welcome Back!",
                    style: AppStyle.white24Bold,
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              height: height * 0.1,
              decoration: BoxDecoration(
                color: appBarColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      //Image.asset(AppImages.map),
                      SizedBox(width: width * 0.02),
                      Text(
                        "Enjoy Your Events",
                        style: AppStyle.white14Bold,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  DefaultTabController(
                    length: eventListProvide.eventNameList.length,
                    child: TabBar(
                      onTap: (index) {
                        eventListProvide.getSelectedIndex(index);
                      },
                      tabAlignment: TabAlignment.start,
                      indicatorColor: AppColor.transparentColor,
                      dividerColor: AppColor.transparentColor,
                      labelPadding:
                      EdgeInsets.symmetric(horizontal: width * 0.01),
                      isScrollable: true,
                      tabs: eventListProvide.eventNameList.map((eventName) {
                        return TabEventWidget(
                            styleEventDarkSelected: AppStyle.white16Medium,
                            styleEventDarkUnSelected: AppStyle.white16Medium,
                            styleEventLightSelected: AppStyle.blue16Medium,
                            styleEventLightUnSelected: AppStyle.white16Medium,
                            selectedEventDark: AppColor.babyBlueColor,
                            selectedEventLight: AppColor.whiteColor,
                            isSelected: eventListProvide.selectedIndex ==
                                eventListProvide.eventNameList
                                    .indexOf(eventName),
                            eventName: eventName);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final filteredEvents = eventListProvide.eventList;
                  return filteredEvents.isEmpty
                      ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.no_events_found,
                          style: Theme.of(context).brightness ==
                              Brightness.dark
                              ? AppStyle.white16bold
                              : AppStyle.black16Bold,
                        ),
                        const Icon(Icons.sentiment_dissatisfied,
                            size: 40, color: AppColor.redColor),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return GestureDetector(
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('تعديل'),

                                  onTap: () async {
                                    Navigator.pop(context); // يقفل الـ bottom sheet

                                    final updatedEvent = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditEvent(event: event, index: index),
                                      ),
                                    );

                                    if (updatedEvent != null) {
                                      Provider.of<EventListProvider>(context, listen: false)
                                          .updateEvent(index, updatedEvent);
                                    }
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('حذف'),
                                  onTap: () {
                                    eventListProvide.deleteEvent(eventListProvide.eventList[index].id);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: EventCard(event: event),
                        // child: ListTile(
                        //   title: Text(event.eventTitle),
                        //   subtitle: Text(event.eventLocation),
                        //   trailing: IconButton(
                        //     icon: Icon(
                        //       event.isFavorite
                        //           ? Icons.favorite
                        //           : Icons.favorite_border,
                        //       color: event.isFavorite
                        //           ? Colors.red
                        //           : Colors.grey,
                        //     ),
                        //     onPressed: () {
                        //       eventListProvide
                        //           .updateEventFavorite(event);
                        //     },
                        //   ),
                        // ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}