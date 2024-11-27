import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Importe para usar ScaffoldMessenger

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> insertSchedule(Map<String, dynamic> scheduleData) async {
    try {
      await _firestore.collection('schedules').add(scheduleData);
    } catch (e) {
      print('Erro ao salvar dados no Firebase: $e');
    }
  }

  Future<void> updateSchedule(String scheduleId, Map<String, dynamic> scheduleData, BuildContext context) async {
    try {
      await _firestore.collection('schedules').doc(scheduleId).update(scheduleData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escala atualizada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao atualizar escala: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar escala.')),
      );
    }
  }

  Future<void> deleteSchedule(String scheduleId, BuildContext context) async {
    try {
      await _firestore.collection('schedules').doc(scheduleId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escala deletada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao deletar escala: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao deletar escala.')),
      );
    }
  }

  Future<bool> isDateAlreadySaved(DateTime date) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}