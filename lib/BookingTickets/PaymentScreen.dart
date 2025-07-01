import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle; // إضافة هذا الـ import
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:Eveno/UI/home/home_screen.dart';
import 'package:Eveno/UI/tabs/tabs_widgets/custom_elevated_button.dart';
import 'package:Eveno/firebase/event_model.dart';
import 'package:Eveno/utls/app_colo.dart';
import 'package:Eveno/utls/app_style.dart';
import 'package:provider/provider.dart';
import 'package:Eveno/providers/eventList_proider.dart';
import 'package:Eveno/utls/app_images.dart'; // تأكدي إن الملف ده موجود

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

  // دالة لإنشاء الوصل كـ PDF بتصميم محسّن
  Future<void> _generateReceipt(bool isPaid) async {
    final pdf = pw.Document();
    final logoImage = await _loadImage('assets/logo.png'); // استبدل بمسار الصورة الفعلي

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            // اللوجو أو العنوان
            if (logoImage != null) pw.Image(logoImage, width: 100, height: 100),
            pw.SizedBox(height: 20),
            pw.Text('Event Receipt', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            pw.SizedBox(height: 20),
            // تفاصيل الإيفينت
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildReceiptRow('Event', widget.event.eventTitle),
                  _buildReceiptRow('Date', DateFormat('dd/MM/yyyy').format(widget.event.eventDate)),
                  _buildReceiptRow('Time', widget.event.eventTime),
                  _buildReceiptRow('Location', widget.event.eventLocation),
                  _buildReceiptRow('Quantity', widget.quantity.toString()),
                  _buildReceiptRow('Total', '${widget.event.isFree ? 0 : widget.quantity * widget.event.ticketPrice} EGP'),
                ],
              ),
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
            // حالة الدفع
            pw.Text('Payment Status: ${isPaid ? 'Paid' : 'Pay at Venue'}', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 20),
            // تاريخ اليوم
            pw.Text('Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}', style: pw.TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  // دالة مساعدة لتحميل الصور
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

  // دالة مساعدة لعرض الصفوف في الوصل
  pw.Widget _buildReceiptRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text(value)],
    );
  }

  // دالة لإرسال إشعار التذكير
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

  void _onDonePressed(BuildContext context) {
    final eventProvider = Provider.of<EventListProvider>(context, listen: false);
    eventProvider.addMyEvent(widget.event);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.payment_method, style: AppStyle.blue16bold),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColor.primaryDark : AppColor.whiteColor,
        iconTheme: const IconThemeData(color: AppColor.babyBlueColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.select_payment_method, style: Theme.of(context).brightness == Brightness.dark ? AppStyle.white16bold : AppStyle.black16Bold),
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
                  validator: (value) => value == null || value.length != 16 ? AppLocalizations.of(context)!.please_enter_valid_card : null,
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
                        validator: (value) =>
                        value == null || value.isEmpty
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
                        validator: (value) => value == null || value.length != 3 ? AppLocalizations.of(context)!.please_enter_valid_cvv : null,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Center(
                child: _isReceiptGenerated
                    ? ElevatedButton(onPressed: () => _onDonePressed(context), child: const Text('Done'))
                    : CustomElevatedButton(
                  text: _paymentMethod == 'Cash' ? AppLocalizations.of(context)!.ok : AppLocalizations.of(context)!.confirm_payment,
                  textStyle: AppStyle.white16bold,
                  onClickedButton: () async {
                    if (_paymentMethod == 'Visa' && !_formKey.currentState!.validate()) return;
                    await _generateReceipt(_paymentMethod == 'Visa');
                    await _saveBooking(_paymentMethod == 'Visa');
                    await _scheduleNotification();
                    setState(() => _isReceiptGenerated = true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}