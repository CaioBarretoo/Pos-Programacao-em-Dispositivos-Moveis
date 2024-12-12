import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> insertSchedule(
      Map<String, dynamic> scheduleData, BuildContext context) async {
    try {
      await _firestore.collection('schedule').add(scheduleData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escala criada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao criar escala.')),
      );
    }
  }

  Future<void> updateSchedule(String scheduleId,
      Map<String, dynamic> scheduleData, BuildContext context) async {
    try {
      await _firestore
          .collection('schedule')
          .doc(scheduleId)
          .update(scheduleData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escala atualizada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar escala.')),
      );
    }
  }

  Future<void> deleteSchedule(String scheduleId, BuildContext context) async {
    try {
      await _firestore.collection('schedule').doc(scheduleId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escala deletada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao deletar escala.')),
      );
    }
  }

  Future<bool> isDateAlreadySaved(DateTime date) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('schedule')
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
