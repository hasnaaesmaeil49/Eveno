import 'dart:io';
import 'package:evently_app/UI/tabs/add_event/add_event_widgets/custom_date_or_time.dart';
import 'package:evently_app/UI/tabs/home_tab/home_widgets/tab_event_widget.dart';
import 'package:evently_app/UI/tabs/map_tab/map.dart';
import 'package:evently_app/UI/tabs/tabs_widgets/custom_elevated_button.dart';
import 'package:evently_app/UI/tabs/tabs_widgets/custom_text_field.dart';
import 'package:evently_app/UI/tabs/tabs_widgets/toast.dart';
import 'package:evently_app/firebase/event_model.dart';
import 'package:evently_app/firebase/firebaseUtls.dart';
import 'package:evently_app/providers/eventList_proider.dart';
import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_images.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:evently_app/UI/home/home_screen.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  int selectedIndex = 0;
  final formKey = GlobalKey<FormState>();
  String formatDate = "";
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String formatTime = "";

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var ticketsController = TextEditingController();
  var customEventTypeController = TextEditingController();

  String? selectedImage = '';
  String? selectedEvent = '';
  String? selectedLocation;
  File? customImage;

  late EventListProvider eventProvider;

  @override
  void initState() {
    super.initState();
    eventProvider = Provider.of<EventListProvider>(context, listen: false);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        customImage = File(pickedFile.path);
      });
    }
  }

  void chooseDate() async {
    var chooseDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (chooseDate != null) {
      setState(() {
        selectedDate = chooseDate;
      });
    }
  }

  void chooseTime() async {
    var chooseTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (chooseTime != null) {
      setState(() {
        selectedTime = chooseTime;
        formatTime = selectedTime!.format(context);
      });
    }
  }

  void addEvent() {
    if (formKey.currentState?.validate() == true) {
      final newEvent = Event(
        eventTitle: titleController.text,
        eventDescription: descriptionController.text,
        eventImage: customImage?.path ?? selectedImage ?? '',
        eventName: (selectedEvent == AppLocalizations.of(context)!.other)
            ? customEventTypeController.text
            : selectedEvent ?? '',
        eventDate: selectedDate ?? DateTime.now(),
        eventTime: formatTime,
        eventLocation: selectedLocation ?? '',
        availableTickets: int.tryParse(ticketsController.text) ?? 0,
      );

      FirebaseUtls.addEventToFireStore(newEvent);
      eventProvider.getAllEvents();
      Provider.of<EventListProvider>(context, listen: false).addEvent(newEvent);
      ToastHelper.showSuccessToast("تم إضافة الحدث بنجاح");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> eventsNameList = [
      AppLocalizations.of(context)!.sport,
      AppLocalizations.of(context)!.birthday,
      AppLocalizations.of(context)!.meeting,
      AppLocalizations.of(context)!.gaming,
      AppLocalizations.of(context)!.work_shop,
      AppLocalizations.of(context)!.book_club,
      AppLocalizations.of(context)!.exhibition,
      AppLocalizations.of(context)!.holiday,
      AppLocalizations.of(context)!.eating,
      AppLocalizations.of(context)!.other,
    ];

    List<String> eventImageList = [
      Theme.of(context).brightness == Brightness.dark
          ? AppImages.sportImgDark
          : AppImages.sportImgLight,
      Theme.of(context).brightness == Brightness.dark
          ? AppImages.birthdayImgDark
          : AppImages.birthdayImgLight,
      Theme.of(context).brightness == Brightness.dark
          ? AppImages.meetingImgDark
          : AppImages.meetingImgLight,
      Theme.of(context).brightness == Brightness.dark
          ? AppImages.gamingImgDark
          : AppImages.gamingImgLight,
      Theme.of(context).brightness == Brightness.dark
          ? AppImages.workShopImgDark
          : AppImages.workShopImgLight,
      Theme.of(context).brightness == Brightness.dark
          ? AppImages.bookImageDark
          : AppImages.bookImgLight,
      Theme.of(context).brightness == Brightness.dark
          ? AppImages.exhibitionImgDark
          : AppImages.exhibitionImgLight,
      Theme.of(context).brightness == Brightness.dark
          ? AppImages.holidayImgDark
          : AppImages.holidayImgLight,
      Theme.of(context).brightness == Brightness.dark
          ? AppImages.eatingImgDark
          : AppImages.eatingImgLight,
      '', // For "نوع آخر"
    ];

    selectedImage = eventImageList[selectedIndex];
    selectedEvent = eventsNameList[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.create_event, style: AppStyle.blue16bold),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.primaryDark
            : AppColor.whiteColor,
        iconTheme: const IconThemeData(color: AppColor.babyBlueColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: customImage != null
                      ? Image.file(customImage!, height: 150, width: double.infinity, fit: BoxFit.cover)
                      : Image.asset(selectedImage!, height: 150, width: double.infinity, fit: BoxFit.cover),
                ),
                TextButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image, color: AppColor.babyBlueColor),
                  label: Text('اختيار صورة من المعرض', style: AppStyle.blue16Medium),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: eventsNameList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: TabEventWidget(
                          isSelected: selectedIndex == index,
                          eventName: eventsNameList[index],
                          selectedEventDark: AppColor.babyBlueColor,
                          selectedEventLight: AppColor.babyBlueColor,
                          styleEventDarkSelected: AppStyle.dark16Medium,
                          styleEventDarkUnSelected: AppStyle.blue16Medium,
                          styleEventLightSelected: AppStyle.white16Medium,
                          styleEventLightUnSelected: AppStyle.blue16Medium,
                        ),
                      );
                    },
                  ),
                ),
                if (selectedEvent == AppLocalizations.of(context)!.other)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CustomTextField(
                      controller: customEventTypeController,
                      hintText: 'اكتب نوع الحدث',
                      style: AppStyle.grey16Medium,
                    ),
                  ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: titleController,
                  hintText: AppLocalizations.of(context)!.event_title,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: descriptionController,
                  maxLines: 4,
                  hintText: AppLocalizations.of(context)!.event_description,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: ticketsController,
                  keyboardType: TextInputType.number,
                  hintText: 'عدد التذاكر المتاحة',
                ),
                const SizedBox(height: 16),
                CustomDateOrTime(
                  imageDateOrTime: Theme.of(context).brightness == Brightness.dark
                      ? AppImages.calndreDarkIcon
                      : AppImages.calnderLightIcon,
                  chooseDateOrTime: selectedDate == null
                      ? AppLocalizations.of(context)!.choose_date
                      : DateFormat("dd/MM/yyyy").format(selectedDate!),
                  chooseDateOrTimeClicked: chooseDate,
                  textDateOrTime: AppLocalizations.of(context)!.event_date,
                ),
                const SizedBox(height: 8),
                CustomDateOrTime(
                  imageDateOrTime: Theme.of(context).brightness == Brightness.dark
                      ? AppImages.clockDarkIcon
                      : AppImages.clockLightIcon,
                  chooseDateOrTime: selectedTime == null
                      ? AppLocalizations.of(context)!.choose_time
                      : formatTime,
                  chooseDateOrTimeClicked: chooseTime,
                  textDateOrTime: AppLocalizations.of(context)!.event_time,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final location = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapTab()),
                    );
                    if (location != null) {
                      setState(() => selectedLocation = location);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.babyBlueColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColor.babyBlueColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedLocation ?? AppLocalizations.of(context)!.choose_event_location,
                            style: AppStyle.blue16bold,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 20, color: AppColor.babyBlueColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  text: AppLocalizations.of(context)!.add_event,
                  textStyle: AppStyle.white16bold,
                  onClickedButton: addEvent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}