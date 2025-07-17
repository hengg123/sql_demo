import 'package:flutter/material.dart';
import 'package:sql_lite_demo/screens/add_student_screen/add_stu_screen.dart';
import 'package:sql_lite_demo/screens/homescreen/homescreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "SQ-LITE DEMO",
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode:  ThemeMode.light,
      routes: {
        "/home" : (context) => Homescreen(),
        "/addStudent" : (context) => AddStuScreen(),
      },
    );
  }
}
