import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yetanothertodoapp/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("data");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Color bg = Color(0xff11151c);
  final Color mg = Color(0xff212d40);
  final Color fg = Color(0xff364156);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PaHa',
        appBarTheme: AppBarTheme(
          backgroundColor: mg,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: bg,
      ),
      home: Home(),
    );
  }
}
