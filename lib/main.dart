import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'Screens/map-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      //para el modo oscuro :)
      light: ThemeData(),
      dark: ThemeData(),
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: 'inicio',
        routes: {
          'inicio': (context) => const MapPage(),
        },
      ),
    );
  }
}
