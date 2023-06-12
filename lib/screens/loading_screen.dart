import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/screens/screen.dart';



class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return state.isAllGranted
          ? MapScreen()
          : GpsAccessScreen();
        },
      )
   );
  }
}
