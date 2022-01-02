import 'package:flutter/material.dart';
import 'package:flutter_packages/ui/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Packages',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.notoSans().fontFamily,
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
    );
  }
}
