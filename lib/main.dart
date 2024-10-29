import 'package:flutter/material.dart';
import 'package:government_services_app/provider/theme_provider.dart';
import 'package:government_services_app/screens/theme_screen.dart';
import 'package:provider/provider.dart';
import 'package:government_services_app/provider/home_provider.dart';
import 'package:government_services_app/provider/web_provider.dart';
import 'package:government_services_app/screens/splash_screen.dart';
import 'package:government_services_app/screens/home_screen.dart';
import 'package:government_services_app/screens/web_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => WebProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.getThemeMode() == ThemeMode.system
              ? ThemeMode.system
              : themeProvider.getThemeMode(),
          debugShowCheckedModeBanner: false,
          initialRoute: 'SplashScreen',
          routes: {
            '/': (context) => const HomeScreen(),
            'WebScreen': (context) => const WebScreen(),
            'SplashScreen': (context) => const SplashScreen(),
          },
        );
      },
    );
  }
}
