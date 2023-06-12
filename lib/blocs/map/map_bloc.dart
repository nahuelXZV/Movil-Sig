import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/helpers/custom_image_marker.dart';
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
  }

  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    emit(state.copyWith(isMapInitialized: true));
  }


  void moveCamera( LatLng newLocation ) {
    final cameraUpdate = CameraUpdate.newLatLng( newLocation );
    _mapController?.animateCamera(cameraUpdate);
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
            snippet: edificio.descripcion),
          
        );
        markers[edificio.id!] = marcador;
      }
    }
    add(InitMarkersEvent(markers));
  }
}
