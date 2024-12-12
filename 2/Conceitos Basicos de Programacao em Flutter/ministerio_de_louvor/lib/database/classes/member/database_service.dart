import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemberDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> insertMember(
      Map<String, dynamic> memberData, BuildContext context) async {
    try {
      await _firestore.collection('member').add(memberData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membro cadastrado com sucesso!')),
      );
      //Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar membro: $e')),
      );
    }
  }

  Future<void> updateMember(String documentId, Map<String, dynamic> memberData,
      BuildContext context) async {
    try {
      await _firestore.collection('member').doc(documentId).update(memberData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membro atualizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar membro: $e')),
      );
    }
  }

  Future<void> deleteMember(String documentId, BuildContext context) async {
    try {
      await _firestore.collection('member').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membro excluído com sucesso!')),
      );
      // Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir membro: $e')),
      );
    }
  }
}
