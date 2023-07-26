
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
// import 'package:sig_app/ui/custom_snackbar.dart';

class BtnCar extends StatelessWidget {
  const BtnCar({super.key});

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, mapState) {
      return IconButton(
          splashColor: Colors.amber,
          splashRadius: 25,
          icon: mapState.isDriving //&& mapState.isEdificioSearched
          ? Icon(
            Icons.directions_car_filled_outlined,
            color: Colors.purple.shade800,
            size: 32,
          )
          : Icon(
            Icons.directions_car_filled_outlined,
            color: Colors.blueGrey.shade700,
            size: 32,
          ),
          onPressed: () {
            if(searchBloc.state.isDestinoSearched){
              mapBloc.add(ChangeIsDrivingEvent(true));
              mapBloc.drawRoutePolyline(searchBloc.state.routeDriving!);
            }else{
              mapBloc.add(ChangeIsDrivingEvent(true));
            }
          },
      );
      }
    );
  }
}