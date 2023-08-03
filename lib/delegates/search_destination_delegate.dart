
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/helpers/helpers.dart';
import 'package:sig_app/models/models.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchDestinationDelegate extends SearchDelegate<Edificio?> {
  SpeechToText speech = SpeechToText();
  SearchDestinationDelegate():super(
    searchFieldLabel: 'Buscar edificio...',
   
  );


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.mic),
        onPressed: () async {
          query = '';
          await startListening(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon( Icons.arrow_back ),
      onPressed: () {
        close(context, null );
      }, 
    );
  }


  
@override
Widget buildResults(BuildContext context) {
  final edificios = BlocProvider.of<SearchBloc>(context).state.edificios;

  final List<Edificio> edificiosFiltrado = edificios
    .where((edificio) =>
      edificio.descripcion!.toLowerCase().contains(query.toLowerCase().trim()) 
      || edificio.localidad!.toLowerCase().contains(query.toLowerCase().trim())
      || edificio.sigla!.toLowerCase().contains(query.toLowerCase().trim()))
    .toList();


    if (edificiosFiltrado.isEmpty)
    return Center(
      child: Text(
        'No se encontraron resultados',
        style: TextStyle(
          color: Color.fromARGB(255, 81, 64, 94),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      )
    );

    return ListView.builder(
      itemCount: edificiosFiltrado.length,      
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () async {
              close(context, edificiosFiltrado[index] );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: ListTile(
                leading: Icon(
                  Icons.place_outlined, 
                  size: 30,
                  color: Color.fromARGB(255, 81, 64, 94)
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${edificiosFiltrado[index].sigla}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 81, 64, 94),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Descripcion: ${edificiosFiltrado[index].descripcion}',
                      style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Localidad: ${edificiosFiltrado[index].localidad}',
                          style: TextStyle(
                            color: Colors.blueGrey.shade900,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
                // trailing: Icon(Icons.arrow_forward),
              ),
            ),
          ),
        );
      },
    );
  }


  
@override
Widget buildSuggestions(BuildContext context) {
  final edificios = BlocProvider.of<SearchBloc>(context).state.edificios;

  final List<Edificio> edificiosFiltrado = edificios
    .where((edificio) =>
      edificio.descripcion!.toLowerCase().contains(query.toLowerCase().trim()) 
      || edificio.localidad!.toLowerCase().contains(query.toLowerCase().trim())
      || edificio.sigla!.toLowerCase().contains(query.toLowerCase().trim()))
    .toList();

    if (edificiosFiltrado.isEmpty)
    return Center(
      child: Text(
        'No se encontraron resultados',
        style: TextStyle(
          color: Color.fromARGB(255, 81, 64, 94),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      )
    );
    return ListView.builder(
      itemCount: edificiosFiltrado.length,      
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () async {
              close(context, edificiosFiltrado[index] );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: ListTile(
                leading: Icon(
                  Icons.place_outlined, 
                  size: 30,
                  color: Color.fromARGB(255, 81, 64, 94)
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${edificiosFiltrado[index].sigla}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 81, 64, 94),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Descripcion: ${edificiosFiltrado[index].descripcion}',
                      style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Localidad: ${edificiosFiltrado[index].localidad}',
                          style: TextStyle(
                            color: Colors.blueGrey.shade900,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
                // trailing: Icon(Icons.arrow_forward),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      bool isAvailable = await speech.initialize();
      if (isAvailable) {
        print('Reconocimiento de voz disponible');
      } else {
        print('Reconocimiento de voz no disponible');
      }
    }
  }

  Future<void> startListening(BuildContext context) async {
    final microfonoGranted = await Permission.microphone.isGranted;
    if(microfonoGranted){
      await speech.initialize();
      await speech.listen(
        onResult: _onSpeechResult,
        listenFor: Duration(seconds: 15),
        pauseFor: Duration(seconds: 5),
      );
      showResults(context);
    }else{
      await requestMicrophonePermission();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    String transcription = result.recognizedWords;
    query = transcription;    
  }

}