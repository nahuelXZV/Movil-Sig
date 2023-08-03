import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage( BuildContext context ) {

  // Android
  if ( Platform.isAndroid ) {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: ( context ) => AlertDialog(
        title: const Text('Espere por favor'),
        content: Container(
          width: 100,
          height: 120,
          margin: const EdgeInsets.only( top: 10),
          child: Column(
            children:  [
              Image.asset(
                'assets/logo.gif',
                height: 70,
              ),
              Text('Calculando ruta'),
              SizedBox( height: 15 ),
            ],
          ),
        ),
      )
    );
    return;
  }

  showCupertinoDialog(
    context: context, 
    builder: ( context ) => const CupertinoAlertDialog(
      title: Text('Espere por favor'),
      content: CupertinoActivityIndicator(),
    )
  );


}


