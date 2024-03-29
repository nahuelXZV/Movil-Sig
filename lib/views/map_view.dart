import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/blocs/blocs.dart';

class MapView extends StatelessWidget {

  final LatLng initialLocation;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  const MapView({
    super.key,
    required this.initialLocation, 
    required this.markers,
    required this.polylines
  });

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 15.7
    );
    final size = MediaQuery.of(context).size;
    return SizedBox(
          width: size.width,
          height: size.height,
          child: GoogleMap(
            initialCameraPosition: initialCameraPosition,
            compassEnabled: false,
            // mapType: MapType.satellite,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            markers: markers,
            polylines: polylines,
            onMapCreated: (controller) => mapBloc.add(OnMapInitializedEvent(controller)),
            onCameraMove: (position) => mapBloc.mapCenter = position.target,
            //TODO: Polilines
            //TODO: cuando se mueve el mapa
          ),
    );
  }
}