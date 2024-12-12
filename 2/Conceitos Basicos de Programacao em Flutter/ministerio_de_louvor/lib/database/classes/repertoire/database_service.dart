import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../retrofit/dio_client.dart';
import '../../../retrofit/interface/repertoire_api.dart';
import '../../../retrofit/repertoire.dart';

class RepertoireDatabaseService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final dioClient = DioClient();
  late final repertoireApi = RepertoireApi(dioClient.dio);

  Future<int> getMaxIdRepertoire() async {
    try {
      final querySnapshot = await _firestore
          .collection('repertoire')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 0;
      } else {
        return querySnapshot.docs.first.data()['id'] as int;
      }
    } catch (e) {
      return -1;
    }
  }

  Future<List<Repertoire>> loadRepertoire() async {
    try {
      final repertoire = await repertoireApi.getRepertoire();
      return repertoire;
    } catch (e) {
      print('Erro ao carregar o repertório: $e');
      return [];
    }
  }

  Future<void> addMusic(Repertoire newMusic, BuildContext context) async {
    try {
      await repertoireApi.addMusic([newMusic]);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Música adicionada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar música: $e')),
      );
    }
  }

  Future<void> updateMusic(
      int id, Repertoire music, BuildContext context) async {
    try {
      await repertoireApi.updateMusic(id, music);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Música editada com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao editar música: $e')),
      );
    }
  }

  // Em RepertoireDatabaseService
  Future<void> deleteMusic(int id, BuildContext context) async {
    try {
      await repertoireApi.deleteMusic(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Música deletada com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao editar música: $e')),
      );
    }
  }
}
