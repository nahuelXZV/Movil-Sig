// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sig_app/blocs/blocs.dart';
// import 'package:sig_app/delegates/delegates.dart';

// class SearchBar extends StatelessWidget {
//   const SearchBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final locationBloc = BlocProvider.of<LocationBloc>(context);
//     final size = MediaQuery.of(context).size;

//     return Container(
//       width: size.width * 0.9,
//       child: Column(
//         children: [
//           Container(
//             height: 50.0,
//             child: Row(
//               children: [ 
//                 Icon(
//                   Icons.location_on,
//                   color: Colors.orange.shade700,
//                   size: 30,
//                 ),
//                 Container(
//                   width: size.width * 0.78,
//                   height: 50,
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   alignment: Alignment.centerLeft,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: Colors.blueGrey.shade400,
//                       width: 1.0,
//                     ),
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       showSearch(context: context, delegate: SearchDestinationDelegate());
//                     },
//                     child: Container(
//                       child: Text(
//                         '¿Dónde quieres ir?',
//                         style: TextStyle(
//                           color: Colors.blueGrey.shade200,
//                           fontSize: 16
//                         )
//                       )
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {


  List<String> itemList = [
    'Manzana',
    'Banana',
    'Naranja',
    'Pera',
    'Sandía',
    'Melón',
    'Postgrado',
    'Postgrado 2',
    'Postgrado 3',
    'Postgrado 4',
    'Postgrado 5',
    'Postgrado 6',
  ];

  List<String> filteredList = [];

  TextEditingController searchController = TextEditingController();
  bool isSearchOpen = false;
  
  @override
  void initState() {
    super.initState();
    filteredList = itemList;
  }

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      child: Column(
        children: [
          Container(
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
                        filteredList = itemList
                        .where((item) =>
                          item.toLowerCase().contains(value.toLowerCase().trim()))
                        .toList();
                        isSearchOpen = true;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '¿Dónde quieres ir?',
                      hintStyle: TextStyle(color: Colors.blueGrey.shade200),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            isSearchOpen = false;
                            searchController.text = '';
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
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
            color: Colors.pink.shade100,
            width: size.width * 0.8,
            child: Text('No hay resultados')
          )
          : Container(
            constraints: const BoxConstraints(
              minHeight: 50.0, // Altura mínima deseada
              maxHeight: 250.0, // Altura máxima deseada
            ),
            // height: 200,
            color: Colors.pink.shade100,
            width: size.width * 0.8,
            child: ListView.builder(
              itemCount: filteredList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredList[index]),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}