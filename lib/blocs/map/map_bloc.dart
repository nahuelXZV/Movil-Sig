
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/helpers/custom_image_marker.dart';

import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';


part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {


  final LocationBloc locationBloc;
  TrafficService trafficService;
  GoogleMapController? _mapController;
  LatLng? mapCenter;


  MapBloc({
    required this.locationBloc,
    required this.trafficService
  }) : super(const MapState()) {
    
    on<OnMapInitializedEvent>( _onInitMap );

    on<InitMarkersEvent>((event, emit) => emit( state.copyWith(markers: event.markers) ));

    on<DisplayPolylinesEvent>((event, emit) => emit( state.copyWith( polylines: event.polylines, markers: event.markers ) ));

    on<ChangeIsDrivingEvent>((event, emit) => emit( state.copyWith(isDriving: event.isDriving)));
    
    
  }

  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    emit(state.copyWith(isMapInitialized: true));
  }


  void moveCamera( LatLng newLocation ) {
    final cameraUpdate = CameraUpdate.newLatLng( newLocation );
    _mapController?.animateCamera(cameraUpdate);
  }

  void moveCameraBounds( LatLngBounds bounds ) {
    double padding = 55;
    _mapController?.animateCamera(
    CameraUpdate.newLatLngBounds(
        bounds,
        padding,
      ),
    );
  }

  void moveCameraZom( LatLng newLocation, double zoom ) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: newLocation,
          zoom: zoom, // Nivel de zoom deseado
        ),
      ),
    );
  }



  Future drawRoutePolyline( RouteDestination destination ) async {
    await cleanMap();
    final myRoute;

    if(state.isDriving){
      myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Color.fromARGB(255, 82, 6, 97),
        width: 8,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );
      
    }else{
      myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Color.fromARGB(255, 82, 6, 97),
        width: 8,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: [
          PatternItem.gap(5),
          PatternItem.dot
        ]
      );
    }


    final iconOrigen = await getAssetImageMarkerOrigen();
    final iconDestino = await getAssetImageMarkerDestino();


    Marker marcadorStart = Marker( //*marker: ubicacion del punto de origen END
      markerId: MarkerId('START'),
      position: destination.points.first,
      icon: iconOrigen,
    ); 

    Marker marcadorEnd = Marker( //*marker: ubicacion del edificio END
      markerId: MarkerId('END'),
      position: destination.points.last,
      icon: iconDestino,
      infoWindow: InfoWindow(
        title: destination.endPlace,
      ), 
      
    );  

   

    final curretPolylines = Map<String, Polyline>.from( state.polylines );
    curretPolylines['route'] = myRoute;

    final currentMarkers = Map<String, Marker>.from( state.markers ); 
    currentMarkers['START'] = marcadorStart;
    currentMarkers['END'] = marcadorEnd;


    add( DisplayPolylinesEvent( curretPolylines, currentMarkers ) );
    await Future.delayed( const Duration( milliseconds: 300 ));
    _mapController?.showMarkerInfoWindow(const MarkerId('END'));

    LatLngBounds bounds = calculateLatLngBounds(destination.points);
    moveCameraBounds(bounds);

  }




  Future<RouteDestination> getCoorsStartToEndMAPBOXDriving( LatLng start, LatLng end , String endPlace) async {

    final trafficResponse = await trafficService.getCoorsStartToEndDriving(start, end);
    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    // Decodificar
    final points = decodePolyline( geometry, accuracyExponent: 6 );
    final latLngList = points.map( ( coor ) => LatLng(coor[0].toDouble(), coor[1].toDouble()) ).toList();

    final durationString = convertTime(duration);
    final distanceString = convertDistance(distance);
    return RouteDestination(
      points: latLngList, 
      duration: durationString, 
      distance: distanceString,
      endPlace: endPlace,
    );
  }


  Future<RouteDestination> getCoorsStartToEndMAPBOXWalking( LatLng start, LatLng end, String endPlace ) async {

    final trafficResponse = await trafficService.getCoorsStartToEndWalking(start, end);
    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    // Decodificar
    final points = decodePolyline( geometry, accuracyExponent: 6 );
    final latLngList = points.map( ( coor ) => LatLng(coor[0].toDouble(), coor[1].toDouble()) ).toList();

    final durationString = convertTime(duration);
    final distanceString = convertDistance(distance);
    return RouteDestination(
      points: latLngList, 
      duration: durationString, 
      distance: distanceString,
      endPlace: endPlace,
    );
  }


  Future cleanMap() async {
    final currentMarkers = Map<String, Marker>.from(state.markers);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentMarkers.clear();
    currentPolylines.clear();
    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));
  }

  Future cleanBusqueda() async {
    final currentMarkers = Map<String, Marker>.from(state.markers);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentMarkers.clear();
    currentPolylines.clear();
    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));
  }

  String convertDistance(double distance) {
    if (distance >= 1000) {
      double kilometers = distance / 1000;
      return kilometers.toStringAsFixed(2) + " km";
    }
      return distance.toStringAsFixed(0) + " m";
  }

  String convertTime(double seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = (seconds % 60).floor();

    if (minutes >= 60) {
      int hours = (minutes / 60).floor();
      int remainingMinutes = (minutes % 60).floor();
      return "$hours h $remainingMinutes min";
    }
    return "$minutes min";
  }


  LatLngBounds calculateLatLngBounds(List<LatLng> routePoints) {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (LatLng point in routePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLng southwest = LatLng(minLat, minLng);
    LatLng northeast = LatLng(maxLat, maxLng);

    return LatLngBounds(southwest: southwest, northeast: northeast);
  }



}

