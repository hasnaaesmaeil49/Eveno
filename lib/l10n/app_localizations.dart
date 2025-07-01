import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @personalize_your_experience.
  ///
  /// In ar, this message translates to:
  /// **'قم بتخصيص تجربتك'**
  String get personalize_your_experience;

  /// No description provided for @choose_your_theme.
  ///
  /// In ar, this message translates to:
  /// **'اختر السمة واللغة المفضلة لديك للبدء بتجربة مريحة ومصممة خصيصًا لتناسب أسلوبك.'**
  String get choose_your_theme;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الضوئي'**
  String get theme;

  /// No description provided for @lets_start.
  ///
  /// In ar, this message translates to:
  /// **'لنبدأ'**
  String get lets_start;

  /// No description provided for @find_events_inspire.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن الأحداث التي تلهمك'**
  String get find_events_inspire;

  /// No description provided for @dive_into_events.
  ///
  /// In ar, this message translates to:
  /// **'انغمس في عالم من الأحداث المصممة لتناسب اهتماماتك الفريدة. سواء كنت من محبي الموسيقى الحية أو ورش العمل الفنية أو التواصل المهني أو ببساطة اكتشاف تجارب جديدة، فلدينا ما يناسب الجميع. ستساعدك توصياتنا المنسقة على استكشاف كل فرصة من حولك والتواصل معها والاستفادة منها قدر الإمكان.'**
  String get dive_into_events;

  /// No description provided for @efforts_event_planning.
  ///
  /// In ar, this message translates to:
  /// **'تخطيط الأحداث دون عناء'**
  String get efforts_event_planning;

  /// No description provided for @take_organizing_events.
  ///
  /// In ar, this message translates to:
  /// **'تخلص من متاعب تنظيم الأحداث باستخدام أدوات التخطيط الشاملة لدينا. بدءًا من إعداد الدعوات وإدارة الردود على الدعوات إلى جدولة التذكيرات وتنسيق التفاصيل، فنحن نوفر لك كل ما تحتاجه. خطط بسهولة وركز على ما يهم - ابتكر تجربة لا تُنسى لك ولضيوفك.'**
  String get take_organizing_events;

  /// No description provided for @connect_with_friends_share_moments.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع الأصدقاء وشارك اللحظات'**
  String get connect_with_friends_share_moments;

  /// No description provided for @make_every_event_memorable.
  ///
  /// In ar, this message translates to:
  /// **'اجعل كل حدث لا يُنسى من خلال مشاركة التجربة مع الآخرين. تتيح لك منصتنا دعوة الأصدقاء وإبقاء الجميع على اطلاع دائم بالأحداث والاحتفال باللحظات معًا. التقط اللحظات المثيرة وشاركها مع شبكتك، حتى تتمكن من إحياء اللحظات المميزة والاعتزاز بالذكريات.'**
  String get make_every_event_memorable;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @forget_password.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forget_password;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @doNotHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get doNotHaveAccount;

  /// No description provided for @create_account.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get create_account;

  /// No description provided for @or.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get or;

  /// No description provided for @login_with_google.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول باستخدام جوجل'**
  String get login_with_google;

  /// No description provided for @name.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get name;

  /// No description provided for @re_password.
  ///
  /// In ar, this message translates to:
  /// **'إعادة كلمة المرور'**
  String get re_password;

  /// No description provided for @already_have_account.
  ///
  /// In ar, this message translates to:
  /// **'هل لديك حساب بالفعل؟'**
  String get already_have_account;

  /// No description provided for @reset_password.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get reset_password;

  /// No description provided for @welcome_back.
  ///
  /// In ar, this message translates to:
  /// **' مرحبا بعودتك ✨'**
  String get welcome_back;

  /// No description provided for @cairo_egypt.
  ///
  /// In ar, this message translates to:
  /// **'القاهرة، مصر'**
  String get cairo_egypt;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'كل شئ'**
  String get all;

  /// No description provided for @sport.
  ///
  /// In ar, this message translates to:
  /// **'رياضه'**
  String get sport;

  /// No description provided for @birthday.
  ///
  /// In ar, this message translates to:
  /// **'عيد ميلاد'**
  String get birthday;

  /// No description provided for @meeting.
  ///
  /// In ar, this message translates to:
  /// **'اجتماع'**
  String get meeting;

  /// No description provided for @exhibition.
  ///
  /// In ar, this message translates to:
  /// **'معرض'**
  String get exhibition;

  /// No description provided for @gaming.
  ///
  /// In ar, this message translates to:
  /// **'الألعاب'**
  String get gaming;

  /// No description provided for @eating.
  ///
  /// In ar, this message translates to:
  /// **'أكل'**
  String get eating;

  /// No description provided for @holiday.
  ///
  /// In ar, this message translates to:
  /// **'إجازه'**
  String get holiday;

  /// No description provided for @work_shop.
  ///
  /// In ar, this message translates to:
  /// **'ورشة عمل'**
  String get work_shop;

  /// No description provided for @book_club.
  ///
  /// In ar, this message translates to:
  /// **'نادي الكتاب'**
  String get book_club;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @map.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get map;

  /// No description provided for @love.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get love;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @search_for_event.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن حدث معين'**
  String get search_for_event;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'اللغة العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'اللغة الانجليزية'**
  String get english;

  /// No description provided for @light.
  ///
  /// In ar, this message translates to:
  /// **'مضئ'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In ar, this message translates to:
  /// **'مظلم'**
  String get dark;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @create_event.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حدث معين'**
  String get create_event;

  /// No description provided for @title.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get title;

  /// No description provided for @event_title.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الحدث'**
  String get event_title;

  /// No description provided for @description.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get description;

  /// No description provided for @event_description.
  ///
  /// In ar, this message translates to:
  /// **'وصف الحدث'**
  String get event_description;

  /// No description provided for @event_date.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الحدث'**
  String get event_date;

  /// No description provided for @event_time.
  ///
  /// In ar, this message translates to:
  /// **'وقت الحدث'**
  String get event_time;

  /// No description provided for @choose_date.
  ///
  /// In ar, this message translates to:
  /// **'إختار تاريخ معين'**
  String get choose_date;

  /// No description provided for @choose_time.
  ///
  /// In ar, this message translates to:
  /// **'إختار وقت معين'**
  String get choose_time;

  /// No description provided for @choose_event_location.
  ///
  /// In ar, this message translates to:
  /// **'إختار مكان الحدث'**
  String get choose_event_location;

  /// No description provided for @add_event.
  ///
  /// In ar, this message translates to:
  /// **'إضافة حدث معين'**
  String get add_event;

  /// No description provided for @location.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get location;

  /// No description provided for @event_details.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الحدث'**
  String get event_details;

  /// No description provided for @edit_event.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الحدث'**
  String get edit_event;

  /// No description provided for @update_event.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الحدث'**
  String get update_event;

  /// No description provided for @register.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل حساب'**
  String get register;

  /// No description provided for @forget_password2.
  ///
  /// In ar, this message translates to:
  /// **' نسيت كلمة السر'**
  String get forget_password2;

  /// No description provided for @please_enter_event_title.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك قم بإدخال عنوان الحدث'**
  String get please_enter_event_title;

  /// No description provided for @please_enter_event_description.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك قم بإدخال وصف الحدث'**
  String get please_enter_event_description;

  /// No description provided for @no_favorite_events_found.
  ///
  /// In ar, this message translates to:
  /// **' للأسف ! لا يوجد أي حدث مفضل '**
  String get no_favorite_events_found;

  /// No description provided for @no_events_found.
  ///
  /// In ar, this message translates to:
  /// **'للأسف! لا يوجد أي حدث'**
  String get no_events_found;

  /// No description provided for @other.
  ///
  /// In ar, this message translates to:
  /// **'نوع آخر'**
  String get other;

  /// No description provided for @event_added_successfully.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة الفعالية بنجاح'**
  String get event_added_successfully;

  /// No description provided for @payment_method.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get payment_method;

  /// No description provided for @select_payment_method.
  ///
  /// In ar, this message translates to:
  /// **'اختر طريقة الدفع'**
  String get select_payment_method;

  /// No description provided for @card_number.
  ///
  /// In ar, this message translates to:
  /// **'رقم الكارت'**
  String get card_number;

  /// No description provided for @booking_details.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الحجز'**
  String get booking_details;

  /// No description provided for @personal_details.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل الشخصية'**
  String get personal_details;

  /// No description provided for @full_name.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get full_name;

  /// No description provided for @enter_full_name.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسمك الكامل'**
  String get enter_full_name;

  /// No description provided for @please_enter_full_name.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك أدخل اسمك الكامل'**
  String get please_enter_full_name;

  /// No description provided for @enter_email.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني'**
  String get enter_email;

  /// No description provided for @please_enter_valid_email.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك أدخل بريدًا إلكترونيًا صحيحًا'**
  String get please_enter_valid_email;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phone;

  /// No description provided for @enter_phone.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتفك'**
  String get enter_phone;

  /// No description provided for @please_enter_valid_phone.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك أدخل رقم هاتف صحيح'**
  String get please_enter_valid_phone;

  /// No description provided for @confirm_booking.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحجز'**
  String get confirm_booking;

  /// No description provided for @booking_confirmed.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد الحجز'**
  String get booking_confirmed;

  /// No description provided for @please_enter_valid_card.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك أدخل رقم كارت صحيح'**
  String get please_enter_valid_card;

  /// No description provided for @expiry_date.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الانتهاء'**
  String get expiry_date;

  /// No description provided for @please_enter_valid_expiry.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك أدخل تاريخ انتهاء صحيح'**
  String get please_enter_valid_expiry;

  /// No description provided for @cvv.
  ///
  /// In ar, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @please_enter_valid_cvv.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك أدخل CVV صحيح'**
  String get please_enter_valid_cvv;

  /// No description provided for @confirm_payment.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الدفع'**
  String get confirm_payment;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'موافق'**
  String get ok;

  /// No description provided for @notification_scheduled.
  ///
  /// In ar, this message translates to:
  /// **'سوف تتلقى تذكيرًا يوم قبل الحدث'**
  String get notification_scheduled;

  /// No description provided for @search_events.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن الفعاليات'**
  String get search_events;

  /// No description provided for @free_event.
  ///
  /// In ar, this message translates to:
  /// **'حدث مجاني'**
  String get free_event;

  /// No description provided for @ticket_price.
  ///
  /// In ar, this message translates to:
  /// **'سعر التذكرة'**
  String get ticket_price;

  /// No description provided for @my_events.
  ///
  /// In ar, this message translates to:
  /// **'أحداثي'**
  String get my_events;

  /// No description provided for @no_booked_events.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد أحداث محجوزة'**
  String get no_booked_events;

  /// No description provided for @date.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get date;

  /// No description provided for @tickets.
  ///
  /// In ar, this message translates to:
  /// **'التذاكر'**
  String get tickets;

  /// No description provided for @searchEvents.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن الفعاليات'**
  String get searchEvents;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم الفعالية'**
  String get searchHint;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @confirm_delete.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحذف'**
  String get confirm_delete;

  /// No description provided for @are_you_sure_delete_event.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف الحدث؟'**
  String get are_you_sure_delete_event;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get yes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
