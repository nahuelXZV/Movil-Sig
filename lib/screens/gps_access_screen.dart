import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sig_app/blocs/blocs.dart';


class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            return (!state.isGpsEnable)
            ? const _EnableGpsMessage()
            : const _AccessButton();
          },
        )
        //_AccessButton(),
     ),
   );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/logo.gif',
            height: 150,
          ),
        ),
        SizedBox(height: 10,),
        Text(
          'Debe habilitar el GPS',
          style: TextStyle(
            color: Color.fromARGB(255, 120, 22, 150),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),  
        ),
        SizedBox(height: 15),
        MaterialButton(
          onPressed: (){
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
          color: Colors.black,
          shape: const StadiumBorder(),
          splashColor: Colors.transparent,
          child: const Text('solicitar acceso', style: TextStyle(color: Colors.white),),
        )
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/logo.gif',
            height: 150,
          ),
        ),
        SizedBox(height: 10,),
        Text(
          'Debe habilitar el GPS',
          style: TextStyle(
            color: Color.fromARGB(255, 120, 22, 150),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),  
        ),
        
      ],
    );
  }
}