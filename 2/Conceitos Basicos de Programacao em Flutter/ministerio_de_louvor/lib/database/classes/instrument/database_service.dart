import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InstrumentDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveInstrument(
      String instrumentName, BuildContext context) async {
    try {
      await _firestore.collection('instrument').add({
        'name': instrumentName,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Instrumento "$instrumentName" cadastrado com sucesso!')),
      );
      //Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar instrumento: $e')),
      );
    }
  }

  Future<void> updateInstrument(
      String documentId, String instrumentName, BuildContext context) async {
    try {
      await _firestore
          .collection('instrument')
          .doc(documentId)
          .update({'name': instrumentName});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Instrumento "$instrumentName" atualizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar instrumento: $e')),
      );
    }
  }

  Future<void> deleteInstrument(String documentId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('instrument')
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Instrumento excluído com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir instrumento: $e')),
      );
    }
  }
}
