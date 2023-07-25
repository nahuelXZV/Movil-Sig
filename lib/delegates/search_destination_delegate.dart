
import 'package:flutter/material.dart';
import 'package:sig_app/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {

  SearchDestinationDelegate():super(
    searchFieldLabel: 'Buscar...',
   
  );


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon( Icons.arrow_back_ios_outlined ),
      onPressed: () {
        final result = SearchResult( cancel: true );
        close(context, result );
      }, 
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('buildResults');

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListTile(
      leading: const Icon( Icons.location_on_outlined, color: Colors.black ),
      title: const Text('Colocar la ubicación manualmente', style: TextStyle( color: Colors.black )),
      onTap: () {
      
        final result = SearchResult( cancel: false, manual: true );
        close(context, result );
      }
    );

  }




// @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // Aquí puedes construir la vista de resultados dentro de la misma pantalla
//     // utilizando los elementos que desees, como ListView, GridView, etc.
//     return ListView.builder(
//       itemCount: 10,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text('Resultado $index'),
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // Aquí puedes mostrar sugerencias mientras el usuario escribe en la barra de búsqueda.
//     // Puede ser una lista estática o puedes realizar una búsqueda en tiempo real.
//     return ListView.builder(
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text('Sugerencia $index'),
//         );
//       },
//     );
//   }






}