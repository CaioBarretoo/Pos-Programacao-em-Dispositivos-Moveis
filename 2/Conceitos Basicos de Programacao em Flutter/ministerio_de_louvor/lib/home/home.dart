import 'package:flutter/material.dart';
import 'package:ministerio_de_louvor/register/instrument/home.dart';
import 'package:ministerio_de_louvor/register/member/home.dart';

import '../theme/sized_box.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context)
        .extension<SizedBoxBackgroundColors>()!
        .backgroundColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bem Vindo!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '1° Igreja do Evangelho Quadrangular',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildCard(
              context,
              'Cadastro de Instrumentos',
              Icons.music_note,
              backgroundColor,
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              'Cadastro de Membros',
              Icons.people,
              backgroundColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, Color color) {
    return Card(
      color: color,
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (title == 'Cadastro de Instrumentos') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeRegisterInstrument()),
            );
          } else if (title == 'Cadastro de Membros') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeRegisterMember()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
