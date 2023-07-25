


import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:sig_app/models/places_models.dart';

class RouteDestination {

  final List<LatLng> points;
  final String duration;
  final String distance;
  final String endPlace;

  RouteDestination({
    required this.points, 
    required this.duration, 
    required this.distance,
    required this.endPlace,
  });

}