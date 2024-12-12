import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../retrofit/repertoire.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../plataform_channel/volume_checker.dart';
import '../../theme/decorated_box.dart';
import '../../youtube_player/youtube_player.dart';

class HomeDetailsSchedule extends StatefulWidget {
  final String scheduleId;

  const HomeDetailsSchedule({super.key, required this.scheduleId});

  @override
  State<HomeDetailsSchedule> createState() => _HomeDetailsScheduleState();
}

class _HomeDetailsScheduleState extends State<HomeDetailsSchedule> {
  Map<String, dynamic>? _scheduleData;
  bool _isLoading = true;
  List<Repertoire> _selectedSongs = [];

  @override
  void initState() {
    super.initState();
    _loadScheduleData();
    VolumeChecker.checkVolume(context);
  }

  Future<void> _loadScheduleData() async {
    try {
      final scheduleSnapshot = await FirebaseFirestore.instance
          .collection('schedule')
          .doc(widget.scheduleId)
          .get();

      if (scheduleSnapshot.exists) {
        final scheduleData = scheduleSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _scheduleData = scheduleData;
          _selectedSongs = (scheduleData['songs'] as List)
              .map((songData) => Repertoire.fromJson(songData))
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Escala não encontrada para o ID: ${widget.scheduleId}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados da escala: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scheduleData == null) {
      return const Center(child: Text('Escala não encontrada.'));
    }
    final borderColor =
        Theme.of(context).extension<DecoratedBoxBorderColors>()!.borderColor;
    final date = (_scheduleData!['date'] as Timestamp).toDate();
    final formattedDate = DateFormat('dd/MM/yyyy - EEEE', 'pt_BR').format(date);
    final members = List<Map<String, dynamic>>.from(_scheduleData!['members']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text.rich(
          TextSpan(
            text: "Detalhes da Escala",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Data
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('Data: $formattedDate',
                    style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),

            // Integrantes
            ExpansionTile(
              leading: const Icon(Icons.people),
              title: const Text('Integrantes', style: TextStyle(fontSize: 18)),
              initiallyExpanded: true,
              children: members.map((member) {
                return ListTile(
                  title: Text('${member['name']} - ${member['instruments']}'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Músicas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: _selectedSongs.map((music) {
                    return Card(
                      color: Colors.grey[300],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          music.music,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: borderColor, width: 2.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.play_circle_fill,
                                    color: Colors.red),
                                onPressed: () =>
                                    _showYoutubePopup(context, music.youtube),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: borderColor, width: 2.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.music_note,
                                    color: Colors.orange),
                                onPressed: () =>
                                    launchUrl(Uri.parse(music.cifra)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


