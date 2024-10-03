import 'package:flutter/material.dart';
import 'screens/vistoria_screen.dart'; // Certifique-se de que este import está correto
import 'screens/resumo_vistorias_screen.dart'; // Importar a página de resumo

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vistoria de Rede de Telefonia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87), // Alterado aqui
          bodySmall: TextStyle(color: Colors.black54), // Alterado aqui para bodySmall
        ),
      ),
      home: VistoriaScreen(), // Página inicial
      routes: {
        '/resumo': (context) => ResumoVistoriasScreen(vistorias: const []), // Rota para a página de resumo
      },
    );
  }
}
