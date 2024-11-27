import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeDetails extends StatefulWidget {
  final String scheduleId;

  const HomeDetails({Key? key, required this.scheduleId}) : super(key: key);

  @override
  State<HomeDetails> createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  Map<String, dynamic>? _scheduleData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScheduleData();
  }

  Future<void> _loadScheduleData() async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance.collection('schedules').doc(widget.scheduleId).get();
      if (documentSnapshot.exists) {
        setState(() {
          _scheduleData = documentSnapshot.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Erro ao carregar dados da escala: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scheduleData == null) {
      return const Center(child: Text('Escala não encontrada.'));
    }

    final date = (_scheduleData!['date'] as Timestamp).toDate();
    final formattedDate = DateFormat('dd/MM/yyyy - EEEE', 'pt_BR').format(date);
    final songs = List<String>.from(_scheduleData!['songs']);
    final singers = List<String>.from(_scheduleData!['singers']);
    final members = List<Map<String, dynamic>>.from(_scheduleData!['members']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Detalhes da Escala"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Data: $formattedDate', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Integrantes', style: TextStyle(fontSize: 18)),
            ...members.map((member) {
              return ListTile(
                title: Text('${member['nome']} - ${member['instrumento']}'),
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text('Músicas', style: TextStyle(fontSize: 18)),
            ...songs.asMap().entries.map((entry) {
              final index = entry.key;
              final song = entry.value;
              return ListTile(
                title: Text('$song - ${singers[index]}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}