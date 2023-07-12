
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
// import 'package:sig_app/ui/custom_snackbar.dart';

class BoxInformation extends StatelessWidget {
  const BoxInformation({super.key});

  @override
  Widget build(BuildContext context) {

    // final locationBloc = BlocProvider.of<LocationBloc>(context);
    // final mapBloc = BlocProvider.of<MapBloc>(context);
    final size = MediaQuery.of(context).size;
    return BlocBuilder<MapBloc, MapState>(
      
      builder: (context, mapState) {
        return Positioned(
          bottom: size.height * 0.02,
          left: 10,
          child: Container(
            height: 100,
            width: size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  mapState.isDriving
                  ? "Tiempo: ${mapState.routeDriving!.duration}"
                  : "Tiempo: ${mapState.routeWalking!.duration}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  mapState.isDriving
                  ? "Distancia: ${mapState.routeDriving!.distance}"
                  : "Distancia: ${mapState.routeWalking!.distance}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}