import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';

class LabelMyLocation extends StatefulWidget {
  const LabelMyLocation({super.key});

  @override
  State<LabelMyLocation> createState() => _LabelMyLocationState();
}

class _LabelMyLocationState extends State<LabelMyLocation> {
  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      child: Column(
          children: [
            SizedBox(
              height: 50.0,
              child: Row(
                children: [ 
                  Icon(
                    Icons.location_history,
                    color: Colors.indigo.shade900,
                    size: 30,
                  ),
                  Container(
                    width: size.width * 0.78,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blueGrey.shade400,
                        width: 1.0,
                      ),
                    ),
                    child: TextFormField(
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: locationBloc.state.lastKnowLocation.toString(),
                        border: InputBorder.none
                      ),
                    ),
                  ),
    
                ],
              ),
            ),
          ]
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sig_app/blocs/blocs.dart';

// class LabelMyLocation extends StatelessWidget {
//   const LabelMyLocation({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final locationBloc = BlocProvider.of<LocationBloc>(context);
//     final size = MediaQuery.of(context).size;
//     return Container(
//       width: size.width * 0.8,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: Colors.blueGrey.shade400,
//           width: 1.0,
//         ),
//       ),
//       child: TextFormField(
//               readOnly: true,
//               keyboardType: TextInputType.text,
//               decoration: InputDecoration(
//                 icon:  Icon(
//                   Icons.location_history,
//                   color: Colors.indigo.shade900,
//                   size: 30,
//                 ),
//                 hintText: locationBloc.state.lastKnowLocation.toString(),
//                 border: InputBorder.none
//               ),
//               validator: (val) => val!.isEmpty 
//                 ? 'Nombre inválido' 
//                 : null,
//             ),
//     );
//   }
// }
