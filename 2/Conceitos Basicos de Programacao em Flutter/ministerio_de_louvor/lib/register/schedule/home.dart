import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ministerio_de_louvor/database/classes/schedule/database_service.dart';
import 'package:ministerio_de_louvor/database/classes/repertoire/database_service.dart';

import '../../retrofit/repertoire.dart';

class HomeRegisterSchedule extends StatefulWidget {
  const HomeRegisterSchedule({super.key});

  @override
  State<HomeRegisterSchedule> createState() => _HomeRegisterScheduleState();
}

class _HomeRegisterScheduleState extends State<HomeRegisterSchedule> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final _members = <Map<String, String>>[];
  final List<Repertoire> _selectedSongs = [];

  List<Repertoire> _repertoire = [];

  String _searchTerm = '';
  List<Map<String, dynamic>> _membersData = [];

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
    _fetchInstruments();
    _fetchMembers();
    _fetchRepertoire();
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

  Future<void> _fetchInstruments() async {
    try {
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar instrumentos: $e')),
      );
    }
  }

  Future<void> _fetchMembers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('member').get();
      setState(() {
        _membersData = snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar membros: $e')),
      );
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text.rich(
            TextSpan(
              text: "Cadastrar Escala",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Dia da Escala',
                                border: OutlineInputBorder(),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedDate != null
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(_selectedDate!)
                                        : 'Selecione a data',
                                  ),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Integrantes',
                                  style: TextStyle(fontSize: 18)),
                              const SizedBox(height: 16.0),
                              SizedBox(
                                height: 200,
                                // Ajuste a altura conforme necessário
                                child: ListView.builder(
                                  itemCount: _members.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.grey[500],
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: IntrinsicWidth(
                                                child: Wrap(
                                                  children: [
                                                    DropdownButtonFormField<
                                                        String>(
                                                      value: _members[index][
                                                                      'name'] !=
                                                                  null &&
                                                              _membersData.any(
                                                                  (memberData) =>
                                                                      memberData[
                                                                          'name'] ==
                                                                      _members[
                                                                              index]
                                                                          [
                                                                          'name'])
                                                          ? _members[index]
                                                              ['name']
                                                          : null,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              labelText:
                                                                  'Nome'),
                                                      items: _membersData
                                                          .map((memberData) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value:
                                                              memberData['name']
                                                                  as String,
                                                          child: Text(
                                                              memberData['name']
                                                                  as String),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _members[index]
                                                              ['name'] = value!;
                                                          final selectedMember =
                                                              _membersData
                                                                  .firstWhere(
                                                            (memberData) =>
                                                                memberData[
                                                                    'name'] ==
                                                                value,
                                                            orElse: () => {
                                                              'instruments': []
                                                            },
                                                          );
                                                          _members[index][
                                                              'instruments'] = (selectedMember[
                                                                      'instruments']
                                                                  .isNotEmpty
                                                              ? selectedMember[
                                                                      'instruments']
                                                                  [0] as String
                                                              : null)!;
                                                        });
                                                      },
                                                      hint: const Text(
                                                          'Integrante'),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      value: _members[index][
                                                                      'instruments'] !=
                                                                  null &&
                                                              _members[index][
                                                                      'name'] !=
                                                                  null &&
                                                              _membersData.any((memberData) =>
                                                                  memberData['name'] ==
                                                                      _members[index]
                                                                          [
                                                                          'name'] &&
                                                                  (memberData['instruments']
                                                                          as List)
                                                                      .contains(_members[index]['instruments']))
                                                          ? _members[index]['instruments']
                                                          : null,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelStyle:
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                              labelText:
                                                                  'Instrumento'),
                                                      items: (_members[index]['name'] !=
                                                                  null &&
                                                              _membersData.any((memberData) =>
                                                                  memberData['name'] ==
                                                                  _members[index]
                                                                      ['name']))
                                                          ? (_membersData.firstWhere(
                                                                  (memberData) =>
                                                                      memberData['name'] ==
                                                                      _members[index]
                                                                          ['name'])['instruments'] as List<
                                                                  dynamic>)
                                                              .map((instrument) =>
                                                                  DropdownMenuItem<String>(
                                                                    value: instrument
                                                                        as String,
                                                                    child: Text(
                                                                        instrument),
                                                                  ))
                                                              .toList()
                                                          : [],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _members[index][
                                                                  'instruments'] =
                                                              value!;
                                                        });
                                                      },
                                                      hint: const Text(
                                                          'Instrumento'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                setState(() {
                                                  _members.removeAt(index);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_membersData.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Não há membros disponíveis para adicionar!')),
                                    );
                                  } else {
                                    setState(() {
                                      _members.add({
                                        'nome':
                                            _membersData[0]['name'] as String,
                                        // Adiciona o primeiro nome como padrão
                                        'instrumento': '',
                                        // Valor inicial vazio para o instrumento
                                      });
                                    });
                                  }
                                },
                                child: const Text('Adicionar Integrante'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Card(
                        child: ExpansionTile(
                          title: const Text('Músicas'),
                          initiallyExpanded: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
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
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount:
                                    _filterMusics(_repertoire, _searchTerm)
                                        .length,
                                itemBuilder: (context, index) {
                                  final music = _filterMusics(
                                      _repertoire, _searchTerm)[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(music.music),
                                        leading: Checkbox(
                                          value: _selectedSongs.contains(music),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (value == true) {
                                                _selectedSongs.add(music);
                                              } else {
                                                _selectedSongs.remove(music);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (await ScheduleDatabaseService()
                                  .isDateAlreadySaved(_selectedDate!)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Já existe uma escala para esta data. Por favor, altere a data.')),
                                );
                                return;
                              }

                              if (_members.isEmpty ||
                                  _members.any((member) =>
                                      member['name'] == null ||
                                      member['name']!.isEmpty ||
                                      member['instruments'] == null ||
                                      member['instruments']!.isEmpty)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Todos os membros devem ter um instrumento vinculado antes de salvar!')),
                                );
                                return;
                              }

                              final scheduleData = {
                                'date': Timestamp.fromDate(_selectedDate!),
                                'songs': _selectedSongs
                                    .map((music) => music.toJson())
                                    .toList(),
                                'members': _members,
                              };

                              await ScheduleDatabaseService()
                                  .insertSchedule(scheduleData, context);
                            }
                          },
                          child: const Text('Salvar Escala'),
                        ),
                      ),
                    ]))));
  }
}
