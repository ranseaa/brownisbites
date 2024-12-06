import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Browniesbites/common/color_extension.dart';
import 'package:Browniesbites/common/locator.dart';
import 'package:Browniesbites/common/service_call.dart';
import 'package:Browniesbites/view/login/welcome_view.dart';
import 'package:Browniesbites/view/main_tabview/main_tabview.dart';
import 'package:Browniesbites/view/on_boarding/startup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/globs.dart';
import 'common/my_http_overrides.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

SharedPreferences? prefs;

Future<void> main() async {
  // Inisialisasi Locator dan Firebase
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  HttpOverrides.global = MyHttpOverrides();

  // Inisialisasi Firebase dengan konfigurasi platform yang sesuai
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi SharedPreferences
  prefs = await SharedPreferences.getInstance();

  // Cek Status Login
  if (Globs.udValueBool(Globs.userLogin)) {
    ServiceCall.userPayload = Globs.udValue(Globs.userPayload);
  }

  // Jalankan Aplikasi
  runApp(const MyApp(defaultHome: StartupView()));
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 5.0
    ..progressColor = TColor.primaryText
    ..backgroundColor = TColor.primary
    ..indicatorColor = Colors.yellow
    ..textColor = TColor.primaryText
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brownies Bites',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: widget.defaultHome,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case "welcome":
            return MaterialPageRoute(builder: (context) => const WelcomeView());
          case "Home":
            return MaterialPageRoute(builder: (context) => const MainTabView());
          default:
            return MaterialPageRoute(
                builder: (context) => Scaffold(
                      body: Center(
                        child: Text("No path for ${routeSettings.name}"),
                      ),
                    ));
        }
      },
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
