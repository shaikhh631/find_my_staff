import 'package:find_my_staff/firebase_options.dart';
import 'package:find_my_staff/screens/common/app_localization.dart';
import 'package:find_my_staff/screens/common/settings.dart';
import 'package:find_my_staff/screens/contractor/contractor_hire.dart';
import 'package:find_my_staff/screens/contractor/contractor_tab_manager.dart';
import 'package:find_my_staff/screens/customer/customer_tab_manager.dart';
import 'package:find_my_staff/screens/customer/home.dart';
import 'package:find_my_staff/screens/welcome.dart';
import 'package:find_my_staff/screens/worker/worker_home.dart';
import 'package:find_my_staff/screens/worker/worker_tab_manager.dart';
import 'package:find_my_staff/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'app_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // String selectedLanguage =
  //     prefs.getString('language') ?? 'en'; // Default to English

  Widget homeScreen = WelcomeScreen();
  if (prefs.getString("email") != null) {
    String accType = prefs.getString("type")!;
    if (accType == AccountType.Customer.name.toLowerCase()) {
      homeScreen = CustomerTabManager();
    } else if (accType == AccountType.Contractor.name.toLowerCase()) {
      homeScreen = ContractorTabManager();
    } else if (accType == AccountType.Worker.name.toLowerCase()) {
      homeScreen = WorkerTabManager();
    }
  }
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(
    MyApp(
      homeScreen: homeScreen,
    ),
  );
  // runApp(
  //     MyApp(homeScreen: WelcomeScreen(), selectedLanguage: selectedLanguage));
}

enum AccountType { Customer, Worker, Contractor }

class MyApp extends StatelessWidget {
  // final String? selectedLanguage;
  Widget? homeScreen;

  MyApp({
    this.homeScreen,
    // this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find My Staff',
      theme: ThemeData(
        primaryColor: primaryColor,
        // primarySwatch: Colors.grey,
      ),

      // localizationsDelegates: [
      //   AppLocalizationsDelegate(), // Add this delegate
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   const Locale('en', ''),
      //   const Locale('ur', ''), // Add Urdu locale here
      // ],
      // locale: AppLocalization.of(context)!.locale,
      // theme: Provider.of<ThemeModel>(context).currentTheme,
      debugShowCheckedModeBanner: false,
      home: homeScreen,
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: AppLocalization.load(Locale(selectedLanguage!)),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         final appLocalization = snapshot.data as AppLocalization;
  //         return MaterialApp(
  //           title: 'Find My Staff',
  //           theme: ThemeData(
  //             primaryColor: primaryColor,
  //           ),
  //           localizationsDelegates: [
  //             AppLocalizationsDelegate(),
  //             GlobalMaterialLocalizations.delegate,
  //             GlobalWidgetsLocalizations.delegate,
  //           ],
  //           supportedLocales: [
  //             const Locale('en', ''),
  //             const Locale('ur', ''),
  //           ],
  //           locale: appLocalization.locale,
  //           debugShowCheckedModeBanner: false,
  //           home: homeScreen,
  //         );
  //       } else {
  //         return CircularProgressIndicator(); // or any loading indicator
  //       }
  //     },
  //   );
  // }
}
