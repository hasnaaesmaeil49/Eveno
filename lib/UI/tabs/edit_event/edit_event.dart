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
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:evently_app/UI/home/home_screen.dart';
import 'package:evently_app/UI/tabs/edit_event/edit_event.dart';
class EditEvent extends StatefulWidget {
  final Event event;
  final int index;

  const EditEvent({super.key, required this.event, required this.index});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  int selectedIndex = 0;
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String formatTime = "";
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  String? selectedImage;
  String? selectedEvent;
  String? selectedLocation;
  late EventListProvider eventProvider;

  List<String> eventsNameList = [];
  List<String> eventImageList = [];

  @override
  void initState() {
    super.initState();

    /// ✅ تأمين البيانات من الانهيار عند فصل الاتصال أو null
    if (widget.event != null) {
      titleController.text = widget.event.eventTitle;
      descriptionController.text = widget.event.eventDescription;
      selectedDate = widget.event.eventDate;
      formatTime = widget.event.eventTime;
      selectedLocation = widget.event.eventLocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    eventProvider = Provider.of<EventListProvider>(context);

    /// ✅ لازم نجهزهم هنا عشان نستخدمهم في initState كمان
    eventsNameList = [
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
    eventImageList = [
      Theme.of(context).brightness == Brightness.dark ? AppImages.sportImgDark : AppImages.sportImgLight,
      Theme.of(context).brightness == Brightness.dark ? AppImages.birthdayImgDark : AppImages.birthdayImgLight,
      Theme.of(context).brightness == Brightness.dark ? AppImages.meetingImgDark : AppImages.meetingImgLight,
      Theme.of(context).brightness == Brightness.dark ? AppImages.gamingImgDark : AppImages.gamingImgLight,
      Theme.of(context).brightness == Brightness.dark ? AppImages.workShopImgDark : AppImages.workShopImgLight,
      Theme.of(context).brightness == Brightness.dark ? AppImages.bookImageDark : AppImages.bookImgLight,
      Theme.of(context).brightness == Brightness.dark ? AppImages.exhibitionImgDark : AppImages.exhibitionImgLight,
      Theme.of(context).brightness == Brightness.dark ? AppImages.holidayImgDark : AppImages.holidayImgLight,
      Theme.of(context).brightness == Brightness.dark ? AppImages.eatingImgDark : AppImages.eatingImgLight,
    ];

    /// ✅ لو مفيش بيانات event موجودة - نعرض رسالة محترمة بدل crash
    if (widget.event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('حدث خطأ')),
        body: const Center(child: Text('لا يمكن تحميل بيانات الحدث')),
      );
    }

    selectedIndex = eventsNameList.indexOf(widget.event.eventName);
    selectedImage = eventImageList[selectedIndex];
    selectedEvent = eventsNameList[selectedIndex];

    // ✅ باقي كودك بدون أي تعديل
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.edit_event, style: AppStyle.blue16bold),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColor.primaryDark : AppColor.whiteColor,
        iconTheme: const IconThemeData(color: AppColor.babyBlueColor),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(selectedImage!),
              ),
              SizedBox(height: height * 0.02),
              Container(
                height: height * 0.05,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          selectedImage = eventImageList[index];
                          selectedEvent = eventsNameList[index];
                        });
                      },
                      child: TabEventWidget(
                        selectedEventDark: AppColor.babyBlueColor,
                        selectedEventLight: AppColor.babyBlueColor,
                        styleEventDarkSelected: AppStyle.dark16Medium,
                        styleEventDarkUnSelected: AppStyle.blue16Medium,
                        styleEventLightSelected: AppStyle.white16Medium,
                        styleEventLightUnSelected: AppStyle.blue16Medium,
                        isSelected: selectedIndex == index,
                        eventName: eventsNameList[index],
                      ),
                    );
                  },
                  itemCount: eventsNameList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: width * 0.02);
                  },
                ),
              ),
              SizedBox(height: height * 0.02),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildTitleField(height),
                    buildDescriptionField(height),
                    buildDatePicker(context),
                    buildTimePicker(context),
                    buildLocationPicker(context, height, width),
                    CustomElevatedButton(
                      text: AppLocalizations.of(context)!.edit_event,
                      textStyle: AppStyle.white16bold,
                      onClickedButton: editEvent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleField(double height) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppLocalizations.of(context)!.title, style: Theme.of(context).brightness == Brightness.dark ? AppStyle.white16bold : AppStyle.black16Bold),
      SizedBox(height: height * 0.01),
      CustomTextField(
        controller: titleController,
        validator: (text) => text == null || text.isEmpty ? AppLocalizations.of(context)!.please_enter_event_title : null,
        hintText: AppLocalizations.of(context)!.event_title,
        style: Theme.of(context).brightness == Brightness.dark ? AppStyle.white16Medium : AppStyle.grey16Medium,
        prefixIcon: Theme.of(context).brightness == Brightness.dark ? Image.asset(AppImages.editDarkIcon) : Image.asset(AppImages.editLightIcon),
      ),
      SizedBox(height: height * 0.02),
    ],
  );

  Widget buildDescriptionField(double height) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppLocalizations.of(context)!.description, style: Theme.of(context).brightness == Brightness.dark ? AppStyle.white14Bold : AppStyle.black16Bold),
      SizedBox(height: height * 0.01),
      CustomTextField(
        controller: descriptionController,
        validator: (text) => text == null || text.isEmpty ? AppLocalizations.of(context)!.please_enter_event_description : null,
        maxLines: 4,
        hintText: AppLocalizations.of(context)!.event_description,
        style: Theme.of(context).brightness == Brightness.dark ? AppStyle.white16Medium : AppStyle.grey16Medium,
        obscureText: false,
      ),
      SizedBox(height: height * 0.02),
    ],
  );

  Widget buildDatePicker(BuildContext context) => CustomDateOrTime(
    imageDateOrTime: Theme.of(context).brightness == Brightness.dark ? AppImages.calndreDarkIcon : AppImages.calnderLightIcon,
    chooseDateOrTime: selectedDate == null ? AppLocalizations.of(context)!.choose_date : DateFormat("dd/MM/yyyy").format(selectedDate!),
    chooseDateOrTimeClicked: chooseDate,
    textDateOrTime: AppLocalizations.of(context)!.event_date,
  );

  Widget buildTimePicker(BuildContext context) => CustomDateOrTime(
    imageDateOrTime: Theme.of(context).brightness == Brightness.dark ? AppImages.clockDarkIcon : AppImages.clockLightIcon,
    chooseDateOrTime: selectedTime == null ? AppLocalizations.of(context)!.choose_time : formatTime,
    chooseDateOrTimeClicked: chooseTime,
    textDateOrTime: AppLocalizations.of(context)!.event_time,
  );

  Widget buildLocationPicker(BuildContext context, double height, double width) => GestureDetector(
    onTap: () async {
      final location = await Navigator.push(context, MaterialPageRoute(builder: (context) => MapTab()));
      if (location != null) {
        setState(() {
          selectedLocation = location;
        });
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.babyBlueColor, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColor.babyBlueColor,
            ),
            child: Theme.of(context).brightness == Brightness.dark ? Image.asset(AppImages.locationDarkIcon) : Image.asset(AppImages.locationLightIcon),
          ),
          SizedBox(width: width * 0.04),
          Text(selectedLocation ?? AppLocalizations.of(context)!.choose_event_location, style: AppStyle.blue16bold),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 20, color: AppColor.babyBlueColor),
        ],
      ),
    ),
  );

  void editEvent() async {
    if (formKey.currentState?.validate() == true) {
      Event updatedEvent = Event(
        id: widget.event.id, // لازم
        eventTitle: titleController.text,
        eventDescription: descriptionController.text,
        eventImage: selectedImage ?? "",
        eventName: selectedEvent ?? "",
        eventDate: selectedDate ?? DateTime.now(),
        eventTime: formatTime,
        eventLocation: selectedLocation ?? "",
        availableTickets: 0, // أو الرقم اللي تحبيه
      );

      await Provider.of<EventListProvider>(context, listen: false).editEvent(updatedEvent);

      ToastHelper.showSuccessToast("تم تعديل الحدث بنجاح");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  chooseDate() async {
    var chooseDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (chooseDate != null) {
      setState(() => selectedDate = chooseDate);
    }
  }

  chooseTime() async {
    var chooseTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (chooseTime != null) {
      setState(() {
        selectedTime = chooseTime;
        formatTime = selectedTime!.format(context);
      });
    }
  }
}