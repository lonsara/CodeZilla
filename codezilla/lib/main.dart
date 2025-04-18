import 'package:codezilla/src/product_list/product_list_screen.dart';
import 'package:codezilla/src/product_locations/product_locations.dart';
import 'package:codezilla/src/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CodeZilla',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RoutesClass.getProductList(),
      getPages: RoutesClass().routes,
    );
  }
}
