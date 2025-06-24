import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:evently_app/firebase/event_model.dart';
import 'package:evently_app/firebase/firebaseUtls.dart';
import 'package:evently_app/providers/eventList_proider.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:evently_app/notifications/notification_helper.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  LatLng? coordinates;

  @override
  void initState() {
    super.initState();
    getCoordinates(widget.event.eventLocation);
  }

  Future<void> getCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          coordinates =
              LatLng(locations.first.latitude, locations.first.longitude);
        });
      }
    } catch (e) {
      print("خطأ في جلب الإحداثيات: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final eventProvider = Provider.of<EventListProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Text(
          'تفاصيل الفعالية',
          style: AppStyle.blue16bold.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        iconTheme: const IconThemeData(color: AppColor.babyBlueColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImageCard(height),
            const SizedBox(height: 20),
            buildTitleContainer(),
            const SizedBox(height: 16),
            buildInfoBlock(context,
                icon: Icons.calendar_today,
                label: 'التاريخ',
                value: DateFormat("dd/MM/yyyy").format(widget.event.eventDate)),
            const SizedBox(height: 12),
            buildInfoBlock(context,
                icon: Icons.access_time,
                label: 'الوقت',
                value: widget.event.eventTime),
            const SizedBox(height: 12),
            buildInfoBlock(context,
                icon: Icons.location_on,
                label: 'المكان',
                value: widget.event.eventLocation),
            const SizedBox(height: 16),
            buildMapSection(),
            const SizedBox(height: 20),
            buildDescriptionContainer(),
            const SizedBox(height: 16),
            buildTicketsSection(eventProvider),
          ],
        ),
      ),
    );
  }

  Widget buildImageCard(double height) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColor.babyBlueColor, width: 1.5),
      ),
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          widget.event.eventImage,
          width: double.infinity,
          height: height * 0.25,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildTitleContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.babyBlueColor, width: 1.2),
        boxShadow: [
          BoxShadow(
              color: AppColor.babyBlueColor.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Text(
        widget.event.eventTitle,
        style: AppStyle.blue16bold.copyWith(fontSize: 22),
      ),
    );
  }

  Widget buildMapSection() {
    return coordinates != null
        ? Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.babyBlueColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                    color: AppColor.babyBlueColor.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: coordinates!, zoom: 14),
                markers: {
                  Marker(
                      markerId: MarkerId('eventLocation'),
                      position: coordinates!),
                },
                zoomControlsEnabled: false,
              ),
            ),
          )
        : const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget buildDescriptionContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.babyBlueColor, width: 1.2),
        boxShadow: [
          BoxShadow(
              color: AppColor.babyBlueColor.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الوصف:', style: AppStyle.blue16bold.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Text(widget.event.eventDescription,
              style: AppStyle.black16Medium.copyWith(fontSize: 15)),
        ],
      ),
    );
  }

  Widget buildTicketsSection(EventListProvider eventProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎟 التذاكر المتاحة: ${widget.event.availableTickets}',
          style: AppStyle.blue16bold.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 10),
        if (widget.event.availableTickets > 0)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.babyBlueColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              int newAvailableTickets = widget.event.availableTickets - 1;
              await FirebaseUtls.updateEvent(widget.event.id, {
                'availableTickets': newAvailableTickets,
              });
              setState(() {
                widget.event.availableTickets = newAvailableTickets;
              });
              eventProvider.updateEventById(widget.event);
              await scheduleNotification(
                title: 'تذكير بالفعالية',
                body: 'متنساش عندك فعالية: ${widget.event.eventTitle} كمان يومين!',
                eventDate: widget.event.eventDate,
              );
              Fluttertoast.showToast(msg: "✅ تم حجز التذكرة بنجاح");
            },
            child: Text("احجز الآن", style: AppStyle.white16bold),

          )
        else
          Text("لا توجد تذاكر متاحة", style: AppStyle.black16Medium.copyWith(color: AppColor.redColor)),
      ],
    );
  }

  Widget buildInfoBlock(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.babyBlueColor, width: 1.2),
        boxShadow: [
          BoxShadow(
              color: AppColor.babyBlueColor.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColor.babyBlueColor, size: 22),
          const SizedBox(width: 10),
          Text('$label: ', style: AppStyle.blue16bold),
          Expanded(
            child: Text(value,
                style: AppStyle.black16Medium, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
