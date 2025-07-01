// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Personalize Your Experience`
  String get personalize_your_experience {
    return Intl.message(
      'Personalize Your Experience',
      name: 'personalize_your_experience',
      desc: '',
      args: [],
    );
  }

  /// `Choose your preferred theme and language to get started with a comfortable, tailored experience that suits your style.`
  String get choose_your_theme {
    return Intl.message(
      'Choose your preferred theme and language to get started with a comfortable, tailored experience that suits your style.',
      name: 'choose_your_theme',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Let’s Start`
  String get lets_start {
    return Intl.message('Let’s Start', name: 'lets_start', desc: '', args: []);
  }

  /// `Find Events That Inspire You`
  String get find_events_inspire {
    return Intl.message(
      'Find Events That Inspire You',
      name: 'find_events_inspire',
      desc: '',
      args: [],
    );
  }

  /// `Dive into a world of events crafted to fit your unique interests. Whether you're into live music, art workshops, professional networking, or simply discovering new experiences, we have something for everyone. Our curated recommendations will help you explore, connect, and make the most of every opportunity around you.`
  String get dive_into_events {
    return Intl.message(
      'Dive into a world of events crafted to fit your unique interests. Whether you\'re into live music, art workshops, professional networking, or simply discovering new experiences, we have something for everyone. Our curated recommendations will help you explore, connect, and make the most of every opportunity around you.',
      name: 'dive_into_events',
      desc: '',
      args: [],
    );
  }

  /// `Effortless Event Planning`
  String get efforts_event_planning {
    return Intl.message(
      'Effortless Event Planning',
      name: 'efforts_event_planning',
      desc: '',
      args: [],
    );
  }

  /// `Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we’ve got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.`
  String get take_organizing_events {
    return Intl.message(
      'Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we’ve got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.',
      name: 'take_organizing_events',
      desc: '',
      args: [],
    );
  }

  /// `Connect with Friends & Share Moments`
  String get connect_with_friends_share_moments {
    return Intl.message(
      'Connect with Friends & Share Moments',
      name: 'connect_with_friends_share_moments',
      desc: '',
      args: [],
    );
  }

  /// `Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.`
  String get make_every_event_memorable {
    return Intl.message(
      'Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.',
      name: 'make_every_event_memorable',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forget Password?`
  String get forget_password {
    return Intl.message(
      'Forget Password?',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get doNotHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get create_account {
    return Intl.message(
      'Create Account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message('Or', name: 'or', desc: '', args: []);
  }

  /// `Login With Google`
  String get login_with_google {
    return Intl.message(
      'Login With Google',
      name: 'login_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Re Password`
  String get re_password {
    return Intl.message('Re Password', name: 're_password', desc: '', args: []);
  }

  /// `Already Have Account ?`
  String get already_have_account {
    return Intl.message(
      'Already Have Account ?',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back ✨`
  String get welcome_back {
    return Intl.message(
      'Welcome Back ✨',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Cairo,Egypt`
  String get cairo_egypt {
    return Intl.message('Cairo,Egypt', name: 'cairo_egypt', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Sport`
  String get sport {
    return Intl.message('Sport', name: 'sport', desc: '', args: []);
  }

  /// `Birthday`
  String get birthday {
    return Intl.message('Birthday', name: 'birthday', desc: '', args: []);
  }

  /// `Meeting`
  String get meeting {
    return Intl.message('Meeting', name: 'meeting', desc: '', args: []);
  }

  /// `Exhibition`
  String get exhibition {
    return Intl.message('Exhibition', name: 'exhibition', desc: '', args: []);
  }

  /// `Gaming`
  String get gaming {
    return Intl.message('Gaming', name: 'gaming', desc: '', args: []);
  }

  /// `Eating`
  String get eating {
    return Intl.message('Eating', name: 'eating', desc: '', args: []);
  }

  /// `Holiday`
  String get holiday {
    return Intl.message('Holiday', name: 'holiday', desc: '', args: []);
  }

  /// `Work Shop`
  String get work_shop {
    return Intl.message('Work Shop', name: 'work_shop', desc: '', args: []);
  }

  /// `Book Club`
  String get book_club {
    return Intl.message('Book Club', name: 'book_club', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `Love`
  String get love {
    return Intl.message('Love', name: 'love', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Search for Event`
  String get search_for_event {
    return Intl.message(
      'Search for Event',
      name: 'search_for_event',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Create Event`
  String get create_event {
    return Intl.message(
      'Create Event',
      name: 'create_event',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Event Title`
  String get event_title {
    return Intl.message('Event Title', name: 'event_title', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Event Description`
  String get event_description {
    return Intl.message(
      'Event Description',
      name: 'event_description',
      desc: '',
      args: [],
    );
  }

  /// `Event Date`
  String get event_date {
    return Intl.message('Event Date', name: 'event_date', desc: '', args: []);
  }

  /// `Event Time`
  String get event_time {
    return Intl.message('Event Time', name: 'event_time', desc: '', args: []);
  }

  /// `Choose Date`
  String get choose_date {
    return Intl.message('Choose Date', name: 'choose_date', desc: '', args: []);
  }

  /// `Choose Time`
  String get choose_time {
    return Intl.message('Choose Time', name: 'choose_time', desc: '', args: []);
  }

  /// `Choose Event Location`
  String get choose_event_location {
    return Intl.message(
      'Choose Event Location',
      name: 'choose_event_location',
      desc: '',
      args: [],
    );
  }

  /// `Add Event`
  String get add_event {
    return Intl.message('Add Event', name: 'add_event', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Event Details`
  String get event_details {
    return Intl.message(
      'Event Details',
      name: 'event_details',
      desc: '',
      args: [],
    );
  }

  /// `Edit Event`
  String get edit_event {
    return Intl.message('Edit Event', name: 'edit_event', desc: '', args: []);
  }

  /// `Update Event`
  String get update_event {
    return Intl.message(
      'Update Event',
      name: 'update_event',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Forget Password`
  String get forget_password2 {
    return Intl.message(
      'Forget Password',
      name: 'forget_password2',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Event Title`
  String get please_enter_event_title {
    return Intl.message(
      'Please Enter Event Title',
      name: 'please_enter_event_title',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Event Description`
  String get please_enter_event_description {
    return Intl.message(
      'Please Enter Event Description',
      name: 'please_enter_event_description',
      desc: '',
      args: [],
    );
  }

  /// `Opps! No Favorite Events Found`
  String get no_favorite_events_found {
    return Intl.message(
      'Opps! No Favorite Events Found',
      name: 'no_favorite_events_found',
      desc: '',
      args: [],
    );
  }

  /// `Opps! No Events Found`
  String get no_events_found {
    return Intl.message(
      'Opps! No Events Found',
      name: 'no_events_found',
      desc: '',
      args: [],
    );
  }

  /// `other`
  String get other {
    return Intl.message('other', name: 'other', desc: '', args: []);
  }

  /// `Booking Details`
  String get booking_details {
    return Intl.message(
      'Booking Details',
      name: 'booking_details',
      desc: '',
      args: [],
    );
  }

  /// `Personal Details`
  String get personal_details {
    return Intl.message(
      'Personal Details',
      name: 'personal_details',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name {
    return Intl.message('Full Name', name: 'full_name', desc: '', args: []);
  }

  /// `Enter your full name`
  String get enter_full_name {
    return Intl.message(
      'Enter your full name',
      name: 'enter_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name`
  String get please_enter_full_name {
    return Intl.message(
      'Please enter your full name',
      name: 'please_enter_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enter_email {
    return Intl.message(
      'Enter your email',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get please_enter_valid_email {
    return Intl.message(
      'Please enter a valid email',
      name: 'please_enter_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Enter your phone number`
  String get enter_phone {
    return Intl.message(
      'Enter your phone number',
      name: 'enter_phone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get please_enter_valid_phone {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'please_enter_valid_phone',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Booking`
  String get confirm_booking {
    return Intl.message(
      'Confirm Booking',
      name: 'confirm_booking',
      desc: '',
      args: [],
    );
  }

  /// `BookingConfirmed`
  String get booking_confirmed {
    return Intl.message(
      'BookingConfirmed',
      name: 'booking_confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Event Added Successfully`
  String get event_added_successfully {
    return Intl.message(
      'Event Added Successfully',
      name: 'event_added_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get payment_method {
    return Intl.message(
      'Payment Method',
      name: 'payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Select Payment Method`
  String get select_payment_method {
    return Intl.message(
      'Select Payment Method',
      name: 'select_payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get card_number {
    return Intl.message('Card Number', name: 'card_number', desc: '', args: []);
  }

  /// `Please enter a valid card number`
  String get please_enter_valid_card {
    return Intl.message(
      'Please enter a valid card number',
      name: 'please_enter_valid_card',
      desc: '',
      args: [],
    );
  }

  /// `Expiry Date`
  String get expiry_date {
    return Intl.message('Expiry Date', name: 'expiry_date', desc: '', args: []);
  }

  /// `Please enter a valid expiry date`
  String get please_enter_valid_expiry {
    return Intl.message(
      'Please enter a valid expiry date',
      name: 'please_enter_valid_expiry',
      desc: '',
      args: [],
    );
  }

  /// `CVV`
  String get cvv {
    return Intl.message('CVV', name: 'cvv', desc: '', args: []);
  }

  /// `Please enter a valid CVV`
  String get please_enter_valid_cvv {
    return Intl.message(
      'Please enter a valid CVV',
      name: 'please_enter_valid_cvv',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Payment`
  String get confirm_payment {
    return Intl.message(
      'Confirm Payment',
      name: 'confirm_payment',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `You will receive a reminder one day beforetheevent`
  String get notification_scheduled {
    return Intl.message(
      'You will receive a reminder one day beforetheevent',
      name: 'notification_scheduled',
      desc: '',
      args: [],
    );
  }

  /// `Search events`
  String get search_events {
    return Intl.message(
      'Search events',
      name: 'search_events',
      desc: '',
      args: [],
    );
  }

  /// `Free Event`
  String get free_event {
    return Intl.message('Free Event', name: 'free_event', desc: '', args: []);
  }

  /// `Ticket Price`
  String get ticket_price {
    return Intl.message(
      'Ticket Price',
      name: 'ticket_price',
      desc: '',
      args: [],
    );
  }

  /// `My Events`
  String get my_events {
    return Intl.message('My Events', name: 'my_events', desc: '', args: []);
  }

  /// `No booked events`
  String get no_booked_events {
    return Intl.message(
      'No booked events',
      name: 'no_booked_events',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Tickets`
  String get tickets {
    return Intl.message('Tickets', name: 'tickets', desc: '', args: []);
  }

  /// `Search Events`
  String get searchEvents {
    return Intl.message(
      'Search Events',
      name: 'searchEvents',
      desc: '',
      args: [],
    );
  }

  /// `Enter event name`
  String get searchHint {
    return Intl.message(
      'Enter event name',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Confirm Delete`
  String get confirm_delete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirm_delete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the event?`
  String get are_you_sure_delete_event {
    return Intl.message(
      'Are you sure you want to delete the event?',
      name: 'are_you_sure_delete_event',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
