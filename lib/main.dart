<<<<<<< HEAD
=======
// App Easy Growing: Control y registro de gastos personales
>>>>>>> 5e87ebdcfdf8e88cc907a5f2ab11e670ae8dff4e
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
<<<<<<< HEAD
      title: 'Control de Gastos',
      theme: 
      ThemeData(
=======
      title: 'Easy Growing - Control de Gastos',
      theme: ThemeData(
>>>>>>> 5e87ebdcfdf8e88cc907a5f2ab11e670ae8dff4e
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
