import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:sig_app/helpers/custom_image_marker.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';


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

    print(state.isDriving);
    if(state.isDriving){
      myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Color.fromARGB(255, 82, 6, 97),
        width: 9,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );
    }else{
      myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Color.fromARGB(255, 82, 6, 97),
        width: 9,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: [
          PatternItem.gap(5),
          PatternItem.dot
        ]
      );
    }

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    int tripDuration = (destination.duration / 60).floorToDouble().toInt();

    final startMarker = await getAssetImageMarker();

    Marker marcadorStart = Marker( //*marker: ubicacion del user START
      markerId: MarkerId('START'),
      position: destination.points.first, 
      icon: startMarker,    
    );

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
    currentMarkers['START'] = marcadorStart;   
    currentMarkers['END'] = marcadorEnd;


    add( DisplayPolylinesEvent( curretPolylines, currentMarkers ) );
    await Future.delayed( const Duration( milliseconds: 300 ));
    _mapController?.showMarkerInfoWindow(const MarkerId('END'));
  }


  Future<RouteDestination> getCoorsStartToEndDriving( LatLng start, LatLng end , String endPlace) async {

    final trafficResponse = await trafficService.getCoorsStartToEndDriving(start, end);

    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    // Decodificar
    final points = decodePolyline( geometry, accuracyExponent: 6 );

    final latLngList = points.map( ( coor ) => LatLng(coor[0].toDouble(), coor[1].toDouble()) ).toList();

    return RouteDestination(
      points: latLngList, 
      duration: duration, 
      distance: distance,
      endPlace: endPlace,
    );
  }


  Future<RouteDestination> getCoorsStartToEndWalking( LatLng start, LatLng end, String endPlace ) async {
    final trafficResponse = await trafficService.getCoorsStartToEndWalking(start, end);

    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    // Decodificar
    final points = decodePolyline( geometry, accuracyExponent: 6 );

    final latLngList = points.map( ( coor ) => LatLng(coor[0].toDouble(), coor[1].toDouble()) ).toList();

    return RouteDestination(
      points: latLngList, 
      duration: duration, 
      distance: distance,
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
}

