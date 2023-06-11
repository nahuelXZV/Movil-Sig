// // ignore_for_file: file_names

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => MapPageState();
// }

// class MapPageState extends State<MapPage> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  List<String> itemList = [
    'Manzana',
    'Banana',
    'Naranja',
    'Pera',
    'Sandía',
    'Melón',
     'Postgrado',
    'Postgrado 2'
  ];

  List<String> filteredList = [];

  TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    filteredList = itemList;
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(-17.0000000, -63.0900),
      zoom: 15
    );
    return Scaffold(
      body: Center(
        child: Container(
    // padding: EdgeInsets.all(16.0),
    // width: size.width * 0.8,
    // height: size.width * 0.8 ,
    alignment: Alignment.center,
    color: Colors.amber,
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    filteredList = itemList
                        .where((item) =>
                            item.toLowerCase().contains(value.toLowerCase().trim()))
                        .toList();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Buscar',
                ),
              ),

              Container(
                height: 200,
                color: Colors.pink.shade200,
                width: size.width * 0.8,
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredList[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

