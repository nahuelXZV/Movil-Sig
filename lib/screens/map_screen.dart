import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/services/services.dart';
import 'package:sig_app/views/views.dart';
import 'package:sig_app/widgets/widgets.dart';



class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  late MapBloc mapBloc;
  late SearchBloc searchBloc;


  @override
  void initState(){
    super.initState();
    locationBloc =  BlocProvider.of<LocationBloc>(context);
    mapBloc =  BlocProvider.of<MapBloc>(context);
    searchBloc =  BlocProvider.of<SearchBloc>(context);

    locationBloc.startFollorwingUser(); // si no hago esto no se carga el mapa

    searchBloc.currentPositionToOrigen();
  }


  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if( locationState.lastKnowLocation == null ) return const Center(child: Text('espere por favor'));
          
          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: size.height*0.249,
                          width: size.width,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: size.height*0.74,
                            width: size.width,
                            child: MapView(
                              // initialLocation: locationUagrm, 
                              initialLocation: locationState.lastKnowLocation!, 
                              markers: mapState.markers.values.toSet(),
                              polylines: mapState.polylines.values.toSet(),
                            ),
                          ),
                        ),
                      ]
                    ),  

                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, searchState){
                        return (searchState.destino != null && searchState.routeDriving != null && searchState.routeWalking != null)
                        ? BoxInformation()
                        : SizedBox();
                      },
                    ),
                    const MenuTopView(), 
                    const ManualMarker(),
                  ],
                ),
              );

            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          // BtnEdificioLocation(),
          BtnCurrentLocation(),
          // BoxInformation(),
        ]
      ),
    );
  }
}
