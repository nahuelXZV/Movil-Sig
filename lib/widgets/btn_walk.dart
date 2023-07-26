
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
// import 'package:sig_app/ui/custom_snackbar.dart';

class BtnWalk extends StatelessWidget {
  const BtnWalk({super.key});

  @override
  Widget build(BuildContext context) {

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, mapState) {
      return IconButton(
          splashColor: Colors.amber,
          splashRadius: 25,
          icon: !mapState.isDriving //&& mapState.isEdificioSearched
          ? Icon(
            Icons.directions_walk,
            color: Colors.purple.shade800,
            size: 32,
          )
          : Icon(
            Icons.directions_walk,
            color: Colors.blueGrey.shade700,
            size: 32,
          ),
          onPressed: () {
            if(searchBloc.state.isDestinoSearched){
              mapBloc.add(ChangeIsDrivingEvent(false));
              mapBloc.drawRoutePolyline(searchBloc.state.routeWalking!);
            }else{
              mapBloc.add(ChangeIsDrivingEvent(false));
            }
          },
        );
      },
    );
  }
}