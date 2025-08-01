import 'package:flutter/material.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // لاستخدام Provider
import 'package:Eveno/providers/eventList_proider.dart'; // لإضافة الإيفينت لـ My events
import 'package:Eveno/UI/tabs/tabs_widgets/custom_elevated_button.dart';
import 'package:Eveno/firebase/event_model.dart';
import 'package:Eveno/utls/app_colo.dart';
import 'package:Eveno/utls/app_images.dart';
import 'package:Eveno/utls/app_style.dart';
import 'package:Eveno/UI/home/Home_screen.dart'; // استيراد Home Screen
import 'package:Eveno/BookingTickets/PaymentScreen.dart';

class BookingScreen extends StatefulWidget {
  final Event event;
  final int quantity;

  const BookingScreen({super.key, required this.event, required this.quantity});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onConfirmBooking(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final eventProvider = Provider.of<EventListProvider>(context, listen: false);
      if (widget.event.isFree) {
        // إذا كان الإيفينت مجاني
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.booking_confirmed)),
        );
        eventProvider.addMyEvent(widget.event); // إضافة لـ My events
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // إذا كان الإيفينت مدفوع
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              event: widget.event,
              quantity: widget.quantity,
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.booking_details,
          style: AppStyle.blue16bold,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.primaryDark
            : AppColor.whiteColor,
        iconTheme: const IconThemeData(color: AppColor.babyBlueColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة الإيفينت
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.event.eventImage.isNotEmpty
                      ? Image.network(
                    widget.event.eventImage,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                          AppImages.otherImgLight,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                  )
                      : Image.asset(
                    AppImages.otherImgLight,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                // تفاصيل الإيفينت
                Text(
                  widget.event.eventTitle,
                  style: Theme.of(context).brightness == Brightness.dark
                      ? AppStyle.white16bold
                      : AppStyle.black16Bold,
                ),
                Text(
                  'Date: ${DateFormat('dd/MM/yyyy').format(widget.event.eventDate)}',
                  style: AppStyle.grey16Medium,
                ),
                Text(
                  'Time: ${widget.event.eventTime}',
                  style: AppStyle.grey16Medium,
                ),
                Text(
                  'Location: ${widget.event.eventLocation}',
                  style: AppStyle.grey16Medium,
                ),
                Text(
                  'Quantity: ${widget.quantity}',
                  style: AppStyle.grey16Medium,
                ),
                Text(
                  'Total: ${(widget.event.isFree ? 0 : widget.quantity * widget.event.ticketPrice)} EGP',
                  style: AppStyle.blue16bold,
                ),
                const SizedBox(height: 24),
                // نموذج الحجز
                Text(
                  AppLocalizations.of(context)!.personal_details,
                  style: Theme.of(context).brightness == Brightness.dark
                      ? AppStyle.white16bold
                      : AppStyle.black16Bold,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.full_name,
                    hintText: AppLocalizations.of(context)!.enter_full_name,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .please_enter_full_name;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    hintText: AppLocalizations.of(context)!.enter_email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return AppLocalizations.of(context)!
                          .please_enter_valid_email;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phone,
                    hintText: AppLocalizations.of(context)!.enter_phone,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.length < 10) {
                      return AppLocalizations.of(context)!
                          .please_enter_valid_phone;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // زر المتابعة
                Center(
                  child: CustomElevatedButton(
                    text: AppLocalizations.of(context)!.confirm_booking,
                    textStyle: AppStyle.white16bold,
                    onClickedButton: () => _onConfirmBooking(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}