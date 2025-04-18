import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../product_list/product_controller.dart';

class ProductLocations extends StatefulWidget {
  final LatLng latLng;
  const ProductLocations({super.key, required this.latLng});

  @override
  State<ProductLocations> createState() => _ProductLocationsState();
}

class _ProductLocationsState extends State<ProductLocations> {
  final ProductController productController = Get.put(ProductController());
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(22.7162593, 75.8663183),
    zoom: 12,
  );

  Set<Polyline> _polyline = {};

  @override
  void initState() {
    super.initState();

    _polyline = {
      Polyline(
        polylineId: const PolylineId('user_to_sample'),
        color: Colors.deepPurple,
        width: 4,
        points: [
          widget.latLng,
          const LatLng(22.7162593, 75.8663183),
        ],
      ),
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      moveToUserLocation(widget.latLng);
    });
  }

  void moveToUserLocation(LatLng position) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 14));
  }

  Set<Marker> generateMarkers() {
    Set<Marker> markers = productController.productList.map((product) {
      return Marker(
        markerId: MarkerId(product.id.toString()),
        position: const LatLng(22.7162593, 75.8663183), // Replace with dynamic data
        infoWindow: InfoWindow(
          title: product.title.toString(),
          snippet: product.description.toString(),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      );
    }).toSet();

    // Add user location marker
    markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: widget.latLng,
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Locations',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 2,
      ),
      body: Obx(() {
        if (productController.productList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GoogleMap(
          initialCameraPosition: initialCameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: generateMarkers(),
          polylines: _polyline,
          onMapCreated: (controller) => _controller.complete(controller),
        );
      }),
    );
  }
}
