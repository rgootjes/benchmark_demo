import 'package:flutter/material.dart';
import 'csvtolist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Benchmark Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.grey.shade900,
        // fontFamily: 'Open sans',
        textTheme: TextTheme(
            headline1: const TextStyle(fontSize: 36.0),
            headline2:
                const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
            bodyText1:
                const TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            caption: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
      ),
      home: const AddRecordsPage(),
    );
  }
}
