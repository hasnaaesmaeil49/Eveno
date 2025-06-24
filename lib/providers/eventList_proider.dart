import 'package:evently_app/firebase/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

class EventListProvider extends ChangeNotifier {
  List<Event> eventList = [];
  List<Event> get events => eventList;
  int selectedIndex = 0;
  List<String> eventNameList = [];
  List<Event> favoriteEventList = [];
  List<Event> filtereventList = [];
  Event? selectedEventDetails;

  final String eventsBoxName = 'eventsBox';

  // جلب اسماء الفعاليات من الترجمات
  void getEventNameList(BuildContext context) {
    eventNameList = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.sport,
      AppLocalizations.of(context)!.birthday,
      AppLocalizations.of(context)!.meeting,
      AppLocalizations.of(context)!.gaming,
      AppLocalizations.of(context)!.work_shop,
      AppLocalizations.of(context)!.book_club,
      AppLocalizations.of(context)!.exhibition,
      AppLocalizations.of(context)!.holiday,
      AppLocalizations.of(context)!.eating,
    ];
  }

  Future<void> loadEventsFromHive() async {
    var box = await Hive.openBox<Event>(eventsBoxName);
    eventList = box.values.toList();
    eventList.sort((a, b) => a.eventTime.compareTo(b.eventTime));
    filtereventList = eventList;
    favoriteEventList = eventList.where((e) => e.isFavorite).toList();
    notifyListeners();
  }

  void addEvent(Event event) async {
    var box = await Hive.openBox<Event>(eventsBoxName);
    //await box.put(eventList.id, eventList);
    eventList.add(event);
    notifyListeners();
  }
  void updateEvent(int index, Event updatedEvent) {
    events[index] = updatedEvent;
    notifyListeners();

    final box = Hive.box<Event>('eventsBox');
    box.putAt(index, updatedEvent); // دي بتحدث الـ Hive فعليًا
  }
  void updateEventById(Event updatedEvent) {
    final index = events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      events[index] = updatedEvent;
      notifyListeners();
    }
  }
  void loadEvents() {
    final box = Hive.box<Event>('eventsBox');
    eventList = box.values.toList();
    notifyListeners();
  }
  void getAllEvents() async {
    await loadEventsFromHive();
  }

  void getFilterEvents() async {
    if (eventNameList.isEmpty) return;
    await loadEventsFromHive();
    filtereventList = eventList.where((event) {
      return event.eventName == eventNameList[selectedIndex];
    }).toList();
    notifyListeners();
  }

  void updateEventFavorite(Event event) async {
    var box = await Hive.openBox<Event>(eventsBoxName);
    event.isFavorite = !event.isFavorite;
    await box.put(event.id, event);
    if (event.isFavorite) {
      favoriteEventList.add(event);
    } else {
      favoriteEventList.removeWhere((e) => e.eventTitle == event.eventTitle);
    }
    notifyListeners();
  }

  void getFavoriteEvent() async {
    await loadEventsFromHive();
    favoriteEventList = eventList.where((e) => e.isFavorite).toList();
    notifyListeners();
  }

  void getEventDetails(String eventId) async {
    var box = await Hive.openBox<Event>(eventsBoxName);
    selectedEventDetails = box.get(eventId);
    notifyListeners();
  }

  void getSelectedIndex(int newSelectedIndex) {
    selectedIndex = newSelectedIndex;
    if (selectedIndex == 0) {
      getAllEvents();
    } else {
      getFilterEvents();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    var box = await Hive.openBox<Event>(eventsBoxName);
    await box.delete(eventId);
    eventList.removeWhere((e) => e.id == eventId);
    favoriteEventList.removeWhere((e) => e.id == eventId);
    filtereventList.removeWhere((e) => e.id == eventId);
    notifyListeners();
  }

  Future<void> editEvent(Event event) async {
    var box = await Hive.openBox<Event>(eventsBoxName);
    await box.put(event.id, event);
    int index = eventList.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      eventList[index] = event;
    }
    notifyListeners();
  }
}