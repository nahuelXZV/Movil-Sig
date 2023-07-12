

import 'package:flutter/material.dart';

class EndMarkerPainterH extends CustomPainter {

  final String localidad;
  final String descripcion;

  EndMarkerPainterH({
    required this.localidad, 
    required this.descripcion
  });

  
  @override
  void paint(Canvas canvas, Size size) {
    
    final blackPaint = Paint()
                        ..color = Colors.black;
    
    final whitePaint = Paint()
                        ..color = Colors.white;

    const double circleBlackRadius = 20;
    const double circleWhiteRadius = 7;

    // Circulo Negro
    canvas.drawCircle(
      Offset( size.width * 0.5 , size.height - circleBlackRadius ) , 
      circleBlackRadius, 
      blackPaint);

    // Circulo Blanco
    canvas.drawCircle(
      Offset( size.width * 0.5, size.height - circleBlackRadius ) , 
      circleWhiteRadius, 
      whitePaint );

    
    // Dibujar caja blanca
    final path = Path();
    path.moveTo( 10, 20 );
    path.lineTo(size.width - 10, 20 );
    path.lineTo(size.width - 10, 100 );
    path.lineTo( 10, 100 );

    // Sombra
    canvas.drawShadow(path, Colors.black, 10, false );

    // Caja
    canvas.drawPath(path, whitePaint );

    // Caja Negra
    const blackBox = Rect.fromLTWH(10, 20, 70, 80);

    canvas.drawRect(blackBox, blackPaint );


    // Descripción

    final locationText = TextSpan(
      style: const TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300 ),
      text: descripcion
    );

    final locationPainter = TextPainter(
      maxLines: 2,
      ellipsis: '...',
      text: locationText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left
    )..layout(
      minWidth: size.width - 95,
      maxWidth: size.width - 95
    );

    final localidadText = TextSpan(
      style: const TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300 ),
      text: descripcion
    );

    final localidadPainter = TextPainter(
      maxLines: 2,
      ellipsis: '...',
      text: locationText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left
    )..layout(
      minWidth: size.width - 95,
      maxWidth: size.width - 95
    );

    final double offsetY = ( descripcion.length > 25 ) ? 35 : 48;

    locationPainter.paint(canvas, Offset( 90, offsetY ));

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;

}