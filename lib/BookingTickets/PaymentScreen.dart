import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // للوصول لـ User ID
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:Eveno/UI/home/home_screen.dart';
import 'package:Eveno/UI/tabs/tabs_widgets/custom_elevated_button.dart';
import 'package:Eveno/firebase/event_model.dart';
import 'package:Eveno/utls/app_colo.dart';
import 'package:Eveno/utls/app_style.dart';
import 'package:provider/provider.dart';
import 'package:Eveno/providers/eventList_proider.dart';

class PaymentScreen extends StatefulWidget {
  final Event event;
  final int quantity;
  final String name;
  final String email;
  final String phone;

  const PaymentScreen({
    super.key,
    required this.event,
    required this.quantity,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}
bool _isBookingInProgress = false;
class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'Cash';
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isReceiptGenerated = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _generateReceipt(bool isPaid) async {
    final pdf = pw.Document();
    final logoImage = await _loadImage('assets/logo.png'); // استبدل بمسار الصورة الفعلي

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(200, 300),
        build: (pw.Context context) => pw.Container(
          color: PdfColors.white,
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (logoImage != null)
                pw.Image(logoImage, width: 80, height: 80),
              pw.SizedBox(height: 12),
              pw.Text(
                'Event Receipt',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.indigo,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(color: PdfColors.grey),
              pw.SizedBox(height: 12),
              // المربع الأول: عنوان الإيفينت والتاريخ
              pw.Container(
                padding: const pw.EdgeInsets.all(7),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(7),
                  border: pw.Border.all(color: PdfColors.grey400),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildReceiptRow('Event', widget.event.eventTitle),
                    _buildReceiptRow('Date', DateFormat('dd/MM/yyyy').format(widget.event.eventDate)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              // المستطيل تحته: عدد التذاكر والتوتال
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: PdfColors.grey400),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildReceiptRow('Quantity', widget.quantity.toString()),
                    _buildReceiptRow(
                      'Total',
                      '${widget.event.isFree ? 0 : widget.quantity * widget.event.ticketPrice} EGP',
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              // المستطيل تحته: حالة الدفع
              pw.Text(
                _paymentMethod == 'Visa' ? 'Paid' : 'Pay at Venue',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              // تفاصيل العميل
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildReceiptRow('Name', widget.name),
                    _buildReceiptRow('Email', widget.email),
                    _buildReceiptRow('Phone', widget.phone),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              // تاريخ اليوم
              pw.Text('Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}', style: pw.TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<pw.MemoryImage?> _loadImage(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final uint8List = byteData.buffer.asUint8List();
      return pw.MemoryImage(uint8List);
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  pw.Widget _buildReceiptRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: pw.TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Future<void> _scheduleNotification() async {
    final DateTime eventDate = widget.event.eventDate;
    final DateTime reminderDate = eventDate.subtract(const Duration(days: 1));
    final DateTime now = DateTime.now();
    if (reminderDate.isAfter(now)) {
      await FirebaseMessaging.instance.subscribeToTopic('event_reminders');
      await FirebaseMessaging.instance.sendMessage(
        to: await FirebaseMessaging.instance.getToken() ?? '',
        data: {'title': 'Event Reminder', 'body': 'Your event "${widget.event.eventTitle}" is tomorrow at ${widget.event.eventTime}!'},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.notification_scheduled)));
    }
  }

  Future<void> _saveBooking(bool isPaid) async {
    await FirebaseFirestore.instance.collection('bookings').add({
      'eventId': widget.event.id,
      'userName': widget.name,
      'email': widget.email,
      'phone': widget.phone,
      'quantity': widget.quantity,
      'total': widget.quantity * widget.event.ticketPrice,
      'paymentStatus': isPaid ? 'Paid' : 'Pending',
      'eventDate': widget.event.eventDate,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveToMyevents() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('my_events').doc(user.uid).collection('events').add({
        'eventId': widget.event.id,
        'eventTitle': widget.event.eventTitle,
        'eventDate': widget.event.eventDate,
        'eventTime': widget.event.eventTime,
        'eventLocation': widget.event.eventLocation,
        'quantity': widget.quantity,
        'total': widget.quantity * widget.event.ticketPrice,
        'paymentStatus': _paymentMethod == 'Visa' ? 'Paid' : 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  void _onDonePressed(BuildContext context) {
    final eventProvider = Provider.of<EventListProvider>(context, listen: false);

    // ✅ نضيف الحدث لو مش موجود في المفضلات أو في قائمة الأحداث الخاصة
    bool alreadyAdded = eventProvider.myevents.any((e) => e.id == widget.event.id);
    if (!alreadyAdded) {
      eventProvider.addMyEvent(widget.event);
    }

    // ✅ ننقل على طول للهوم ونمسح اللي قبلها من الستاك
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        // لو حاول يخرج يدويًا بعد إنشاء الوصل، نخليه يستخدم الزرار
        if (!didPop && _isReceiptGenerated) {
          // من غير انتقال تلقائي
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.payment_method, style: AppStyle.blue16bold),
          centerTitle: true,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColor.primaryDark
              : AppColor.whiteColor,
          iconTheme: const IconThemeData(color: AppColor.babyBlueColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.select_payment_method,
                  style: Theme.of(context).brightness == Brightness.dark
                      ? AppStyle.white16bold
                      : AppStyle.black16Bold,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Cash'),
                  leading: Radio<String>(
                    value: 'Cash',
                    groupValue: _paymentMethod,
                    onChanged: (value) => setState(() => _paymentMethod = value!),
                  ),
                ),
                ListTile(
                  title: const Text('Visa'),
                  leading: Radio<String>(
                    value: 'Visa',
                    groupValue: _paymentMethod,
                    onChanged: (value) => setState(() => _paymentMethod = value!),
                  ),
                ),
                if (_paymentMethod == 'Visa') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.card_number,
                      hintText: 'XXXX XXXX XXXX XXXX',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value == null || value.length != 16
                        ? AppLocalizations.of(context)!.please_enter_valid_card
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryDateController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.expiry_date,
                            hintText: 'MM/YY',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (value) => value == null || value.isEmpty
                              ? null
                              : !RegExp(r'^(0[1-9]|1[0-2])/[0-9]{2}$').hasMatch(value)
                              ? AppLocalizations.of(context)!.please_enter_valid_expiry
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.cvv,
                            hintText: '123',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                          value == null || value.length != 3
                              ? AppLocalizations.of(context)!.please_enter_valid_cvv
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomElevatedButton(
                        text: _paymentMethod == 'Cash'
                            ? AppLocalizations.of(context)!.ok
                            : AppLocalizations.of(context)!.confirm_payment,
                        textStyle: AppStyle.white16bold,
                        onClickedButton: () async {
                          if (_paymentMethod == 'Visa' && !_formKey.currentState!.validate()) return;

                          await _generateReceipt(_paymentMethod == 'Visa');

                          await _saveBooking(_paymentMethod == 'Visa'); // ✅ نحجز الحدث فعليًا
                          setState(() => _isReceiptGenerated = true); // ✅ نعرض زرار Done
                        },
                      ),
                      if (_isReceiptGenerated)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: CustomElevatedButton(
                            text: AppLocalizations.of(context)!.done,
                            textStyle: AppStyle.white16bold,
                            onClickedButton: () {
                              final eventProvider = Provider.of<EventListProvider>(context, listen: false);

                              // ✅ نضيف الحدث إلى Myevents لو مش مضاف قبل كده
                              final exists = eventProvider.myevents.any((e) => e.id == widget.event.id);
                              if (!exists) {
                                eventProvider.addMyEvent(widget.event);
                              }

                              // ✅ نرجع للهوم
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    (route) => false,
                              );
                            },
                          ),
                        ),
                    ],
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