import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ministerio_de_louvor/retrofit/repertoire.dart';

import '../../database/classes/repertoire/database_service.dart';

class HomeEditRepertoire extends StatefulWidget {
  final Repertoire music;

  const HomeEditRepertoire({Key? key, required this.music}) : super(key: key);

  @override
  _HomeEditRepertoireState createState() => _HomeEditRepertoireState();
}

class _HomeEditRepertoireState extends State<HomeEditRepertoire> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _musicController;
  late TextEditingController _youtubeController;
  late TextEditingController _cifraController;

  @override
  void initState() {
    super.initState();
    _musicController = TextEditingController(text: widget.music.music);
    _youtubeController = TextEditingController(text: widget.music.youtube);
    _cifraController = TextEditingController(text: widget.music.cifra);
  }

  @override
  void dispose() {
    _musicController.dispose();
    _youtubeController.dispose();
    _cifraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: "Editar Música",
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
              const SizedBox(height: 20),
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
              Row(
                // Botões de salvar e excluir
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedMusic = Repertoire(
                          id: widget.music.id,
                          music: _musicController.text,
                          youtube: _youtubeController.text,
                          cifra: _cifraController.text,
                        );
                        // Atualizar música na API
                        RepertoireDatabaseService().updateMusic(
                            widget.music.id, updatedMusic, context);
                        Navigator.pop(context, updatedMusic);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Salvar'),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar Exclusão'),
                          content: const Text(
                              'Tem certeza que deseja excluir esta música?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await RepertoireDatabaseService()
                            .deleteMusic(widget.music.id, context);
                        Navigator.pop(context, null);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      textStyle: const TextStyle(fontSize: 20),
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Excluir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
