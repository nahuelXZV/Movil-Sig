
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/services/api_end_points.dart';

class BtnEdificioLocation extends StatelessWidget {
  const BtnEdificioLocation({super.key});

  @override
  Widget build(BuildContext context) {


    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 23,
        backgroundColor: Colors.blueGrey.shade50,
        child: IconButton(
          icon: Icon(Icons.business, color: Colors.indigo.shade900,),
          onPressed: () {
            mapBloc.moveCamera(locationUagrm);
          },
        ),
      ),
    );
  }
}