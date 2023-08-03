
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
// import 'package:sig_app/ui/custom_snackbar.dart';

class BoxInformation extends StatelessWidget {
  const BoxInformation({super.key});

  @override
  Widget build(BuildContext context) {

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final size = MediaQuery.of(context).size;
    return BlocBuilder<MapBloc, MapState>(
      
      builder: (context, mapState) {
        return Positioned(
          bottom: size.height * 0.02,
          left: 10,
          child: Container(
            height: 65,
            width: size.width * 0.55,
            padding: EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(10),
            ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
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
                          ]
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Colors.red,
                          ),
                          onPressed: (){
                            mapBloc.cleanMap();
                            searchBloc.add(SetDestinoEvent(null, false));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        );
      }
    );
  }
}



class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration( milliseconds: 300 ),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon( Icons.arrow_back_ios_new, color: Colors.black ),
          onPressed: () {
            BlocProvider.of<SearchBloc>(context).add(
              OnDeactivateManualMarkerEvent()
            );
          },
        ),
      ),  
    );
  }
}