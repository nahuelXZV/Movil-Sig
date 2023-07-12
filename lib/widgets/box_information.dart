
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
// import 'package:sig_app/ui/custom_snackbar.dart';

class BoxInformation extends StatelessWidget {
  const BoxInformation({super.key});

  @override
  Widget build(BuildContext context) {

    // final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, mapState) {
      return Container(
        height: 100,
        width: 300,
        color: Colors.white,
        child: Text("Hola como stiad"),
        );
      }
    );
  }
}