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


  @override
  void initState() {
    super.initState();
    locationBloc =  BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollorwingUser();
    // print('startfollowinguser');

    mapBloc =  BlocProvider.of<MapBloc>(context);
    mapBloc.initSetMarkers();
    // print('*****************initSetMarkers ********************');
    locationBloc.setPlacePosition();
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
                              initialLocation: locationUagrm, 
                              // initialLocation: locationState.lastKnowLocation!, 
                              markers: mapState.markers.values.toSet(),
                            ),
                          ),
                        ),
                      ]
                    ),  
                    const MenuTopView(), 
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
        children: const [
          BtnEdificioLocation(),
          BtnCurrentLocation(),
        ]
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:sig_app/blocs/blocs.dart';
// import 'package:sig_app/views/views.dart';
// import 'package:sig_app/widgets/widgets.dart';


// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late LocationBloc locationBloc;

//   @override
//   void initState() {
//     super.initState();
//     locationBloc =  BlocProvider.of<LocationBloc>(context);
//     locationBloc.startFollorwingUser();
//     print('startfollowinguser');
//   }


//   @override
//   void dispose() {

//     locationBloc.stopFollowingUser();
//     super.dispose();
//     print('disposw');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<LocationBloc, LocationState>(
//         builder: (context, state) {
//           if( state.lastKnowLocation == null ) return const Center(child: Text('espere por favor'));
//           return SingleChildScrollView(
//             child: Stack(
//               children: [
//                 MapView(initialLocation: state.lastKnowLocation!,), //esta mas al fondo
//                 //TODO: botones y mas 
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: const [
//           BtnCurrentLocation(),
//         ]
//       ),
//     );
//   }
// }