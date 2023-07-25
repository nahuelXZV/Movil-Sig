import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';
import 'package:sig_app/blocs/blocs.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  List<Edificio> edificiosList = []; 
  List<Edificio> filteredList = [];

  TextEditingController searchController = TextEditingController();
  bool isSearchOpen = false;
  bool isButtonX = false;

  final ApiEdificiosService _apiEdificiosService = ApiEdificiosService();

  Future<void> _getEdificio() async {
    final losEdificios = await _apiEdificiosService.getEdificios();
    List<String> descEdif = [];

    for (var element in losEdificios) {
      descEdif.add(element.descripcion!);
    }
    setState((){
      edificiosList = losEdificios;
    });
  }

  
  @override
  void initState() {
    _getEdificio();
    super.initState();
    filteredList = edificiosList;
  }

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBLoc = BlocProvider.of<MapBloc>(context);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
            child: Row(
              children: [ 
                Icon(
                  Icons.location_on,
                  color: Colors.orange.shade700,
                  size: 30,
                ),
                Container(
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
                  child: TextFormField(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        filteredList = edificiosList
                        .where((edificio) =>
                          edificio.descripcion!.toLowerCase().contains(value.toLowerCase().trim()))
                        .toList();
                        isSearchOpen = true;
                        isButtonX = true;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '¿A que lugar de la UAGRM quieres ir?',
                      hintStyle: TextStyle(color: Colors.blueGrey.shade200),
                      border: InputBorder.none,
                      suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: (){
                            setState(() {
                              FocusScope.of(context).unfocus();
                              // mapBLoc.add(DeleteSearchedMarkerEvent());
                              mapBLoc.cleanBusqueda();
                              isSearchOpen = false;
                              searchController.text = '';
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.blueGrey.shade600,
                          ),
                        )
                      : null
                    ),
                  ),
                ),
              ],
            ),
          ),
          if(isSearchOpen)
          filteredList.isEmpty
          ? Container(
            height: 30,
            alignment: Alignment.center,
            color: Color.fromARGB(255, 237, 213, 247),
            width: size.width * 0.8,
            child: const Text('No hay resultados')
          )
          : Container(
            constraints: const BoxConstraints(
              minHeight: 50.0, // Altura mínima deseada
              maxHeight: 250.0, // Altura máxima deseada
            ),
            // height: 200,
            color: Color.fromARGB(255, 237, 224, 243),
            width: size.width * 0.8,
            child: ListView.builder(
              itemCount: filteredList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  // title: Text(filteredList[index].descripcion!),
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(filteredList[index].descripcion!),
                        Text(filteredList[index].localidad!, style: TextStyle(fontSize: 14, color: Colors.black54),)
                    ]),),

                  onTap: () async{
                    final edificioLocation = LatLng(filteredList[index].latitud!, filteredList[index].longitud!);                    FocusScope.of(context).unfocus();
                    // await locationBloc.setPlacePosition();s
                    final userLocation = locationBloc.state.lastKnowLocation!;
                    // mapBLoc.add(SetEdificioSearchedEvent(filteredList[index], userLocation));
                    final points;
                    mapBLoc.state.isDriving
                    ? points = await mapBLoc.getCoorsStartToEndMAPBOXDriving(userLocation, edificioLocation, filteredList[index].descripcion!)
                    : points = await mapBLoc.getCoorsStartToEndMAPBOXWalking(userLocation, edificioLocation, filteredList[index].descripcion!);
                    mapBLoc.drawRoutePolyline(points);
                    setState(() {
                      isSearchOpen = false;
                      searchController.text = filteredList[index].descripcion!;
                      // searchController.text = '';
                    });
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}

//Este es el searchBar con el ListBuilder que funcionaba hasta
// la segunda presentacion