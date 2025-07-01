import 'package:Eveno/UI/authentication/forget_password/forget_password_screen.dart';
import 'package:Eveno/UI/authentication/login/login_screen.dart';
import 'package:Eveno/UI/authentication/register/lregister_screen.dart';
import 'package:Eveno/UI/home/home_screen.dart';
import 'package:Eveno/UI/tabs/add_event/add_event.dart';
import 'package:Eveno/firebase_options.dart';
import 'package:Eveno/providers/app_language_provider.dart';
import 'package:Eveno/providers/app_theme_provider.dart';
import 'package:Eveno/providers/eventList_proider.dart';
import 'package:Eveno/utls/app_routes.dart';
import 'package:Eveno/utls/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Eveno/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Eveno/firebase/event_model.dart';
import 'package:Eveno/notifications/notification_helper.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await FirebaseFirestore.instance.disableNetwork();
  await initializeNotifications();
  // تهيئة Hive
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  await Hive.openBox<Event>('eventsBox');

  //runApp(MyApp());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (context) => AppThemeProvider()),
        ChangeNotifierProvider(create:(context)=> EventListProvider()),
      ],
      child: const EventlyApp(),
    ),
  );
}

class EventlyApp extends StatelessWidget {
  const EventlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouting.routeLogin,
      routes: {
        AppRouting.routeHome: (context) => const HomeScreen(),
        AppRouting.routeLogin:(context)=> const LoginScreen(),
        AppRouting.routeRegister:(context)=> const RegisterScreen(),
        AppRouting.routeForgetPassword:(context)=> const ForgetPasswordScreen(),
        AppRouting.routeAddEvent:(context)=> const AddEvent(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.appLanguage),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.appTheme,
    );
  }
}
