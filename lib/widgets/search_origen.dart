import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/delegates/delegates.dart';
import 'package:sig_app/models/models.dart';

class SearchOrigen extends StatelessWidget {
  const SearchOrigen({super.key});


   void onSearchResults( BuildContext context, SearchResult result ) async {
    
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    if ( result.manual == true ) {
      searchBloc.add( OnActivateManualMarkerEvent() );
      return;
    }

    if ( result.position != null ) {
      final destination = await searchBloc.getCoorsStartToEnd( locationBloc.state.lastKnowLocation!, result.position! );
      await mapBloc.drawRoutePolyline(destination);
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
                  showSearch(context: context, delegate: SearchOriginDelegate());

                  final result = await showSearch(context: context, delegate: SearchOriginDelegate());
                  if( result == null ) return;

                  onSearchResults( context, result );
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
                    style: TextStyle(color: Colors.blueGrey.shade200),
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
