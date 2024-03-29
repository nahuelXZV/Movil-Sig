import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/screens/screen.dart';
import 'package:sig_app/services/services.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc(),),
        BlocProvider(create: (context) => LocationBloc(),),
        BlocProvider(create: (context) => MapBloc(trafficService: TrafficService(), locationBloc: BlocProvider.of<LocationBloc>(context) ),),
        BlocProvider(create: ((context) => SearchBloc(trafficService: TrafficService()))),
      ],
      child: const SigApp(),
    ),
  );

} 
class SigApp extends StatelessWidget {
  const SigApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Sig App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home: LoadingScreen(),
      // home: MyScreen(),
    
    );
  }
}