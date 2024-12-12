import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ministerio_de_louvor/database/classes/member/database_service.dart';

class HomeRegisterMember extends StatefulWidget {
  const HomeRegisterMember({super.key});

  @override
  State<HomeRegisterMember> createState() => _HomeRegisterMemberState();
}

class _HomeRegisterMemberState extends State<HomeRegisterMember> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<String> _instruments = [];
  final List<String> _selectedInstruments = [];

  final Stream<QuerySnapshot> _membersStream =
      FirebaseFirestore.instance.collection('member').snapshots();

  @override
  void initState() {
    super.initState();
    _fetchInstruments();
  }

  Future<void> _fetchInstruments() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('instrument').get();
      setState(() {
        _instruments
            .addAll(snapshot.docs.map((doc) => doc.get('name') as String));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar instrumentos: $e')),
      );
    }
  }

  Future<void> _showEditDialog(BuildContext context, String documentId,
      String memberName, List<String> memberInstruments) async {
    final editNameController = TextEditingController(text: memberName);
    List<String> editSelectedInstruments = List.from(memberInstruments);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Editar Membro'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: editNameController,
                      decoration:
                          const InputDecoration(hintText: 'Nome do Membro'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Instrumentos', style: TextStyle(fontSize: 18)),
                    ...editSelectedInstruments.map((instrument) => ListTile(
                          title: Text(instrument),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setStateDialog(() {
                                editSelectedInstruments.remove(instrument);
                              });
                            },
                          ),
                        )),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (context, setStateBottomSheet) {
                              return SizedBox(
                                height: 400,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _instruments.length,
                                        itemBuilder: (context, index) {
                                          final instrument =
                                              _instruments[index];
                                          return CheckboxListTile(
                                            value: editSelectedInstruments
                                                .contains(instrument),
                                            title: Text(instrument),
                                            onChanged: (value) {
                                              setStateBottomSheet(() {
                                                if (value!) {
                                                  if (!editSelectedInstruments
                                                      .contains(instrument)) {
                                                    editSelectedInstruments
                                                        .add(instrument);
                                                  }
                                                } else {
                                                  editSelectedInstruments
                                                      .remove(instrument);
                                                }
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setStateDialog(() {});
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Selecionar'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: const Text('Adicionar Instrumentos'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Salvar'),
                  onPressed: () async {
                    final memberData = {
                      'name': editNameController.text,
                      'instruments': editSelectedInstruments,
                      // ... outros campos ...
                    };
                    await MemberDatabaseService()
                        .updateMember(documentId, memberData, context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text.rich(
          TextSpan(
            text: "Cadastrar Membros",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do membro';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text('Instrumentos',
                          style: TextStyle(fontSize: 18)),
                      ..._selectedInstruments.map((instrument) => ListTile(
                            title: Text(instrument),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _selectedInstruments.remove(instrument);
                                });
                              },
                            ),
                          )),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setStateBottomSheet) {
                                return SizedBox(
                                  height: 400,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: _instruments.length,
                                          itemBuilder: (context, index) {
                                            final instrument =
                                                _instruments[index];
                                            return CheckboxListTile(
                                              value: _selectedInstruments
                                                  .contains(instrument),
                                              title: Text(instrument),
                                              onChanged: (value) {
                                                setStateBottomSheet(() {
                                                  if (value!) {
                                                    if (!_selectedInstruments
                                                        .contains(instrument)) {
                                                      _selectedInstruments
                                                          .add(instrument);
                                                    }
                                                  } else {
                                                    _selectedInstruments
                                                        .remove(instrument);
                                                  }
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Selecionar'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: const Text('Adicionar Instrumentos'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final memberData = {
                              'name': _nameController.text,
                              'instruments': _selectedInstruments,
                            };
                            try {
                              await MemberDatabaseService()
                                  .insertMember(memberData, context);
                              _nameController.clear();
                              _selectedInstruments.clear();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Erro ao cadastrar membro.')),
                              );
                            }
                          }
                        },
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lista de Membros',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _membersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Algo deu errado');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final document = snapshot.data!.docs[index];
                    final memberName = document['name'];
                    final memberInstruments =
                        List<String>.from(document['instruments']);

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(memberName),
                        subtitle: Text(memberInstruments.join(', ')),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(context, document.id,
                                    memberName, memberInstruments);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirmar exclusão'),
                                      content: const Text(
                                          'Tem certeza que deseja excluir este membro?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Excluir'),
                                          onPressed: () async {
                                            await MemberDatabaseService()
                                                .deleteMember(
                                                    document.id, context);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
