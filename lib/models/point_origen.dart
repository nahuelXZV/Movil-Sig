import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class PointOrigen {

  final LatLng? position;
  final String? name;


  PointOrigen({
    this.position, 
    this.name, //aqui para el nombre del lugar en texto
  });

 
  @override
  String toString() {
    return '{ posicion: $position, name: $name }';
  }
}