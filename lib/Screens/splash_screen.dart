import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/screens/loading_screen.dart';
import 'dart:async';

import 'package:sig_app/screens/microfono_prueba.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.cargarEdificios();

    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (context) => Microfono()),
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logoUAGRM.png',
                  fit: BoxFit.cover,
                  width: size.width * 0.5,
                ),
                SizedBox(height: 20),
                Text(
                  'Explora y desplázate sin problemas en la UAGRM',
                  style: TextStyle(
                    color: Color.fromARGB(255, 249, 243, 250),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Descubre cada rincón con nuestra app',
                  style: TextStyle(
                    color: Color.fromARGB(255, 183, 146, 248),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
