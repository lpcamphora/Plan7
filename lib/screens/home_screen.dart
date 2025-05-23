import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remover "debug"
      home: Scaffold(
        appBar: AppBar(
  title: const Text(
    'Cronograma Semanal',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const Text(
                'Semana 21',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 4),
              const Text(
                'segunda-feira, 19 de maio – domingo, 25 de maio de 2025',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Bem-vindo ao Plan7!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Aqui futuramente será adicionada a navegação
            print('Adicionar nova atividade');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
