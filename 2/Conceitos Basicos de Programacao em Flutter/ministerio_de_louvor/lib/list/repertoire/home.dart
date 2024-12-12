import 'package:flutter/material.dart';
import 'package:ministerio_de_louvor/edit/repertoire/home.dart';
import 'package:ministerio_de_louvor/retrofit/repertoire.dart';
import 'package:ministerio_de_louvor/register/repertoire/home.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../database/classes/repertoire/database_service.dart';
import '../../plataform_channel/volume_checker.dart';
import '../../youtube_player/youtube_player.dart';

class HomeListRepertoire extends StatefulWidget {
  const HomeListRepertoire({super.key});

  @override
  State<HomeListRepertoire> createState() {
    return _HomeListRepertoireState();
  }
}

class _HomeListRepertoireState extends State<HomeListRepertoire> {
  List<Repertoire> _repertoire = [];
  String _searchTerm = '';

  List<Repertoire> _filterMusics(List<Repertoire> musics, String searchTerm) {
    if (searchTerm.isEmpty) {
      return musics;
    } else {
      return musics
          .where((music) =>
              music.music.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }
  }

  @override
  initState() {
    super.initState();
    _fetchRepertoire();
    VolumeChecker.checkVolume(context);
  }

  Future<void> _fetchRepertoire() async {
    try {
      _repertoire = await RepertoireDatabaseService().loadRepertoire();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar repertório: $e')),
      );
    }
  }

  void _navigateToMusicForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeRegisterRepertoire()),
    ).then((_) async {
      _repertoire = await RepertoireDatabaseService().loadRepertoire();
    });
  }

  void _showYoutubePopup(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 200,
            child: YoutubePlayerScreen(videoUrl: videoUrl),
          ),
        );
      },
    );
  }

  void _showEditMusicForm(BuildContext context, Repertoire music) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeEditRepertoire(music: music),
      ),
    ).then((updatedMusic) {
      if (updatedMusic == null) {
        _fetchRepertoire();
      } else if (updatedMusic != null) {
        setState(() {
          _repertoire[_repertoire.indexOf(music)] = updatedMusic;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text.rich(
          TextSpan(
            text: "Repertório",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  _searchTerm = text;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Pesquisar música...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filterMusics(_repertoire, _searchTerm).length,
        itemBuilder: (context, index) {
          final music = _filterMusics(_repertoire, _searchTerm)[index];
          return GestureDetector(
            onTap: () {
              _showEditMusicForm(context, music);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music.music,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () =>
                              _showYoutubePopup(context, music.youtube),
                          icon: const Icon(Icons.play_circle_fill),
                          label: Text('YouTube'),
                          style: OutlinedButton.styleFrom(
                            iconColor: Colors.red,
                            foregroundColor: Colors.red,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => launchUrl(Uri.parse(music.cifra)),
                          icon: const Icon(Icons.music_note),
                          label: Text('Cifra'),
                          style: OutlinedButton.styleFrom(
                            iconColor: Colors.orange,
                            foregroundColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
