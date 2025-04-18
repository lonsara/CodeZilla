import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:codezilla/src/custom_widgets/custom_btn.dart';
import 'package:codezilla/src/product_list/product_controller.dart';
import 'package:codezilla/src/product_locations/product_locations.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductController productController = Get.put(ProductController());

  Future<Position> getUserCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> permissions() async {
    PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    permissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product List',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (productController.productList.isEmpty) {
          return const Center(child: Text('No Products Found'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: productController.productList.length,
            itemBuilder: (context, index) {
              final product = productController.productList[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      product.thumbnail.toString(),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    product.title.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    product.description.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  trailing: CustomBtn(
                    label: const Icon(Icons.directions, size: 24),
                    onTap: () async {
                      final location = await getUserCurrentLocation();
                      Get.to(() => ProductLocations(
                          latLng:
                          LatLng(location.latitude, location.longitude)));
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
