// import 'dart:io';
//
// import 'package:Eveno/firebase/event_model.dart';
// import 'package:Eveno/providers/eventList_proider.dart';
// import 'package:Eveno/utls/app_colo.dart';
// import 'package:Eveno/utls/app_images.dart';
// import 'package:Eveno/utls/app_style.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:Eveno/UI/home/EventDetailPage.dart'; // تأكد من المسار الصحيح لصفحة التفاصيل
//
// class EventCard extends StatelessWidget {
//   EventCard({super.key, required this.event});
//   Event event;
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     var eventListProvider = Provider.of<EventListProvider>(context);
//     Color containerBG = Theme.of(context).brightness == Brightness.dark
//         ? AppColor.primaryDark
//         : AppColor.whiteColor;
//     TextStyle textstyleDark = Theme.of(context).brightness == Brightness.dark
//         ? AppStyle.white16Medium
//         : AppStyle.black16Medium;
//     String imageDark = Theme.of(context).brightness == Brightness.dark
//         ? event.eventImage
//         : event.eventImage;
//
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: width * 0.04,
//         vertical: height * 0.01,
//       ),
//       child: GestureDetector(
//         onTap: () {
//           // التنقل إلى صفحة التفاصيل عند الضغط على Card
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => EventDetailPage(event: event), // التمرير لصفحة التفاصيل مع الحدث
//             ),
//           );
//         },
//         child: Container(
//           height: height * 0.31,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(
//               color: AppColor.babyBlueColor,
//               width: 2,
//             ),
//             image: DecorationImage(
//               image: _getImageProvider(event.eventImage),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Stack(
//             children: [
//               // العناصر الأصلية الموجودة
//               Positioned(
//                 top: height * 0.01,
//                 left: width * 0.02,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.01,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: containerBG,
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         '${event.eventDate.day}',
//                         style: AppStyle.blue20bold,
//                       ),
//                       Text(
//                         DateFormat('MMM').format(event.eventDate),
//                         style: AppStyle.blue20bold,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: height * 0.01,
//                 left: width * 0.02,
//                 right: width * 0.02,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.02,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: containerBG.withOpacity(0.8),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           event.eventTitle,
//                           style: textstyleDark,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           eventListProvider.updateEventFavorite(event);
//                         },
//                         child: event.isFavorite
//                             ? Icon(Icons.favorite, color: Colors.red, size: 30)
//                             : Icon(Icons.favorite_border,
//                                 color: Colors.red, size: 30),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   ImageProvider _getImageProvider(String path) {
//     if (path.startsWith('http') || path.startsWith('https')) {
//       return NetworkImage(path);
//     } else if (path.startsWith('/data')) {
//       return FileImage(File(path));
//     } else {
//       return AssetImage(path);
//     }
//   }
// }
import 'dart:io';
import 'package:Eveno/firebase/event_model.dart';
import 'package:Eveno/providers/eventList_proider.dart';
import 'package:Eveno/utls/app_colo.dart';
import 'package:Eveno/utls/app_images.dart';
import 'package:Eveno/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Eveno/UI/home/EventDetailPage.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var eventListProvider = Provider.of<EventListProvider>(context);
    Color containerBG = Theme.of(context).brightness == Brightness.dark
        ? AppColor.primaryDark
        : AppColor.whiteColor;
    TextStyle textstyleDark = Theme.of(context).brightness == Brightness.dark
        ? AppStyle.white16Medium
        : AppStyle.black16Medium;
    String imageDark = Theme.of(context).brightness == Brightness.dark
        ? event.eventImage
        : event.eventImage;

    // التحقق من إذا كان الحدث مفضلاً بناءً على favoriteEventList
    bool isFavorite = eventListProvider.favoriteEventList.any((favEvent) => favEvent.id == event.id);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EventDetailPage(event: event),
            ),
          );
        },
        child: Container(
          height: height * 0.31,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColor.babyBlueColor,
              width: 2,
            ),
            image: DecorationImage(
              image: _getImageProvider(event.eventImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: height * 0.01,
                left: width * 0.02,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: containerBG,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${event.eventDate.day}',
                        style: AppStyle.blue20bold,
                      ),
                      Text(
                        DateFormat('MMM').format(event.eventDate),
                        style: AppStyle.blue20bold,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: height * 0.01,
                left: width * 0.02,
                right: width * 0.02,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: containerBG.withOpacity(0.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.eventTitle,
                          style: textstyleDark,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          eventListProvider.updateEventFavorite(event);
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    } else if (path.startsWith('/data')) {
      return FileImage(File(path));
    } else {
      return AssetImage(path);
    }
  }
}