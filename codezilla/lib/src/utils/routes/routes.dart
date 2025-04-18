import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../product_list/product_list_screen.dart';
import '../../product_locations/product_locations.dart';

class RoutesClass{
  static String productListScreen='/';
  static String productLocations='/ProductLocations';


  static String getProductList()=>productListScreen;
  static String getProductLocations()=>productLocations;

  List<GetPage> routes=[
    GetPage(name: productListScreen, page: ()=>ProductListScreen()),
    GetPage(name: productLocations, page: (){
      final LatLng latLng=Get.arguments;
      return ProductLocations(latLng: latLng);
    }, transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}