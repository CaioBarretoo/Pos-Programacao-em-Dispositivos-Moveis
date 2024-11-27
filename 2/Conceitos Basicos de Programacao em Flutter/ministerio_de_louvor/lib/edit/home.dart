import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ministerio_de_louvor/database/database_service.dart';

class HomeEdit extends StatefulWidget {
  final String scheduleId;

  const HomeEdit({Key? key, required this.scheduleId}) : super(key: key);

  @override
  State<HomeEdit> createState() => _HomeEditState();
}

class _HomeEditState extends State<HomeEdit> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final _songs = <String>[];
  final _singers = <String>[];
  final _members = <Map<String, dynamic>>[];
  final List<String> _instruments = [
    'Ministro',
    'BackVoice',
    'Violão',
    'Baixo',
    'Guitarra',
    'Teclado',
  ];
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
        final scheduleData = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _selectedDate = (scheduleData['date'] as Timestamp).toDate();
          _songs.addAll(List<String>.from(scheduleData['songs']));
          _singers.addAll(List<String>.from(scheduleData['singers']));
          _members.addAll(List<Map<String, dynamic>>.from(scheduleData['members']));
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Editar Escala"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Dia da Escala',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                                  : 'Selecione a data',
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Integrantes', style: TextStyle(fontSize: 18)),
                    ..._members.asMap().entries.map((entry) {
                      final index = entry.key;
                      final member = entry.value;
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: member['nome'] as String?, // Cast to String?
                                decoration: const InputDecoration(labelText: 'Nome'),
                                onChanged: (value) {
                                  setState(() {
                                    _members[index]['nome'] = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: member['instrumento'] as String?, // Cast to String?
                                decoration: const InputDecoration(labelText: 'Instrumento'),
                                items: _instruments.map((instrument) => DropdownMenuItem(
                                  value: instrument,
                                  child: Text(instrument),
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _members[index]['instrumento'] = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _members.removeAt(index);
                            });
                          },
                        ),
                      );
                    }).toList(),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _members.add({'nome': '', 'instrumento': _instruments[0]});
                        });
                      },
                      child: const Text('Adicionar Integrante'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Músicas', style: TextStyle(fontSize: 18)),
                    ..._songs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final song = entry.value;
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: song,
                                decoration: const InputDecoration(labelText: 'Nome da Música'),
                                onChanged: (value) {
                                  setState(() {
                                    _songs[index] = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                initialValue: _singers[index],
                                decoration: const InputDecoration(labelText: 'Cantor'),
                                onChanged: (value) {
                                  setState(() {
                                    _singers[index] = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _songs.removeAt(index);
                              _singers.removeAt(index);
                            });
                          },
                        ),
                      );
                    }).toList(),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _songs.add('');
                          _singers.add('');
                        });
                      },
                      child: const Text('Adicionar Música'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final scheduleData = {
                        'date': Timestamp.fromDate(_selectedDate!),
                        'songs': _songs,
                        'singers': _singers,
                        'members': _members,
                      };
                      DatabaseService().updateSchedule(widget.scheduleId, scheduleData, context);
                    },
                    child: const Text('Atualizar'),
                  ),
                  ElevatedButton(
                    onPressed: () => DatabaseService().deleteSchedule(widget.scheduleId, context),
                    child: const Text('Deletar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}