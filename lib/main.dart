import 'package:flutter/material.dart';
import 'package:flutterlone/screen/product/home_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomeProductScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
