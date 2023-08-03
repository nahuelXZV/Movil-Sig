import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/helpers/helpers.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/views/views.dart';
import 'package:sig_app/services/services.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        
        return state.displayManualMarker 
            ? const _ManualMarkerBody()
            : const MenuTopView();
            // : const SizedBox();

      },
    );
  }
}




class _ManualMarkerBody extends StatelessWidget {

  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final trafficService = TrafficService();

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [

           Column(
            children: [
              Container(
                height: size.height*0.249,
                width: size.width,
                color: Color.fromARGB(255, 246, 234, 248),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInUp(
                        duration: const Duration( milliseconds: 300 ),
                        child: MaterialButton(
                          minWidth: size.width * 0.8,
                          child: Text('Cancelar', style: TextStyle( color: Colors.purple.shade800, fontWeight: FontWeight.w500 )),
                          color: Colors.purple.shade200,
                          elevation: 0,
                          height: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Establece el radio de borde como nulo
                            side: BorderSide(color: Colors.blueGrey.shade900, width: 2.0), // Opcional: Agrega un borde al botón
                          ),
                          
                          onPressed: () async {
                            BlocProvider.of<SearchBloc>(context).add(
                                    OnDeactivateManualMarkerEvent()
                                  );
                          },
                        ),
                      ),
                      const Divider(color: Colors.transparent, height:10.0,),
                      FadeInUp(
                        duration: const Duration( milliseconds: 300 ),
                        child: MaterialButton(
                          minWidth: size.width * 0.8,
                          
                          child: const Text('Confimar origen', style: TextStyle( color: Colors.white, fontWeight: FontWeight.w500 )),
                          color: Colors.purple.shade800,
                          
                          elevation: 0,
                          height: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Establece el radio de borde como nulo
                            side: BorderSide(color: Colors.blueGrey.shade800, width: 2.0), // Opcional: Agrega un borde al botón
                          ),
                          
                          onPressed: () async {
                
                            final origen = mapBloc.mapCenter;
                            if ( origen == null ) return;
                
                            final origenString = await trafficService.getInformationPlace(origen);
                
                            if(searchBloc.state.isDestinoSearched){
                              final destino = LatLng(searchBloc.state.destino!.latitud!, searchBloc.state.destino!.longitud!);
                              showLoadingMessage(context);
                              final routeDriving = await searchBloc.getCoorsStartToEndGoogleDriving(origen, destino, searchBloc.state.destino!.descripcion!, searchBloc.state.destino!.localidad!, origenString);
                              final routeWalking = await searchBloc.getCoorsStartToEndGoogleWalking(origen, destino, searchBloc.state.destino!.descripcion!, searchBloc.state.destino!.localidad!, origenString);
                              mapBloc.state.isDriving
                              ? await mapBloc.drawRoutePolyline(routeDriving)
                              : await mapBloc.drawRoutePolyline(routeWalking);
                              searchBloc.add(SetRoutesEvent(routeDriving, routeWalking));
                              Navigator.pop(context);
                            }
                            
                            searchBloc.add(SetOrigenEvent(PointOrigen(name: origenString, position: origen)));
                            searchBloc.add( OnDeactivateManualMarkerEvent());
                            
                            
                          },
                        ),
                      ),
                      
                      
                    ],
                  ),
                )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: size.height*0.74,
                  width: size.width,
                  child:  Center(
                    child: Transform.translate(
                      offset: const Offset(0, -20),
                      child: BounceInDown(
                        from: 100,
                        child: const Icon( Icons.location_on, size: 50 )
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),  
        ],
      ),
    );
  }
}






// class _ManualMarkerBody extends StatelessWidget {

//   const _ManualMarkerBody({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     final size = MediaQuery.of(context).size;
//     final searchBloc = BlocProvider.of<SearchBloc>(context);
//     final mapBloc = BlocProvider.of<MapBloc>(context);

//     final trafficService = TrafficService();

//     return SizedBox(
//       width: size.width,
//       height: size.height,
//       child: Stack(
//         children: [
          
//           const Positioned(
//             top: 70,
//             left: 20,
//             child: _BtnBack()
//           ),


//           Center(
//             child: Transform.translate(
//               offset: const Offset(0, 72 ),
//               child: BounceInDown(
//                 from: 100,
//                 child: const Icon( Icons.location_on, size: 60 )
//               ),
//             ),
//           ),

//           // Boton de confirmar
//           Positioned(
//             bottom: 70,
//             left: 40,
//             child: FadeInUp(
//               duration: const Duration( milliseconds: 300 ),
//               child: MaterialButton(
//                 minWidth: size.width -120,
//                 child: const Text('Confimar origen', style: TextStyle( color: Colors.white, fontWeight: FontWeight.w300 )),
//                 color: Colors.black,
//                 elevation: 0,
//                 height: 50,
//                 shape: const StadiumBorder(),
//                 onPressed: () async {

//                   final origen = mapBloc.mapCenter;
//                   if ( origen == null ) return;

//                   final origenString = await trafficService.getInformationPlace(origen);

//                   if(searchBloc.state.isDestinoSearched){
//                     final destino = LatLng(searchBloc.state.destino!.latitud!, searchBloc.state.destino!.longitud!);
//                     showLoadingMessage(context);
//                     final routeDriving = await searchBloc.getCoorsStartToEndGoogleDriving(origen, destino, searchBloc.state.destino!.descripcion!);
//                     final routeWalking = await searchBloc.getCoorsStartToEndGoogleWalking(origen, destino, searchBloc.state.destino!.descripcion!);
//                     mapBloc.state.isDriving
//                     ? await mapBloc.drawRoutePolyline(routeDriving)
//                     : await mapBloc.drawRoutePolyline(routeWalking);
//                     searchBloc.add(SetRoutesEvent(routeDriving, routeWalking));
//                     Navigator.pop(context);
//                   }
                  
//                   searchBloc.add(SetOrigenEvent(PointOrigen(name: origenString, position: origen)));
//                   searchBloc.add( OnDeactivateManualMarkerEvent());
                  
                  
//                 },
//               ),
//             )
//           ),

//         ],
//       ),
//     );
//   }
// }



// class _BtnBack extends StatelessWidget {
//   const _BtnBack({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FadeInLeft(
//       duration: const Duration( milliseconds: 300 ),
//       child: CircleAvatar(
//         maxRadius: 30,
//         backgroundColor: Colors.white,
//         child: IconButton(
//           icon: const Icon( Icons.arrow_back_ios_new, color: Colors.black ),
//           onPressed: () {
//             BlocProvider.of<SearchBloc>(context).add(
//               OnDeactivateManualMarkerEvent()
//             );
//           },
//         ),
//       ),  
//     );
//   }
// }