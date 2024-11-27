import 'package:flutter/material.dart';
import 'package:ministerio_de_louvor/retrofit/music.dart';
import 'package:ministerio_de_louvor/retrofit/interface/repertoire_api.dart';
import 'package:ministerio_de_louvor/retrofit/dio_client.dart';
import 'package:ministerio_de_louvor/register/music/home.dart';

class HomeListRepertoire extends StatefulWidget {
  const HomeListRepertoire({Key? key}) : super(key: key);

  @override
  _HomeListRepertoireState createState() => _HomeListRepertoireState();
}

class _HomeListRepertoireState extends State<HomeListRepertoire> {
  late final dioClient = DioClient();
  late final repertoireApi = RepertoireApi(dioClient.dio);
  List<Music> _repertorio = [];

  @override
  void initState() {
    super.initState();
    _carregarRepertorio();
  }

  Future<void> _carregarRepertorio() async {
    try {
      final repertorio = await repertoireApi.getRepertoire();
      setState(() {
        _repertorio = repertorio;
      });
    } catch (e) {
      print('Erro ao carregar o repertório: $e');
    }
  }

  void _navigateToMusicForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeRegisterMusic()),
    ).then((_) {
      _carregarRepertorio();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repertório'),
      ),
      body: ListView.builder(
        itemCount: _repertorio.length,
        itemBuilder: (context, index) {
          final musica = _repertorio[index];
          return ListTile(
            title: Text(musica.music),
            subtitle: Text(musica.youtube),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToMusicForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}