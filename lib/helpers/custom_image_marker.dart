import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show BitmapDescriptor;

Future<BitmapDescriptor> getAssetImageMarker() async {

  return BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(
      devicePixelRatio: 2.5
    ), 
    'assets/icon.png'
  );

}

Future<BitmapDescriptor> getAssetImageMarkerOrigen() async {

  return BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(
      devicePixelRatio: 2.5
    ), 
    'assets/1.png'
  );

}

Future<BitmapDescriptor> getAssetImageMarkerDestino() async {

  return BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(
      devicePixelRatio: 2.5
    ), 
    'assets/2.png'
  );

}

