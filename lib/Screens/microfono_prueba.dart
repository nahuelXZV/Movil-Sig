
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';


import 'package:speech_to_text/speech_to_text.dart';

class Microfono extends StatefulWidget {
  const Microfono({super.key});

  @override
  State<Microfono> createState() => _MicrofonoState();

}

class _MicrofonoState extends State<Microfono> {

  SpeechToText speech = SpeechToText();
  List<dynamic> places = [];

  @override
  void initState() {
    super.initState();
    requestMicrophonePermission();
  }

  Future<void> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      print('Permiso de micrófono concedido');
      initSpeech();
    } else {
      print('Permiso de micrófono denegado');
    }
  }

  Future<void> initSpeech() async {
    bool isAvailable = await speech.initialize();
    if (isAvailable) {
      print('Reconocimiento de voz disponible');
    } else {
      print('Reconocimiento de voz no disponible');
    }
  }

  void startListening() async {
    final microfonoGranted = await Permission.microphone.isGranted;
    if(microfonoGranted){
      await speech.listen(
        onResult: _onSpeechResult,
        listenFor: Duration(seconds: 12),
        pauseFor: Duration(seconds: 4),
      );
    }else{
      requestMicrophonePermission();
    }
    
  }


  void _onSpeechResult(SpeechRecognitionResult result) {
    String transcription = result.recognizedWords;
    print('Transcripción: $transcription');
  }

  




  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: startListening,
              child: Text('Iniciar reconocimiento de voz'),
            ),
          ],
        ),
      );
  }
}




// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';


// import 'package:speech_to_text/speech_to_text.dart';

// class Microfono extends StatefulWidget {
//   const Microfono({super.key});

//   @override
//   State<Microfono> createState() => _MicrofonoState();

// }

// class _MicrofonoState extends State<Microfono> {

//   SpeechToText speech = SpeechToText();
//   List<dynamic> places = [];

//   @override
//   void initState() {
//     super.initState();
//     requestMicrophonePermission();
//   }

//   Future<void> requestMicrophonePermission() async {
//     PermissionStatus status = await Permission.microphone.request();
//     if (status.isGranted) {
//       print('Permiso de micrófono concedido');
//       initSpeech();
//     } else {
//       print('Permiso de micrófono denegado');
//     }
//   }

//   Future<void> initSpeech() async {
//     bool isAvailable = await speech.initialize(
//       onError: onErrorListener,
//       onStatus: onStatusListener,
//     );
//     if (isAvailable) {
//       print('Reconocimiento de voz disponible');
//     } else {
//       print('Reconocimiento de voz no disponible');
//     }
//   }

//   void onErrorListener(dynamic error) {
//     print('Error: $error');
//   }

//   void onStatusListener(String status) {
//     print('Status: $status');
//   }

//   void startListening() async {
//     final microfonoGranted = await Permission.microphone.isGranted;
//     if(microfonoGranted){
//       await speech.listen(
//         onResult: _onSpeechResult,
//         listenFor: Duration(seconds: 12),
//         pauseFor: Duration(seconds: 4),
//       );
//     }else{
//       requestMicrophonePermission();
//     }
    
//   }

//   void stopListening() {
//     speech.stop();
//   }

//   void _onSpeechResult(SpeechRecognitionResult result) {
//     String transcription = result.recognizedWords;
//     print('Transcripción: $transcription');
//   }

  




//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: startListening,
//               child: Text('Iniciar reconocimiento de voz'),
//             ),
//             ElevatedButton(
//               onPressed: stopListening,
//               child: Text('Detener reconocimiento de voz'),
//             ),
//           ],
//         ),
//       );
//   }
// }