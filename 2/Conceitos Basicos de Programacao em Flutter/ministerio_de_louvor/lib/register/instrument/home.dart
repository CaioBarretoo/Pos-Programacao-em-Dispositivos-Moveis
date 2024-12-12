import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ministerio_de_louvor/database/classes/instrument/database_service.dart';

class HomeRegisterInstrument extends StatefulWidget {
  const HomeRegisterInstrument({super.key});

  @override
  HomeRegisterInstrumentState createState() => HomeRegisterInstrumentState();
}

class HomeRegisterInstrumentState extends State<HomeRegisterInstrument> {
  final _formKey = GlobalKey<FormState>();
  final _instrumentNameController = TextEditingController();

  final Stream<QuerySnapshot> _instrumentsStream =
      FirebaseFirestore.instance.collection('instrument').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: "Cadastro de Instrumentos",
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
                        controller: _instrumentNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Instrumento',
                          hintText: 'Ex: Violão, Guitarra, Piano',
                          prefixIcon: Icon(Icons.music_note),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do instrumento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String instrumentName =
                                _instrumentNameController.text;
                            await InstrumentDatabaseService()
                                .saveInstrument(instrumentName, context);
                            _instrumentNameController.clear();
                          }
                        },
                        child: const Text('Cadastrar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Lista de Instrumentos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _instrumentsStream,
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
                    final instrumentName = document['name'];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(instrumentName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(
                                    context, document.id, instrumentName);
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
                                          'Tem certeza que deseja excluir este instrumento?'),
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
                                            await InstrumentDatabaseService()
                                                .deleteInstrument(
                                                    document.id, context);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
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

  Future<void> _showEditDialog(
      BuildContext context, String documentId, String instrumentName) async {
    final editController = TextEditingController(text: instrumentName);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Instrumento'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Nome do Instrumento'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () async {
                await InstrumentDatabaseService()
                    .updateInstrument(documentId, editController.text, context);
              },
            ),
          ],
        );
      },
    );
  }
}
