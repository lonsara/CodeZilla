import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:codezilla/src/product_list/ProductModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController{
  var isLoading = false.obs;
  var productList=<Products>[].obs;

  @override
  void onInit(){
    super.onInit();
    getProductDataApi();
  }

  Future getProductDataApi() async{
    try{
      isLoading(true);
      var baseUrl='https://dummyjson.com/products';
      final response=await http.get(Uri.parse(baseUrl));
      if(response.statusCode==200){
        List data=jsonDecode(response.body)['products'];
        productList.assignAll(data.map((e) => Products.fromJson(e)).toList());
      }else{
        throw Exception('Error on fetching Product APi');
      }
    }on SocketException{
      throw Exception('No Internet Connection');
    }on TimeoutException{
      throw Exception('Time Out Exception');
    }
    catch(error){
      throw Exception('Error on fetching Product APi');
    }finally{
      isLoading(false);
    }
  }

}