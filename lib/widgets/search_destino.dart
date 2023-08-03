
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sig_app/delegates/delegates.dart';
import 'package:sig_app/helpers/helpers.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/blocs/blocs.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  Future<void> onSearchResults( BuildContext context, Edificio edificio ) async {
    
    final mapBLoc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);                  

    final origen = searchBloc.state.origen!.position!;
    final origenString = searchBloc.state.origen!.name!;
    final destino = LatLng(edificio.latitud!, edificio.longitud!);

    final pointsDriving = await searchBloc.getCoorsStartToEndGoogleDriving(origen, destino, edificio.descripcion!, edificio.localidad!, origenString);
    final pointsWalking = await searchBloc.getCoorsStartToEndGoogleWalking(origen, destino, edificio.descripcion!, edificio.localidad!, origenString);
    
    searchBloc.add(SetDestinoEvent(edificio, true)); //! OJO: carga el edificio buscado
    searchBloc.add(SetRoutesEvent(pointsDriving, pointsWalking)); //aqui carga ya las rutas

    mapBLoc.state.isDriving
    ? await mapBLoc.drawRoutePolyline(pointsDriving)
    : await mapBLoc.drawRoutePolyline(pointsWalking);

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      height: 50.0,
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Colors.orange.shade800,
            size: 30,
          ),
          GestureDetector(
            onTap: () async {

              final result = await showSearch(context: context, delegate: SearchDestinationDelegate());
              if( result == null ) return;

              showLoadingMessage(context);
              await onSearchResults( context, result );
              Navigator.pop(context);
            },
            child: Container(
              width: size.width * 0.78,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blueGrey.shade400,
                  width: 1.0,
                ),
              ),
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, searchState) {
                  return (searchState.isDestinoSearched)
                  ? Text(
                    '${searchState.destino!.descripcion}',
                    maxLines: 2,
                    style: TextStyle(color: Colors.grey.shade900),
                  )
                  : Text(
                    '¿A qué lugar de la UAGRM quieres ir?',
                    style: TextStyle(color: Colors.blueGrey.shade400),
                  );
                },
              )
            ),
          ),
        ],
      ),
    );
  }
}
