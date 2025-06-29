import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw ;
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../UI/home/home_screen.dart';
import '../UI/tabs/tabs_widgets/custom_elevated_button.dart';
import '../firebase/event_model.dart';
import '../utls/app_colo.dart';
import '../utls/app_style.dart';


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

  // دالة لإنشاء الوصل كـ PDF
  Future<void> _generateReceipt(bool isPaid) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Event Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Event: ${widget.event.eventTitle}'),
            pw.Text('Date: ${DateFormat('dd/MM/yyyy').format(widget.event.eventDate)}'),
            pw.Text('Time: ${widget.event.eventTime}'),
            pw.Text('Location: ${widget.event.eventLocation}'),
            pw.Text('Quantity: ${widget.quantity}'),
            pw.Text('Total: ${(widget.event.availableTickets > 0 ? widget.quantity * 10 : 0)} EGP'),
            pw.Text('Name: ${widget.name}'),
            pw.Text('Email: ${widget.email}'),
            pw.Text('Phone: ${widget.phone}'),
            pw.SizedBox(height: 20),
            pw.Text('Payment Status: ${isPaid ? 'Paid' : 'Pay at Venue'}'),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
        onLayout: (format) => pdf.save(),
    );
  }

  // دالة لإرسال إشعار التذكير
  Future<void> _scheduleNotification() async {
    final DateTime eventDate = widget.event.eventDate;
    final DateTime reminderDate = eventDate.subtract(const Duration(days: 1));
    final DateTime now = DateTime.now();
    if (reminderDate.isAfter(now)) {
      // هنا ممكن تستخدمي Firebase Functions أو باك إند لجدولة الإشعار
      // مثال بسيط: إشعار فوري للاختبار
      await FirebaseMessaging.instance.subscribeToTopic('event_reminders');
      await FirebaseMessaging.instance.sendMessage(
        to: await FirebaseMessaging.instance.getToken() ?? '',
        data: {
          'title': 'Event Reminder',
          'body': 'Your event "${widget.event.eventTitle}" is tomorrow at ${widget.event.eventTime}!',
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.notification_scheduled)),
      );
    }
  }
  Future<void> _saveBooking(bool isPaid) async {
    await FirebaseFirestore.instance.collection('bookings').add({
      'eventId': widget.event.id,
      'userName': widget.name,
      'email': widget.email,
      'phone': widget.phone,
      'quantity': widget.quantity,
      'total': widget.quantity * 10,
      'paymentStatus': isPaid ? 'Paid' : 'Pending',
      'eventDate': widget.event.eventDate,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.payment_method,
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
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Visa'),
                leading: Radio<String>(
                  value: 'Visa',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                ),
              ),
              if (_paymentMethod == 'Visa') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.card_number,
                    hintText: 'XXXX XXXX XXXX XXXX',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.length != 16) {
                      return AppLocalizations.of(context)!.please_enter_valid_card;
                    }
                    return null;
                  },
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          if (!RegExp(r'^(0[1-9]|1[0-2])/[0-9]{2}$').hasMatch(value)) {
                            return AppLocalizations.of(context)!.please_enter_valid_expiry;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.cvv,
                          hintText: '123',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.length != 3) {
                            return AppLocalizations.of(context)!.please_enter_valid_cvv;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.cvv,
                          hintText: '123',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.length != 3) {
                            return AppLocalizations.of(context)!.please_enter_valid_cvv;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Center(
                child: _isReceiptGenerated
                    ? ElevatedButton(
                  onPressed: () {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم الحجز بنجاح')),
                    );
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text('Done'),
                )
                    : CustomElevatedButton(
                  text: _paymentMethod == 'Cash' ? AppLocalizations.of(context)!.ok : AppLocalizations.of(context)!.confirm_payment,
                  textStyle: AppStyle.white16bold,
                  onClickedButton: () async {
                    if (_paymentMethod == 'Visa' && !_formKey.currentState!.validate()) {
                      return;
                    }
                    await _generateReceipt(_paymentMethod == 'Visa');
                    setState(() {
                      _isReceiptGenerated = true;
                    });
                    await _scheduleNotification();
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