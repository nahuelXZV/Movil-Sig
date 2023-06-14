import 'package:flutter/material.dart';
import 'package:sig_app/widgets/widgets.dart';

class MenuTopView extends StatelessWidget {
  const MenuTopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          const Divider(color: Colors.transparent, height:10.0,),
          SizedBox(
            height: 50.0,
            child: Row(
              children: const [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0), // Agrega padding a la izquierda
                    child: BtnCar(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 50.0), // Agrega padding a la izquierda
                    child: BtnWalk(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.transparent, height: 10.0,),
          const Align(alignment: Alignment.center, child: LabelMyLocation(),),
          const Divider(color: Colors.transparent, height: 10.0,),
          const Align(alignment: Alignment.center, child: SearchBar(),),
          const Divider(color: Colors.transparent, height: 10.0,),
        ]
      ),
    );
  }
}