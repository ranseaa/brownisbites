import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Browniesbites/view/on_boarding/startup_view.dart'; // Sesuaikan dengan path
import 'package:Browniesbites/view/login/welcome_view.dart'; // Sesuaikan dengan path
import 'package:Browniesbites/view/main_tabview/main_tabview.dart'; // Sesuaikan dengan path

class MyApp extends StatelessWidget {
  final Widget defaultHome;
  
  const MyApp({Key? key, required this.defaultHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brownies Bites',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: defaultHome, // defaultHome ini akan ditentukan dari test
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
