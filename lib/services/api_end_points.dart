import 'package:google_maps_flutter/google_maps_flutter.dart';

const baseURL = "https://back-sig.herokuapp.com/api/"; 


const allEdificiosURL = baseURL + ('edificios');



// ----UBICACION UAGRM
const locationUagrm = LatLng(-17.776099073902245, -63.19435971183966);

//---errors
const serverError = 'Error del servidor';
const unautorized = 'No autorizado';
const somethingWentWrong = '¡Algo salió mal, intenta de nuevo!';

//---headers
const Map<String, String> headers = {"Content-Type": "application/json"};





const mapboxAccessToken = 'pk.eyJ1IjoiaGVpZHlvbG1vcyIsImEiOiJjbGlzemJ1M2UxYWp3M2Vud2R0YnJpend2In0.YWTndP8jdVSQtUyf0mgqeQ';

String apiKeyGoogleMap = 'AIzaSyAB7tN-kAt_hebjeKGs-8InHyQ4v5DWOdo';