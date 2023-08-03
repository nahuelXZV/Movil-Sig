import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/delegates/delegates.dart';
import 'package:sig_app/helpers/helpers.dart';
import 'package:sig_app/models/models.dart';

class SearchOrigen extends StatelessWidget {
  const SearchOrigen({super.key});


  Future<void> onSearchResults( BuildContext context, SearchResult result ) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    
    if ( result.manual == true ) {
      searchBloc.add( OnActivateManualMarkerEvent() );
      return;
    }

    if ( result.position != null ) {
      final origen = result.position!;

      if(searchBloc.state.isDestinoSearched){
        showLoadingMessage(context);
        final destino = LatLng(searchBloc.state.destino!.latitud!, searchBloc.state.destino!.longitud!);
        final pointsDriving = await searchBloc.getCoorsStartToEndGoogleDriving(origen, destino, searchBloc.state.destino!.descripcion!);
        final pointsWalking = await searchBloc.getCoorsStartToEndGoogleWalking(origen, destino, searchBloc.state.destino!.descripcion!);
        searchBloc.add(SetRoutesEvent(pointsDriving, pointsWalking)); //aqui carga ya las rutas
        mapBloc.state.isDriving
        ? await mapBloc.drawRoutePolyline(pointsDriving)
        : await mapBloc.drawRoutePolyline(pointsWalking);
        Navigator.pop(context);
      }

      searchBloc.add(SetOrigenEvent(PointOrigen(name: result.description, position: result.position))); //! OJO: carga el origen buscado
   }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, searchState) {
        return Container(
          width: size.width * 0.9,
          height: 50.0,
          child: Row(
            children: [
              Icon(
                Icons.location_history,
                color: Colors.indigo.shade900,
                size: 30,
              ),
              GestureDetector(
                onTap: () async {

                  final result = await showSearch(context: context, delegate: SearchOriginDelegate());
                  if( result == null ) return;

                  // showLoadingMessage(context);
                  await onSearchResults( context, result );
                  // Navigator.pop(context);
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
                  child:  searchState.origen == null 
                  ? CircularProgressIndicator()
                  :Text(
                    '${searchState.origen!.name}',
                    maxLines: 2,
                    style: TextStyle(color: Colors.grey.shade900),
                  ),
                ),
              ),
            ],
          ),
        );
  
      },
    );
  }
}
