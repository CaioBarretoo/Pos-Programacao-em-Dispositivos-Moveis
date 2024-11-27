import 'package:flutter/material.dart';
import 'package:ministerio_de_louvor/retrofit/music.dart';
import 'package:ministerio_de_louvor/retrofit/interface/repertoire_api.dart';
import 'package:ministerio_de_louvor/retrofit/dio_client.dart';

class HomeRegisterMusic extends StatefulWidget {
  const HomeRegisterMusic({Key? key}) : super(key: key);

  @override
  _HomeRegisterMusicState createState() => _HomeRegisterMusicState();
}

class _HomeRegisterMusicState extends State<HomeRegisterMusic> {
  late final dioClient = DioClient();
  late final repertoireApi = RepertoireApi(dioClient.dio);
  final _formKey = GlobalKey<FormState>();
  final _musicController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _cifraController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Música'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _musicController,
                decoration: const InputDecoration(labelText: 'Música'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da música';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _youtubeController,
                decoration: const InputDecoration(labelText: 'Link do YouTube'),
              ),
              TextFormField(
                controller: _cifraController,
                decoration: const InputDecoration(labelText: 'Cifra'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final novaMusica = Music(
                      id: 0,
                      music: _musicController.text,
                      youtube: _youtubeController.text,
                      cifra: _cifraController.text,
                    );
                    try {
                      await repertoireApi.addMusic(novaMusica);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Música adicionada com sucesso!')),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context); // Fecha a tela após adicionar
                    } catch (e) {
                      print('Erro ao adicionar música: $e');
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao adicionar música.')),
                      );
                    }
                  }
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}