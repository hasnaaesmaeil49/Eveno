import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Eveno/firebase/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../UI/tabs/tabs_widgets/toast.dart';
import '../firebase/firebaseUtls.dart';

class EventListProvider extends ChangeNotifier {
  List<Event> eventList = [];
  List<Event> get events => eventList;
  int selectedIndex = 0;
  List<String> eventNameList = [];
  List<Event> favoriteEventList = [];
  List<Event> filtereventList = [];
  Event? selectedEventDetails;

  final String eventsBoxName = 'eventsBox';
  final String favoritesBoxName = 'favoritesBox';

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
  Future<List<Event>> getEventsFromFirestore() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(Event.collectionName)
          .get();

      eventList = querySnapshot.docs
          .map((doc) => Event.fromFireStore(doc.data()))
          .toList();

      filtereventList = eventList;
      favoriteEventList =
          eventList.where((event) => event.isFavorite).toList();

      notifyListeners();
      return eventList;
    } catch (e) {
      print('Error fetching events from Firestore: $e');
      return [];
    }
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

  // Future<void> loadFavoriteEvents() async {
  //   final box = await Hive.openBox<Event>(favoritesBoxName);
  //   favoriteEventList = box.values.toList();
  //   // تحديث حالة isFavorite لكل حدث في eventList
  //   for (var event in eventList) {
  //     event.isFavorite = favoriteEventList.any((fav) => fav.id == event.id);
  //   }
  //   notifyListeners();
  // }
  // void updateEventFavorite(Event event) async {
  //   var box = await Hive.openBox<Event>(eventsBoxName);
  //   event.isFavorite = !event.isFavorite;
  //   await box.put(event.id, event);
  //   if (event.isFavorite) {
  //     favoriteEventList.add(event);
  //   } else {
  //     favoriteEventList.removeWhere((e) => e.eventTitle == event.eventTitle);
  //   }
  //   notifyListeners();
  // }
  //
  // void getFavoriteEvent() async {
  //   await loadEventsFromHive();
  //   favoriteEventList = eventList.where((e) => e.isFavorite).toList();
  //   notifyListeners();
  // }

  void updateEventFavorite(Event event) {
    FirebaseUtls.getEventCollection().doc(event.id).update({
      'is_favorite': !event.isFavorite,
      //'location': newLocation, // تحديث الموقع الجغرافي هنا

    });
      ToastHelper.showSuccessToast("Event Updated into Favorite");
     //selectedIndex == 0 ? getAllEvents() : getFilterEvents();
    getFavoriteEvent();
  }

  void getFavoriteEvent() async {
    QuerySnapshot<Event> querySnapshot = await FirebaseUtls.getEventCollection()
        .orderBy('date', descending: false)
        .where('is_favorite', isEqualTo: true)
        .get();
    favoriteEventList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
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


  List<Event> myEvents = [];

  List<Event> get myEventsList => myEvents;

  EventListProvider() {
  loadMyEvents(); // تحميل الإيفنتات عند إنشاء الـ Provider
  }

  Future<void> loadMyEvents() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('myEvents')
      .get();
  myEvents = snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
  notifyListeners();
  }

  Future<void> addMyEvent(Event event) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('myEvents')
      .doc(event.id) // افترض إن عندك id فريد
      .set(event.toMap());
  myEvents.add(event);
  notifyListeners();
  }

  Future<void> removeMyEvent(int index) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  final event = myEvents[index];
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('myEvents')
      .doc(event.id)
      .delete();
  myEvents.removeAt(index);
  notifyListeners();
  }



}


