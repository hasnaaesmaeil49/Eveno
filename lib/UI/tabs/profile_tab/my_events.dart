// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:Eveno/providers/eventList_proider.dart';
// import 'package:Eveno/firebase/event_model.dart';
// import 'package:Eveno/utls/app_style.dart';
// import 'package:Eveno/l10n/app_localizations.dart';
// import 'package:Eveno/UI/home/EventDetailPage.dart';
//
// class MyeventsPage extends StatefulWidget {
//   const MyeventsPage({super.key});
//
//   @override
//   State<MyeventsPage> createState() => _MyeventsPageState();
// }
//
// class _MyeventsPageState extends State<MyeventsPage> {
//   @override
//   void initState() {
//     super.initState();
//     final eventProvider = Provider.of<EventListProvider>(context, listen: false);
//     eventProvider.loadMyevents(); // تحميل الأحداث من Hive ثم تحديثها من Firebase
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.my_events),
//         backgroundColor: Theme.of(context).brightness == Brightness.dark
//             ? Theme.of(context).primaryColor
//             : null,
//       ),
//       body: Consumer<EventListProvider>(
//         builder: (context, provider, child) {
//           // if (provider.isLoading) {
//           //   return const Center(child: CircularProgressIndicator());
//           // }
//
//           if (provider.myeventsList.isEmpty) {
//             return Center(
//               child: Text(
//                 AppLocalizations.of(context)!.no_booked_events,
//                 style: AppStyle.blue20bold,
//               ),
//             );
//           }
//
//           final myevents = provider.myeventsList;
//           return ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: myevents.length,
//             itemBuilder: (context, index) {
//               final event = myevents[index];
//               return Card(
//                 margin: const EdgeInsets.only(bottom: 16.0),
//                 child: ListTile(
//                   leading: _buildEventImage(event.eventImage),
//                   title: Text(event.eventTitle, style: AppStyle.black16Bold),
//                   subtitle: Text(
//                     '${AppLocalizations.of(context)!.date}: ${event.eventDate.toString().split(' ')[0]}',
//                     style: AppStyle.grey16Medium,
//                   ),
//                   trailing: Text(
//                     '${AppLocalizations.of(context)!.tickets}: ${event.availableTickets}',
//                     style: AppStyle.blue16Medium,
//                   ),
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => EventDetailPage(event: event),
//                       ),
//                     );
//                   },
//                   onLongPress: () {
//                     _showDeleteConfirmationDialog(context, provider, index);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // دالة لاختيار مصدر الصورة بناءً على نوع المسار مع تحسينات
//   Widget _buildEventImage(String imagePath) {
//     if (imagePath.isNotEmpty) {
//       try {
//         // تحقق إذا كان المسار يحتوي على رابط URL
//         if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
//           return Image.network(
//             imagePath,
//             width: 50,
//             height: 50,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               return _buildDefaultImage(); // استخدام صورة افتراضية عند الخطأ
//             },
//             loadingBuilder: (context, child, progress) {
//               if (progress == null) return child;
//               return CircularProgressIndicator();
//             },
//           );
//         }
//         // إذا كان المسار من assets
//         else if (imagePath.startsWith('assets/')) {
//           return Image.asset(
//             imagePath,
//             width: 50,
//             height: 50,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               return _buildDefaultImage(); // استخدام صورة افتراضية عند الخطأ
//             },
//           );
//         }
//       } catch (e) {
//         print('Error loading image: $e');
//         return _buildDefaultImage();
//       }
//     }
//     // صورة افتراضية إذا لم يكن هناك مسار صالح
//     return _buildDefaultImage();
//   }
//
//   // دالة منفصلة لعرض الصورة الافتراضية
//   Widget _buildDefaultImage() {
//     return Image.asset(
//       'assets/default_image.png', // تأكد من وجود هذا الملف
//       width: 50,
//       height: 50,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) {
//         return Icon(Icons.image_not_supported, size: 50); // بديل إذا فشل حتى الافتراضي
//       },
//     );
//   }
//
//   void _showDeleteConfirmationDialog(BuildContext context, EventListProvider provider, int index) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(AppLocalizations.of(context)!.confirm_delete),
//         content: Text(AppLocalizations.of(context)!.are_you_sure_delete_event),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // إلغاء
//             },
//             child: Text(AppLocalizations.of(context)!.cancel),
//           ),
//           TextButton(
//             onPressed: () async {
//               try {
//                 await provider.removeMyEvent(index); // مسح من Firestore وHive والقائمة
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Error deleting event: $e')),
//                 );
//               }
//               Navigator.of(context).pop(); // إغلاق الـ dialog
//             },
//             child: Text(AppLocalizations.of(context)!.yes),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Eveno/providers/eventList_proider.dart';
import 'package:Eveno/firebase/event_model.dart';
import 'package:Eveno/utls/app_style.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:Eveno/UI/home/EventDetailPage.dart';


class MyeventsPage extends StatefulWidget {
  const MyeventsPage({super.key});

  @override
  State<MyeventsPage> createState() => _MyeventsPageState();
}

class _MyeventsPageState extends State<MyeventsPage> {
  @override
  void initState() {
    super.initState();
    final eventProvider = Provider.of<EventListProvider>(context, listen: false);
    eventProvider.loadMyevents(); // تحميل الأحداث من Hive ثم تحديثها من Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.my_events),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).primaryColor
            : null,
      ),
      body: Consumer<EventListProvider>(
        builder: (context, provider, child) {
          if (provider.myeventsList.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.no_booked_events,
                style: AppStyle.blue20bold,
              ),
            );
          }

          final myevents = provider.myeventsList;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: myevents.length,
            itemBuilder: (context, index) {
              final event = myevents[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  leading: _buildEventImage(event.eventImage),
                  title: Text(event.eventTitle, style: AppStyle.black16Bold),
                  subtitle: Text(
                    '${AppLocalizations.of(context)!.date}: ${event.eventDate.toString().split(' ')[0]}',
                    style: AppStyle.grey16Medium,
                  ),
                  trailing: Text(
                    '${AppLocalizations.of(context)!.tickets}: ${event.availableTickets}',
                    style: AppStyle.blue16Medium,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(event: event),
                      ),
                    );
                  },
                  onLongPress: () {
                    _showDeleteConfirmationDialog(context, provider, index);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ✅ تعديل هذه الدالة لدعم File + Network + Asset
  Widget _buildEventImage(String imagePath) {
    if (imagePath.isNotEmpty) {
      try {
        if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
          return Image.network(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultImage();
            },
          );
        } else if (imagePath.startsWith('/data')) {
          return Image.file(
            File(imagePath),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultImage();
            },
          );
        } else if (imagePath.startsWith('assets/')) {
          return Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultImage();
            },
          );
        }
      } catch (e) {
        print('Error loading image: $e');
        return _buildDefaultImage();
      }
    }
    return _buildDefaultImage();
  }

  Widget _buildDefaultImage() {
    return Image.asset(
      'otherImgLight',
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.image_not_supported, size: 50);
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, EventListProvider provider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirm_delete),
        content: Text(AppLocalizations.of(context)!.are_you_sure_delete_event),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                await provider.removeMyEvent(index);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting event: $e')),
                );
              }
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.yes),
          ),
        ],
      ),
    );
  }
}