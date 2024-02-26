import 'package:firebase_core/firebase_core.dart';
import 'package:real_time_db/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db/pages/details_page.dart';
import 'package:real_time_db/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        DetailPage.id: (context) =>  DetailPage(),
      },
    );
  }
}