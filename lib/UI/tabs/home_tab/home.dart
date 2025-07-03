
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:Eveno/UI/home/home_screen.dart';
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  late Future<List<Event>> futureevents;
  String searchQuery = '';

  void _showSearchScreen(BuildContext context) {
    String tempQuery = ''; // Temporary variable to hold input
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(AppLocalizations.of(context)!.searchevents),
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
                    searchQuery =
                        tempQuery; // Update searchQuery with the input
                  });
                  Navigator.pop(context);
                  // Notify HomeTab to filter events
                  if (mounted) {
                    applySearchFilter(searchQuery);
                  }
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          ),
    );
  }

  void applySearchFilter(String query) {
    // Logic to filter events based on query
    print('Filtering with query: $query');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<EventListProvider>(context, listen: false)
        .getEventNameList(context);
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((snapshot) {
      print('عدد الأحداث: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        print("🔥 ${doc.data()}");
      }
    }).catchError((e) {
      print("🛑 حصل Error: $e");
    });

    final eventProvider = Provider.of<EventListProvider>(
        context, listen: false);
    futureevents = eventProvider.geteventsFromFirestore();
    eventProvider.getFavoriteEvent(); // تحميل الأحداث المفضلة
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
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(width: width * 0.4),
                  Text("Enjoy Your events ♥", style: AppStyle.white14Bold),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                color: appBarColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                         searchQuery = value; // تحديث البحث هنا إذا كنت تستخدم searchQuery

                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for Event',
                        //prefixIcon: Icon(Icons.search, color: AppColor.greyColor),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: AppColor.greyColor),
                          onPressed: (){
                            _showSearchScreen(context);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  // TabBar
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
            // القائمة الرئيسية مع Expanded

            Expanded(
              child: FutureBuilder<List<Event>>(
                future: futureevents,
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
                                      futureevents = eventProvider.geteventsFromFirestore();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
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
