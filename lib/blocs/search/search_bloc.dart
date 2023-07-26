// import 'dart:html';

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:http/http.dart' as http;

import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  TrafficService trafficService;

  final ApiEdificiosService _apiEdificiosService = ApiEdificiosService();

  SearchBloc({
    required this.trafficService
  }) : super( const SearchState() ) {
    
    on<OnActivateManualMarkerEvent>((event, emit) => emit( state.copyWith( displayManualMarker: true ) ) );
    on<OnDeactivateManualMarkerEvent>((event, emit) => emit( state.copyWith( displayManualMarker: false ) ) );

    on<OnNewPlacesFoundEvent>((event, emit) =>  emit( state.copyWith( places: event.places ) ) );

    on<AddToHistoryEvent>((event, emit) =>  emit( state.copyWith( history: [ event.place, ...state.history ] ) ) );




    on<InitAllEdificiosEvent>((event, emit) => emit(state.copyWith(edificios: event.edificios)));
    on<SetOrigenEvent>( (event, emit) => emit(state.copyWith(origen: event.origen)) );
    on<SetDestinoEvent>((event, emit) => emit(state.copyWith(destino: event.destino, isDestinoSearched: event.isDestinoSearched)),);

    on<SetRoutesEvent>((event, emit) => emit(state.copyWith(routeDriving: event.routeDriving, routeWalking: event.routeWalking)),);


  }



  Future getPlacesByQuery( LatLng proximity, String query ) async {
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);
    add( OnNewPlacesFoundEvent( newPlaces ) );
  }




  Future<void> cargarEdificios() async {
    final losEdificios = await _apiEdificiosService.getEdificios();
    add(InitAllEdificiosEvent(losEdificios));
  }


  Future<void> currentPositionToOrigen() async {
    final position = await Geolocator.getCurrentPosition();
    final posLatLng = LatLng( position.latitude, position.longitude );
    final placeName = await trafficService.getInformationPlace(posLatLng);
    final origen = PointOrigen(name: placeName, position: posLatLng);
    add(SetOrigenEvent(origen));
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
  

  Future<RouteDestination> getCoorsStartToEndGoogleDriving(LatLng start, LatLng end, String endPlace ) async{
    String urlOriginToDestinationDirectionDetails = 'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&language=es&key=${apiKeyGoogleMap}';
    var responseDirectionApi = await receiveRequest(urlOriginToDestinationDirectionDetails);
    final pointsCode = responseDirectionApi['routes'][0]['overview_polyline']['points'];
    final durationString = responseDirectionApi['routes'][0]['legs'][0]['duration']['text'];
    final distanceString = responseDirectionApi['routes'][0]['legs'][0]['distance']['text'];

    List<LatLng> pointsDecode = [];
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList = pPoints.decodePolyline(pointsCode);
    pointsDecode.clear();
    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pointsDecode.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    return RouteDestination(
      points: pointsDecode, 
      duration: durationString, 
      distance: distanceString,
      endPlace: endPlace,
    );
  }


  Future<RouteDestination> getCoorsStartToEndGoogleWalking(LatLng start, LatLng end, String endPlace ) async{

    String urlOriginToDestinationDirectionDetails = 'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&language=es&mode=walking&key=${apiKeyGoogleMap}';
    var responseDirectionApi = await receiveRequest(urlOriginToDestinationDirectionDetails);
    final pointsCode = responseDirectionApi['routes'][0]['overview_polyline']['points'];
    final durationString = responseDirectionApi['routes'][0]['legs'][0]['duration']['text'];
    final distanceString = responseDirectionApi['routes'][0]['legs'][0]['distance']['text'];

    List<LatLng> pointsDecode = [];
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList = pPoints.decodePolyline(pointsCode);
    pointsDecode.clear();
    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pointsDecode.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    final durationString1 = formatDuration(durationString);

    return RouteDestination(
      points: pointsDecode, 
      duration: durationString1, 
      distance: distanceString,
      endPlace: endPlace,
    );
  }

  String formatDuration(String durationText) {
    final parts = durationText.split(' ');

    if (parts.contains('días') && parts.contains('hora')) {
      int days = int.tryParse(parts[parts.indexOf('días') - 1]) ?? 0;
      int hours = int.tryParse(parts[parts.indexOf('hora') - 1]) ?? 0;
      return '${days}d ${hours}h';
    }

    if (parts.contains('días') && parts.contains('horas')) {
      int days = int.tryParse(parts[parts.indexOf('días') - 1]) ?? 0;
      int hours = int.tryParse(parts[parts.indexOf('horas') - 1]) ?? 0;
      return '${days}d ${hours}h';
    }

    if (parts.contains('día') && parts.contains('hora')) {
      int days = int.tryParse(parts[parts.indexOf('día') - 1]) ?? 0;
      int hours = int.tryParse(parts[parts.indexOf('hora') - 1]) ?? 0;
      return '${days}d ${hours}h';
    }

    if (parts.contains('día') && parts.contains('horas')) {
      int days = int.tryParse(parts[parts.indexOf('día') - 1]) ?? 0;
      int hours = int.tryParse(parts[parts.indexOf('horas') - 1]) ?? 0;
      return '${days}d ${hours}h';
    }

    return durationText;
  }




}
