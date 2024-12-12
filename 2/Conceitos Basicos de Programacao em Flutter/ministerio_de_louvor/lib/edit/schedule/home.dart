import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ministerio_de_louvor/database/classes/schedule/database_service.dart';

import '../../../retrofit/dio_client.dart';
import '../../../retrofit/interface/repertoire_api.dart';
import '../../../retrofit/repertoire.dart';

class HomeEditSchedule extends StatefulWidget {
  final String scheduleId;

  const HomeEditSchedule({super.key, required this.scheduleId});

  @override
  State<HomeEditSchedule> createState() => _HomeEditScheduleState();
}

class _HomeEditScheduleState extends State<HomeEditSchedule> {
  late final dioClient = DioClient();
  late final repertoireApi = RepertoireApi(dioClient.dio);

  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  List<Map<String, String>> _members = [];
  List<Repertoire> _selectedSongs = [];

  List<Repertoire> _repertorio = [];

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
  void initState() {
    super.initState();
    _fetchInstruments();
    _fetchMembers();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadRepertoire();
    await _loadScheduleData();
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

  Future<void> _loadRepertoire() async {
    try {
      final repertoire = await repertoireApi.getRepertoire();
      setState(() {
        _repertorio = repertoire;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar o repertório: $e')),
      );
    }
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
          _selectedDate = (scheduleData['date'] as Timestamp).toDate();
          _members = (scheduleData['members'] as List<dynamic>)
              .map((memberData) =>
                  (memberData as Map<String, dynamic>).cast<String, String>())
              .toList();

          _selectedSongs = _repertorio.where((music) {
            return (scheduleData['songs'] as List).any((songData) {
              return songData['id'].toString() == music.id.toString();
            });
          }).toList();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text.rich(
          TextSpan(
            text: "Editar Escala",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Excluir Escala'),
                  content: const Text(
                      'Tem certeza que deseja excluir esta escala? Esta ação não pode ser desfeita.'),
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
                await ScheduleDatabaseService()
                    .deleteSchedule(widget.scheduleId, context);
              }
            },
          ),
        ],
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      const Text('Integrantes', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 200,
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
                                            DropdownButtonFormField<String>(
                                              value: _members[index]['name'] !=
                                                          null &&
                                                      _membersData.any(
                                                          (memberData) =>
                                                              memberData[
                                                                  'name'] ==
                                                              _members[index]
                                                                  ['name'])
                                                  ? _members[index]['name']
                                                  : null,
                                              decoration: const InputDecoration(
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  labelText: 'Nome'),
                                              items: _membersData
                                                  .map((memberData) {
                                                return DropdownMenuItem<String>(
                                                  value: memberData['name']
                                                      as String,
                                                  child: Text(memberData['name']
                                                      as String),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _members[index]['name'] =
                                                      value!;
                                                  final selectedMember =
                                                      _membersData.firstWhere(
                                                    (memberData) =>
                                                        memberData['name'] ==
                                                        value,
                                                    orElse: () =>
                                                        {'instruments': []},
                                                  );
                                                  _members[index]
                                                          ['instruments'] =
                                                      (selectedMember[
                                                                  'instruments']
                                                              .isNotEmpty
                                                          ? selectedMember[
                                                                  'instruments']
                                                              [0] as String
                                                          : null)!;
                                                });
                                              },
                                              hint: const Text('Integrante'),
                                            ),
                                            const SizedBox(width: 10),
                                            DropdownButtonFormField<String>(
                                              value: _members[index]
                                                              ['instruments'] !=
                                                          null &&
                                                      _members[index]['name'] !=
                                                          null &&
                                                      _membersData.any((memberData) =>
                                                          memberData['name'] ==
                                                              _members[index]
                                                                  ['name'] &&
                                                          (memberData['instruments']
                                                                  as List)
                                                              .contains(_members[
                                                                      index][
                                                                  'instruments']))
                                                  ? _members[index]['instruments']
                                                  : null,
                                              decoration: const InputDecoration(
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  labelText: 'Instrumento'),
                                              items: (_members[index]['name'] !=
                                                          null &&
                                                      _membersData.any(
                                                          (memberData) =>
                                                              memberData['name'] ==
                                                              _members[index]
                                                                  ['name']))
                                                  ? (_membersData.firstWhere(
                                                              (memberData) =>
                                                                  memberData['name'] ==
                                                                  _members[index]
                                                                      ['name'])['instruments']
                                                          as List<dynamic>)
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
                                                  _members[index]
                                                      ['instruments'] = value!;
                                                });
                                              },
                                              hint: const Text('Instrumento'),
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
                                'name': _membersData[0]['name'] as String,
                                'instruments': '',
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
                            _filterMusics(_repertorio, _searchTerm).length,
                        itemBuilder: (context, index) {
                          final music =
                              _filterMusics(_repertorio, _searchTerm)[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(music.music),
                                leading: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Checkbox(
                                      value: _selectedSongs.any(
                                          (selectedMusic) =>
                                              selectedMusic.id == music.id),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value!) {
                                            _selectedSongs.add(music);
                                          } else {
                                            _selectedSongs.removeWhere(
                                                (selectedMusic) =>
                                                    selectedMusic.id ==
                                                    music.id);
                                          }
                                        });
                                      },
                                    );
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
                      final scheduleData = {
                        'date': Timestamp.fromDate(_selectedDate!),
                        'songs': _selectedSongs
                            .map((music) => music.toJson())
                            .toList(),
                        'members': _members,
                      };

                      await ScheduleDatabaseService().updateSchedule(
                          widget.scheduleId, scheduleData, context);
                    }
                  },
                  child: const Text('Salvar Escala'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
