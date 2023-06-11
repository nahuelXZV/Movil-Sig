import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/blocs/blocs.dart';

class MapView extends StatelessWidget {

  final LatLng initialLocation;

  const MapView({
    super.key,
    required this.initialLocation, 
  });

  @override
  Widget build(BuildContext context) {
    final mapBLoc = BlocProvider.of<MapBloc>(context);
    final CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 15
    );
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        compassEnabled: false,
        mapType: MapType.satellite,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        
        onMapCreated: (controller) => mapBLoc.add(OnMapInitializedEvent(controller)),
        //TODO: Markers
        //TODO: Polilines
        //TODO: cuando se mueve el mapa
      ),
    );
  }
}