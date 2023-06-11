import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.85,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blueGrey.shade400,
          width: 1.0,
        ),
      ),
      child: TextFormField(
              readOnly: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                icon:  Icon(
                  Icons.location_on,
                  color: Colors.orange.shade700,
                  size: 30,
                ),
                hintText: '¿Dónde quieres ir?',
                border: InputBorder.none
              ),
              validator: (val) => val!.isEmpty 
                ? 'Nombre inválido' 
                : null,
            ),
    );
  }
}