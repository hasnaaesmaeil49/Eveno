// import 'package:hive/hive.dart';
//
// part 'event_model.g.dart';
//
// @HiveType(typeId: 0)
// class Event extends HiveObject {
//   @HiveField(0)
//   String id;
//
//   @HiveField(1)
//   String eventTitle;
//
//   @HiveField(2)
//   String eventDescription;
//
//   @HiveField(3)
//   String eventImage;
//
//   @HiveField(4)
//   String eventName;
//
//   @HiveField(5)
//   DateTime eventDate;
//
//   @HiveField(6)
//   String eventTime;
//
//   @HiveField(7)
//   bool isFavorite;
//
//   @HiveField(8)
//   String eventLocation;
//
//   @HiveField(9)
//   int availableTickets; // ✅ مضاف هنا
//
//   static const String collectionName = 'Events';
//
//   Event({
//     this.id = '',
//     required this.eventTitle,
//     required this.eventDescription,
//     required this.eventImage,
//     required this.eventName,
//     required this.eventDate,
//     required this.eventTime,
//     required this.eventLocation,
//     this.isFavorite = false,
//     required this.availableTickets, // ✅ مضاف هنا
//   });
//
//   Event.fromFireStore(Map<String, dynamic>? data)
//       : this(
//     id: data!['id'],
//     eventTitle: data['title'],
//     eventDescription: data['description'],
//     eventImage: data['image'],
//     eventName: data['event_name'],
//     eventDate: DateTime.fromMillisecondsSinceEpoch(data['date']),
//     eventTime: data['time'],
//     eventLocation: data['location'],
//     isFavorite: data['is_favorite'],
//     availableTickets: data['available_tickets'] ?? 0, // ✅ هنا
//   );
//
//   Map<String, dynamic> toFireStore() {
//     return {
//       'id': id,
//       'title': eventTitle,
//       'description': eventDescription,
//       'image': eventImage,
//       'event_name': eventName,
//       'date': eventDate.millisecondsSinceEpoch,
//       'time': eventTime,
//       'location': eventLocation,
//       'is_favorite': isFavorite,
//       'available_tickets': availableTickets, // ✅ هنا
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String eventTitle;

  @HiveField(2)
  String eventDescription;

  @HiveField(3)
  String eventImage;

  @HiveField(4)
  String eventName;

  @HiveField(5)
  DateTime eventDate;

  @HiveField(6)
  String eventTime;

  @HiveField(7)
  bool isFavorite;

  @HiveField(8)
  String eventLocation;

  @HiveField(9)
  int availableTickets; // ✅ مضاف هنا
  @HiveField(10)
  final bool isFree;
  @HiveField(11)
  double ticketPrice;


  static const String collectionName = 'Events';

  Event({
    this.id = '',
    required this.eventTitle,
    required this.eventDescription,
    required this.eventImage,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    this.isFavorite = false,
    required this.availableTickets, // ✅ مضاف هنا
    required this.isFree,
    this.ticketPrice = 0.0,
  });


  Event.fromFireStore(Map<String, dynamic>? data)
      : this(
      id: data!['id'] ?? '',
      eventTitle: data['title'] ?? '',
      eventDescription: data['description'] ?? '',
      eventImage: data['image'] ?? '',
      eventName: data['event_name'] ?? '',
      eventDate: DateTime.fromMillisecondsSinceEpoch(data['date']),
      eventTime: data['time'] ?? '',
      eventLocation: data['location'] ?? '',
      isFavorite: data['is_favorite'] ?? '',
      availableTickets: data['available_tickets'] ?? 0,
      // ✅ هنا
      isFree: data['isFree'] ?? true,
      ticketPrice: data['ticketPrice'] ?? ''
  );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': eventTitle,
      'description': eventDescription,
      'image': eventImage,
      'event_name': eventName,
      'date': eventDate.millisecondsSinceEpoch,
      'time': eventTime,
      'location': eventLocation,
      'is_favorite': isFavorite,
      'available_tickets': availableTickets, // ✅ هنا
      'isFree': isFree,
      'ticketPrice': ticketPrice,
    };
  }

  // ... الحقول التانية


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventTitle': eventTitle,
      'eventDate': eventDate,
      // ... أضيفي الحقول التانية
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      eventTitle: map['eventTitle'],
      eventDate: (map['eventDate'] as Timestamp).toDate(),
        eventDescription: map['description'] ?? '',
        eventImage: map['image'] ?? '',
        eventName: map['event_name'] ?? '',
        eventTime: map['time'] ?? '',
        eventLocation: map['location'] ?? '',
        isFavorite: map['is_favorite'] ?? '',
        availableTickets: map['available_tickets'] ,
        // ✅ هنا
        isFree: map['isFree'] ,
        ticketPrice: map['ticketPrice'] ?? ''


      // ... أضيفي التحويلات التانية
    );
  }
}