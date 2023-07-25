

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

    // const double circleBlackRadius = 30;
    // const double circleWhiteRadius = 10;

    // // Circulo Negro
    // canvas.drawCircle(
    //   Offset( size.width * 0.5 , size.height - circleBlackRadius ) , 
    //   circleBlackRadius, 
    //   blackPaint);

    // // Circulo Blanco
    // canvas.drawCircle(
    //   Offset( size.width * 0.5, size.height - circleBlackRadius ) , 
    //   circleWhiteRadius, 
    //   whitePaint );





final markerPaint = Paint()..color = Colors.red;
final markerShadowPaint = Paint()..color = Colors.black.withOpacity(0.3);

const double markerSize = 40;
const double markerShadowSize = 60;
const double markerShadowOffset = 0;

// Dibujar sombra del marcador
canvas.drawOval(
  Rect.fromCenter(
    center: Offset(size.width * 0.5, size.height - markerShadowSize * 0.5 + markerShadowOffset),
    width: markerShadowSize,
    height: markerShadowSize,
  ),
  markerShadowPaint,
);

// Dibujar cuerpo del marcador
canvas.drawOval(
  Rect.fromCenter(
    center: Offset(size.width * 0.5, size.height - markerSize * 0.5),
    width: markerSize,
    height: markerSize,
  ),
  markerPaint,
);

// Dibujar punta del marcador
Path markerPath = Path();
markerPath.moveTo(size.width * 0.5, size.height - markerSize * 0.5);
markerPath.lineTo(size.width * 0.5 + markerSize * 0.2, size.height - markerSize * 0.5 - markerSize * 0.4);
markerPath.lineTo(size.width * 0.5 - markerSize * 0.2, size.height - markerSize * 0.5 - markerSize * 0.4);
markerPath.close();

canvas.drawPath(markerPath, markerPaint);







    
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
    // const blackBox = Rect.fromLTWH(10, 20, 70, 80);

    // canvas.drawRect(blackBox, blackPaint );

    // Descripción
    final descripcionText = TextSpan(
      style: const TextStyle( color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700 ),
      text: descripcion
    );

    final descripcionPainter = TextPainter(
      maxLines: 2,
      ellipsis: '...',
      text: descripcionText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left
    )..layout(
      minWidth: size.width - 93,
      maxWidth: size.width - 10
    );
    final double offsetY = ( descripcion.length > 25 ) ? 20 : 33;
    descripcionPainter.paint(canvas, Offset( 20, offsetY ));




    // Descripción
    final localidadText = TextSpan(
      style: const TextStyle( color: Colors.black, fontSize: 25, fontWeight: FontWeight.w300 ),
      text: localidad
    );

    final localidadPainter = TextPainter(
      maxLines: 1,
      ellipsis: '...',
      text: localidadText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left
    )..layout(
      minWidth: size.width - 95,
      maxWidth: size.width - 95
    );
    final double offsetY2 = ( localidad.length > 25 ) ? 55 : 68;
    localidadPainter.paint(canvas, Offset( 90, offsetY2 ));

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;

}