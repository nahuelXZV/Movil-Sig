
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
// import 'package:sig_app/ui/custom_snackbar.dart';

class BoxInformation extends StatelessWidget {
  const BoxInformation({super.key});

  @override
  Widget build(BuildContext context) {

    final searchBloc = BlocProvider.of<SearchBloc>(context);

    final size = MediaQuery.of(context).size;
    return BlocBuilder<MapBloc, MapState>(
      
      builder: (context, mapState) {
        return Positioned(
          bottom: size.height * 0.02,
          left: 10,
          child: Container(
            height: 80,
            width: size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tiempo: ',
                        style: TextStyle(
                          color: Colors.purple.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: mapState.isDriving
                        ? searchBloc.state.routeDriving!.duration
                        : searchBloc.state.routeWalking!.duration,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Distancia: ',
                        style: TextStyle(
                          color: Colors.purple.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: mapState.isDriving
                        ? searchBloc.state.routeDriving!.distance
                        : searchBloc.state.routeWalking!.distance,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}