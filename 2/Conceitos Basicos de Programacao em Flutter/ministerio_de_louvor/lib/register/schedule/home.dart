import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ministerio_de_louvor/database/database_service.dart';

class HomeRegisterSchedule extends StatefulWidget {
  const HomeRegisterSchedule({super.key});

  @override
  State<HomeRegisterSchedule> createState() => _HomeRegisterScheduleState();
}

class _HomeRegisterScheduleState extends State<HomeRegisterSchedule> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final _songs = <String>[];
  final _singers = <String>[];
  final _members = <Map<String, String>>[];

  final List<String> _instruments = [
    'Ministro',
    'BackVoice',
    'Violão',
    'Baixo',
    'Guitarra',
    'Teclado',
  ];

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Registrar Escala"),
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
                                initialValue: member['nome'],
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
                                value: member['instrumento'],
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (await DatabaseService().isDateAlreadySaved(_selectedDate!)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Já existe uma escala para esta data. Por favor, altere a data.')),
                        );
                        return;
                      }
                      final scheduleData = {
                        'date': Timestamp.fromDate(_selectedDate!),
                        'songs': _songs,
                        'singers': _singers,
                        'members': _members,
                      };

                      await DatabaseService().insertSchedule(scheduleData);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dados salvos no Firebase!')),
                      );
                      _formKey.currentState?.reset();
                      setState(() {
                        _selectedDate = null;
                        _singers.clear();
                        _songs.clear();
                        _members.clear();
                      });
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}