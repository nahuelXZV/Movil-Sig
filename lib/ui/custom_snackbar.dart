import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    Key? key,
    required String message,
    String btnLablel = 'OK',
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onOk,
  }) : super(
    key: key,
    content: Text(message),
    duration: duration,
    action: SnackBarAction(
      label: btnLablel,
      onPressed: () {
        if(onOk != null){
          onOk();
        }
      },
    )
  );

}