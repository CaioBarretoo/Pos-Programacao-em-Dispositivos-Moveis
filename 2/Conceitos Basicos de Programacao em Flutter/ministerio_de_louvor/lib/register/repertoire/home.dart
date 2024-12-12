import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ministerio_de_louvor/database/classes/repertoire/database_service.dart';
import 'package:ministerio_de_louvor/retrofit/repertoire.dart';

class HomeRegisterRepertoire extends StatefulWidget {
  const HomeRegisterRepertoire({super.key});

  @override
  HomeRegisterRepertoireState createState() => HomeRegisterRepertoireState();
}

class HomeRegisterRepertoireState extends State<HomeRegisterRepertoire> {
  final _formKey = GlobalKey<FormState>();
  final _musicController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _cifraController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: "Cadastrar Música",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20), // Espaçamento superior
              TextFormField(
                controller: _musicController,
                decoration: const InputDecoration(
                  labelText: 'Música',
                  hintText: 'Digite o nome da música',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da música';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _youtubeController,
                decoration: InputDecoration(
                  labelText: 'Link do YouTube',
                  hintText: 'Cole o link do YouTube aqui',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.content_paste),
                    onPressed: () async {
                      final clipboardData =
                          await Clipboard.getData('text/plain');
                      if (clipboardData != null && clipboardData.text != null) {
                        _youtubeController.text = clipboardData.text!;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cifraController,
                decoration: InputDecoration(
                  labelText: 'Cifra',
                  hintText: 'Cole o link da cifra aqui',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.content_paste),
                    onPressed: () async {
                      final clipboardData =
                          await Clipboard.getData('text/plain');
                      if (clipboardData != null && clipboardData.text != null) {
                        _cifraController.text = clipboardData.text!;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final maxId =
                        await RepertoireDatabaseService().getMaxIdRepertoire();
                    if (maxId == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Erro ao buscar maior id das músicas no Banco.')),
                      );
                      return;
                    }
                    final newId = maxId + 1;
                    final newRepertoire = Repertoire(
                      id: newId,
                      music: _musicController.text.toUpperCase(),
                      youtube: _youtubeController.text,
                      cifra: _cifraController.text,
                    );
                    await RepertoireDatabaseService()
                        .addMusic(newRepertoire, context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
