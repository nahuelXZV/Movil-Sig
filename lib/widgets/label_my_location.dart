import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';

class LabelMyLocation extends StatelessWidget {
  const LabelMyLocation({super.key});

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
              readOnly: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                icon:  Icon(
                  Icons.location_history,
                  color: Colors.indigo.shade900,
                  size: 30,
                ),
                hintText: locationBloc.state.lastKnowLocation.toString(),
                border: InputBorder.none
              ),
              validator: (val) => val!.isEmpty 
                ? 'Nombre inválido' 
                : null,
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
//       decoration: BoxDecoration(
//         color: Colors.red,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextFormField(
//               readOnly: true,
//               keyboardType: TextInputType.text,
//               // controller: nameController,
//               // decoration: kInputDecoration2("Nombre", Icons.person, kPrimaryColor),
//               decoration: InputDecoration(
//                 icon: Icon(
//                   Icons.abc_outlined,
//                   color: Colors.amber,
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