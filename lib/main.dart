import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Screens/map-page.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/screens/screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc(),)
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
      home: LoadingScreen(),
    
    );
  }
}