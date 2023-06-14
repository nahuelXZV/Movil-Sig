
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/ui/custom_snackbar.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 23,
        backgroundColor: Colors.blueGrey.shade50,
        child: IconButton(
          icon: Icon(Icons.my_location_outlined, color: Colors.indigo.shade900,),
          onPressed: () {
            final userLocation = locationBloc.state.lastKnowLocation;

            if (userLocation ==  null ) {
              final snack = CustomSnackBar(message: 'no hay ubicacion',);
              ScaffoldMessenger.of(context).showSnackBar(snack);
              return;
            }
            mapBloc.moveCameraZom(userLocation, 15);
            // mapBloc.moveCamera(userLocation);
          },
        ),
      ),
    );
  }
}