import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/helpers/custom_image_marker.dart';
import 'package:sig_app/models/edificio.dart';
import 'package:sig_app/services/api_edificios_service.dart';

import '../location/location_bloc.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final ApiEdificiosService _apiEdificiosService = ApiEdificiosService();

  final LocationBloc locationBloc;
  GoogleMapController? _mapController;

  MapBloc({
    required this.locationBloc,
  }) : super(const MapState()) {
    
    on<OnMapInitializedEvent>( _onInitMap );

    on<InitMarkersEvent>((event, emit) => emit( state.copyWith(markers: event.markers) ));

    on<SetMarkerEvent>( _setMarker );
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



  Future<void> _setMarker( SetMarkerEvent event, Emitter<MapState> emit) async {
    final markers = state.markers;
    final position = LatLng(event.edificio.latitud!, event.edificio.longitud!);
    final id = event.edificio.id!;

    Marker marcador = Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(
        title: event.edificio.sigla,
        snippet: event.edificio.descripcion,
      ),      
    );
    markers['search'] = marcador;   

    emit(state.copyWith(markers: markers, markerSearched: marcador, isMarkerSearched: true));
    moveCameraZom(position, 18.5);    
    _mapController?.showMarkerInfoWindow(markers[id]!.markerId);

  }
  // Future<void> _setMarker( SetMarkerEvent event, Emitter<MapState> emit) async {
  //   final markers = state.markers;
  //   final position = LatLng(event.edificio.latitud!, event.edificio.longitud!);

  //   Marker marcador = Marker(
  //     markerId: const MarkerId('search'),
  //     position: position,
  //     infoWindow: InfoWindow(
  //       title: event.edificio.sigla,
  //       snippet: event.edificio.descripcion,
  //     ),      
  //   );
  //   markers['search'] = marcador;   

  //   emit(state.copyWith(markers: markers, markerSearched: marcador, isMarkerSearched: true));
  //   moveCameraZom(position, 18.5);    
  //   _mapController?.showMarkerInfoWindow(markers['search']!.markerId);

  // }
}
