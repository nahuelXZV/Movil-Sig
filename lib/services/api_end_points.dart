import 'package:google_maps_flutter/google_maps_flutter.dart';

const baseURL = "https://back-sig.herokuapp.com/api/"; 


const allEdificiosURL = baseURL + ('edificios');



// ----UBICACION UAGRM
const locationUagrm = LatLng(-17.77579921947698, -63.19528029707799);

//---errors
const serverError = 'Error del servidor';
const unautorized = 'No autorizado';
const somethingWentWrong = '¡Algo salió mal, intenta de nuevo!';

//---headers
const Map<String, String> headers = {"Content-Type": "application/json"};
