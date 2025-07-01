
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import '../../../firebase/event_model.dart';
import '../../../firebase/firebaseUtls.dart';
import '../../../providers/eventList_proider.dart';
import '../../../utls/app_colo.dart';
import '../../../utls/app_style.dart';
import '../edit_event/edit_event.dart';
import 'home_widgets/eventCard.dart';
import 'home_widgets/tab_event_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  late Future<List<Event>> futureEvents;
  String searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<EventListProvider>(context, listen: false)
        .getEventNameList(context);
  }

  @override
  void initState() {
    super.initState();
    final eventProvider = Provider.of<EventListProvider>(context, listen: false);
    futureEvents = eventProvider.getEventsFromFirestore();
    eventProvider.getFavoriteEvent(); // تحميل الأحداث المفضلة
  }

  void applySearchFilter(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventListProvider>(context);
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
                  Text(AppLocalizations.of(context)!.welcome_back,
                      style: AppStyle.white14Bold),
                  Text("Welcome Back!", style: AppStyle.white24Bold),
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
                      SizedBox(width: width * 0.02),
                      Text("Enjoy Your Events", style: AppStyle.white14Bold),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  DefaultTabController(
                    length: eventProvider.eventNameList.length,
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          eventProvider.getSelectedIndex(index);
                        });
                      },
                      tabAlignment: TabAlignment.start,
                      indicatorColor: AppColor.transparentColor,
                      dividerColor: AppColor.transparentColor,
                      labelPadding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      isScrollable: true,
                      tabs: eventProvider.eventNameList.map((eventName) {
                        final isSelected =
                            eventProvider.selectedIndex ==
                                eventProvider.eventNameList.indexOf(eventName);
                        return TabEventWidget(
                          isSelected: isSelected,
                          eventName: eventName,
                          selectedEventDark: AppColor.babyBlueColor,
                          selectedEventLight: AppColor.whiteColor,
                          styleEventDarkSelected: AppStyle.white16Medium,
                          styleEventDarkUnSelected: AppStyle.white16Medium,
                          styleEventLightSelected: AppStyle.blue16Medium,
                          styleEventLightUnSelected: AppStyle.white16Medium,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: futureEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  var events = snapshot.data ?? [];

                  // Apply search filter if searchQuery is not empty
                  if (searchQuery.isNotEmpty) {
                    events = events
                        .where((event) => event.eventTitle
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                        .toList();
                  }

                  // Apply event type filter
                  if (eventProvider.selectedIndex != 0) {
                    final selectedType =
                    eventProvider.eventNameList[eventProvider.selectedIndex];
                    events = events.where((e) => e.eventName == selectedType).toList();
                  }

                  if (events.isEmpty) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.no_events_found,
                            style: Theme.of(context).brightness == Brightness.dark
                                ? AppStyle.white16bold
                                : AppStyle.black16Bold,
                          ),
                          const Icon(Icons.sentiment_dissatisfied,
                              size: 40, color: AppColor.redColor),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return GestureDetector(
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('تعديل'),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final updatedEvent = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditEvent(
                                          event: event,
                                          index: index,
                                        ),
                                      ),
                                    );
                                    if (updatedEvent != null) {
                                      eventProvider.updateEvent(index, updatedEvent);
                                    }
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('حذف'),
                                  onTap: () {
                                    FirebaseUtls.deleteEvent(event.id);
                                    eventProvider.deleteEvent(event.id);
                                    setState(() {
                                      futureEvents = eventProvider.getEventsFromFirestore();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                //  ListTile(
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
                                //       Provider.of<EventListProvider>(context, listen: false).updateEventFavorite(event);
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        },

                        child: EventCard(
                          event: event,
                        ),

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
