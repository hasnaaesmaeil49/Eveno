import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Eveno/firebase/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import '../UI/tabs/tabs_widgets/toast.dart';
import '../firebase/firebaseUtls.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventListProvider extends ChangeNotifier {
  List<Event> eventList = [];
  List<Event> get events => eventList;
  int selectedIndex = 0;
  List<String> eventNameList = [];
  List<Event> favoriteEventList = [];
  List<Event> filtereventList = [];
  Event? selectedEventDetails;
  List<Event> allFavoriteEvents = [];
  List<String> favoriteEventIds = [];
  List<Event> get FavoriteEventList => favoriteEventList;


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

  Future<void> loadeventsFromHive() async {
    var box = await Hive.openBox<Event>(eventsBoxName);
    eventList = box.values.toList();
    eventList.sort((a, b) => a.eventTime.compareTo(b.eventTime));
    filtereventList = eventList;
    favoriteEventList = eventList.where((e) => e.isFavorite).toList();
    notifyListeners();
  }
  Future<List<Event>> geteventsFromFirestore() async {
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
      for (var event in eventList) {
        event.isFavorite = favoriteEventIds.contains(event.id);
      }
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
  void loadevents() {
    final box = Hive.box<Event>('eventsBox');
    eventList = box.values.toList();
    notifyListeners();
  }
  void getAllevents() async {
    await loadeventsFromHive();
  }

  void getFilterevents() async {
    if (eventNameList.isEmpty) return;
    await loadeventsFromHive();
    filtereventList = eventList.where((event) {
      return event.eventName == eventNameList[selectedIndex];
    }).toList();
    notifyListeners();
  }






  void updateEventFavorite(Event event) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userFavoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(event.id);

    // عكس قيمة الفيفوريت
    final isNowFavorite = !event.isFavorite;
     event.isFavorite = isNowFavorite;

    if (isNowFavorite) {
      await userFavoritesRef.set(event.toMap());
    } else {
      await userFavoritesRef.delete();
    }

    ToastHelper.showSuccessToast("Event Updated in Favorites");

    // تحديث القوائم
    selectedIndex == 0 ? getAllevents() : getFilterevents();
    await getFavoriteEvent(); // مهم جدًا يكون await
  }


  Future<void> getFavoriteEvent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        //.orderBy('date', descending: false)
        .get();
    favoriteEventIds = favoriteEventList.map((e) => e.id).toList();
    allFavoriteEvents =snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
    notifyListeners();
    favoriteEventList =
        List.from(allFavoriteEvents);
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
      getAllevents();
    } else {
      getFilterevents();
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


  List<Event> myevents = [];

  List<Event> get myeventsList => myevents;

  EventListProvider() {
  loadMyevents(); // تحميل الإيفنتات عند إنشاء الـ Provider
  }


  Future<void> loadMyevents() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final boxName = 'myeventsBox_$userId'; // بوكس خاص بكل مستخدم
    final box = await Hive.openBox<Event>(boxName);

    // 1. عرض البيانات من Hive فورًا
    myevents = box.values.toList();
    notifyListeners();

    try {
      // 2. جلب البيانات من Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('myevents')
          .get();

      final eventsFromFirestore =
      snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();

      // 3. تحديث Hive ببيانات Firestore
      await box.clear();
      for (var event in eventsFromFirestore) {
        await box.put(event.id, event);
      }

      myevents = eventsFromFirestore;
      notifyListeners();
    } catch (e) {
      print("Error loading events: $e");
    }
  }

  Future<void> addMyEvent(Event event) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final boxName = 'myeventsBox_$userId';
    final box = await Hive.openBox<Event>(boxName);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myevents')
        .doc(event.id)
        .set(event.toMap());

    await box.put(event.id, event); // نخزنه في Hive كمان
    myevents.add(event);
    notifyListeners();
  }


  Future<void> removeMyEvent(int index) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final boxName = 'myeventsBox_$userId';
    final box = await Hive.openBox<Event>(boxName);

    final event = myevents[index];

    // حذف من Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myevents')
        .doc(event.id)
        .delete();

    // حذف من Hive
    await box.delete(event.id);

    // حذف من القائمة المعروضة
    myevents.removeAt(index);
    notifyListeners();
  }


}


