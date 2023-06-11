
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/ui/custom_snackbar.dart';

class BtnWalk extends StatelessWidget {
  const BtnWalk({super.key});

  @override
  Widget build(BuildContext context) {

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return IconButton(
        splashColor: Colors.amber,
        splashRadius: 25,
        icon: Icon(
          Icons.directions_walk,
          color: Colors.blueGrey.shade700,
          size: 32,
        ),
        onPressed: () {
          // final userLocation = locationBloc.state.lastKnowLocation;

          // if (userLocation ==  null ) {
          //   final snack = CustomSnackBar(message: 'no hay ubicacion',);
          //   ScaffoldMessenger.of(context).showSnackBar(snack);
          //   return;
          // }
          // mapBloc.moveCamera(userLocation);
        },
    );
  }
}