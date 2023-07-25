import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:sig_app/helpers/custom_image_marker.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:sig_app/widgets/widgets_to_marker.dart';


// import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

import '../location/location_bloc.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final ApiEdificiosService _apiEdificiosService = ApiEdificiosService();

  final LocationBloc locationBloc;
  TrafficService trafficService;
  GoogleMapController? _mapController;

  MapBloc({
    required this.locationBloc,
    required this.trafficService
  }) : super(const MapState()) {
    
    on<OnMapInitializedEvent>( _onInitMap );

    on<InitMarkersEvent>((event, emit) => emit( state.copyWith(markers: event.markers) ));

    // on<SetMarkerEvent>( _setMarker );

    on<SetEdificioSearchedEvent>( _setEdificioSearched );

    on<DisplayPolylinesEvent>((event, emit) => emit( state.copyWith( polylines: event.polylines, markers: event.markers ) ));

    on<ChangeIsDrivingEvent>((event, emit) => emit( state.copyWith(isDriving: event.isDriving)));
    
    on<ChangeIsEdificioSearchedEvent>((event, emit) => emit( state.copyWith(isEdificioSearched: event.isEdificioSearched)));
    // on<DeleteSearchedMarkerEvent>( _deleteSearchedMarker );
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

  Future<void> initSetMarkers() async {

    final Map<String, Marker> markers = {};
    final losEdificios = await _apiEdificiosService.getEdificios();

    final startMarker = await getAssetImageMarker();

    if(losEdificios.isNotEmpty){
      for (var edificio in losEdificios) {
        Marker marcador = Marker(
          markerId: MarkerId(edificio.id!),
          position: LatLng(edificio.latitud!, edificio.longitud!),
          icon: startMarker,
          infoWindow: InfoWindow(
            title: edificio.sigla,
            snippet: edificio.descripcion
          ),
          
        );
        markers[edificio.id!] = marcador;
      }
    }
    add(InitMarkersEvent(markers));
  }

  // Future<void> _setMarker( SetMarkerEvent event, Emitter<MapState> emit) async {
  //   final markers = state.markers;
  //   final position = LatLng(event.edificio.latitud!, event.edificio.longitud!);
  //   final id = event.edificio.id!;

  //   if(state.isMarkerSearched){
  //     final markers = state.markers;
  //     markers.remove('search');
  //     emit(state.copyWith(markers: markers, markerSearched: null, isMarkerSearched: false));
  //   }

  //   Marker marcador = Marker(
  //     markerId: MarkerId(id),
  //     position: position,
  //     infoWindow: InfoWindow(
  //       title: event.edificio.sigla,
  //       snippet: event.edificio.descripcion,
  //     ),      
  //   );
  //   markers['search'] = marcador;   

  //   emit(state.copyWith(markers: markers, markerSearched: marcador, isMarkerSearched: true));
  //   moveCameraZom(position, 18.5);    
  //   _mapController?.showMarkerInfoWindow(markers[id]!.markerId);
  // }

  Future<void> _setEdificioSearched( SetEdificioSearchedEvent event, Emitter<MapState> emit) async {

    final edificioLocation = LatLng(event.edificio.latitud!, event.edificio.longitud!);
  
    final RouteDestination routeDriving = await getCoorsStartToEndDriving(event.userLocation, edificioLocation, event.edificio.descripcion!);
    final RouteDestination routeWalking = await getCoorsStartToEndWalking(event.userLocation, edificioLocation, event.edificio.descripcion!);

    emit(state.copyWith(
      edificioSearched: event.edificio,
      isEdificioSearched: true,
      routeDriving: routeDriving,
      routeWalking: routeWalking,
    ));
  }


  Future drawRoutePolyline( RouteDestination destination ) async {
    await cleanMap();
    final myRoute;

    if(state.isDriving){
      myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Color.fromARGB(255, 82, 6, 97),
        width: 8,
        points: destination.pointsGoogle,
        // points: destination.points,
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

    Marker marcadorEnd = Marker( //*marker: ubicacion del edificio END
      markerId: MarkerId('END'),
      position: destination.points.last,
      infoWindow: InfoWindow(
        title: destination.endPlace,
      ), 
    );  

    final curretPolylines = Map<String, Polyline>.from( state.polylines );
    curretPolylines['route'] = myRoute;

    final currentMarkers = Map<String, Marker>.from( state.markers );
    // currentMarkers['START'] = marcadorStart;   
    currentMarkers['END'] = marcadorEnd;


    add( DisplayPolylinesEvent( curretPolylines, currentMarkers ) );
    await Future.delayed( const Duration( milliseconds: 300 ));
    _mapController?.showMarkerInfoWindow(const MarkerId('END'));

    LatLngBounds bounds = calculateLatLngBounds(destination.points);
    moveCameraBounds(bounds);

  }


  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));
    try {
      if (httpResponse.statusCode == 200) {
        String responseData = httpResponse.body;

        var decodeResponseData = jsonDecode(responseData);
        return decodeResponseData;
      } else {
        return 'ERROR AN OCCURRED, FAILED TO RESPONSE.';
      }
    } catch (exp) {
      return 'ERROR AN OCCURRED, FAILED TO RESPONSE.';
    }
  }

  Future<List<LatLng>> getPointsGoogle(LatLng start, LatLng end , bool driving) async{

    String urlOriginToDestinationDirectionDetails;
    (driving)
    ? urlOriginToDestinationDirectionDetails = 'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=${apiKeyGoogleMap}'
    : urlOriginToDestinationDirectionDetails = 'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=walking&key=${apiKeyGoogleMap}';
      // urlOriginToDestinationDirectionDetails = 'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=walking&key=${apiKeyGoogleMap}';
    var responseDirectionApi = await receiveRequest(urlOriginToDestinationDirectionDetails);
    final points = responseDirectionApi['routes'][0]['overview_polyline']['points'];
    List<LatLng> pLineCoordinatesList = [];
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList = pPoints.decodePolyline(points);
    pLineCoordinatesList.clear();
    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    return pLineCoordinatesList;
  }

  Future<RouteDestination> getCoorsStartToEndDriving( LatLng start, LatLng end , String endPlace) async {

    final pointsGoogle = await getPointsGoogle(start, end, true);

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
      pointsGoogle: pointsGoogle,
      duration: durationString, 
      distance: distanceString,
      endPlace: endPlace,
    );
  }


  Future<RouteDestination> getCoorsStartToEndWalking( LatLng start, LatLng end, String endPlace ) async {
    
    final pointsGoogle = await getPointsGoogle(start, end, false);

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
      pointsGoogle: pointsGoogle,
      duration: durationString, 
      distance: distanceString,
      endPlace: endPlace,
    );
  }

  // Future<void> _deleteSearchedMarker( DeleteSearchedMarkerEvent event, Emitter<MapState> emit) async {
  //   if(state.isMarkerSearched){
  //     final markers = state.markers;
  //     markers.remove('search');
  //     emit(state.copyWith(markers: markers, markerSearched: null, isMarkerSearched: false));
  //   }
  // }

  Future cleanMap() async {
    final currentMarkers = Map<String, Marker>.from(state.markers);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentMarkers.clear();
    currentPolylines.clear();
    // add(ChangeIsEdificioSearchedEvent(false));
    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));
  }

  Future cleanBusqueda() async {
    final currentMarkers = Map<String, Marker>.from(state.markers);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentMarkers.clear();
    currentPolylines.clear();
    add(ChangeIsEdificioSearchedEvent(false));
    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));
  }

  // String convertirDistancia(double distancia){
  //   int tripDuration = (destination.duration / 60).floorToDouble().toInt();
  //   return "aa";
  // }

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

