import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/helpers/helpers.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        
        return state.displayManualMarker 
            ? const _ManualMarkerBody()
            : const SizedBox();

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
          
          const Positioned(
            top: 70,
            left: 20,
            child: _BtnBack()
          ),


          Center(
            child: Transform.translate(
              offset: const Offset(0, 72 ),
              child: BounceInDown(
                from: 100,
                child: const Icon( Icons.location_on, size: 60 )
              ),
            ),
          ),

          // Boton de confirmar
          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              duration: const Duration( milliseconds: 300 ),
              child: MaterialButton(
                minWidth: size.width -120,
                child: const Text('Confimar origen', style: TextStyle( color: Colors.white, fontWeight: FontWeight.w300 )),
                color: Colors.black,
                elevation: 0,
                height: 50,
                shape: const StadiumBorder(),
                onPressed: () async {

                  final origen = mapBloc.mapCenter;
                  if ( origen == null ) return;

                  final origenString = await trafficService.getInformationPlace(origen);

                  if(searchBloc.state.destino != null){
                    final destino = LatLng(searchBloc.state.destino!.latitud!, searchBloc.state.destino!.longitud!);
                    showLoadingMessage(context);
                    final routeDriving = await searchBloc.getCoorsStartToEndGoogleDriving(origen, destino, searchBloc.state.destino!.descripcion!);
                    final routeWalking = await searchBloc.getCoorsStartToEndGoogleWalking(origen, destino, searchBloc.state.destino!.descripcion!);
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
            )
          ),

        ],
      ),
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