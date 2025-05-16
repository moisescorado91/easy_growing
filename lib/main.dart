import 'package:flutter/material.dart';
import 'package:easy_growing/screens/login_screen.dart';
import 'package:easy_growing/screens/page_gasto.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/gastos': (context) => const MyHomePage(title: 'Mis Gastos'),
      },
    );
  }
}