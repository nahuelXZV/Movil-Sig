import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/delegates/delegates.dart';

class LabelMyLocation extends StatelessWidget {
  const LabelMyLocation({super.key});

  @override
  Widget build(BuildContext context) {
    // final locationBloc = BlocProvider.of<LocationBloc>(context);
    final size = MediaQuery.of(context).size;
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        return Container(
          width: size.width * 0.9,
          height: 50.0,
          child: Row(
            children: [
              Icon(
                Icons.location_history,
                color: Colors.indigo.shade900,
                size: 30,
              ),
              GestureDetector(
                onTap: (){
                  showSearch(context: context, delegate: SearchDestinationDelegate());
                },
                child: Container(
                  width: size.width * 0.78,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blueGrey.shade400,
                      width: 1.0,
                    ),
                  ),
                  child:  state.locationPlace == null 
                  ? CircularProgressIndicator()
                  :Text(
                    '${state.locationPlace}',
                    style: TextStyle(color: Colors.blueGrey.shade200),
                  ),
                ),
              ),
            ],
          ),
        );
  
      },
    );
  }
}
