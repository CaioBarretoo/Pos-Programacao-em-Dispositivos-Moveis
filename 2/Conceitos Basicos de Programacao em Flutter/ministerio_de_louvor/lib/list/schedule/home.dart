import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ministerio_de_louvor/details/schedule/home.dart';
import 'package:ministerio_de_louvor/edit/Schedule/home.dart';

import '../../register/schedule/home.dart';

class HomeListSchedule extends StatefulWidget {
  const HomeListSchedule({super.key});

  @override
  State<HomeListSchedule> createState() => _HomeListScheduleState();
}

class _HomeListScheduleState extends State<HomeListSchedule> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeDateFormatting();
  }

  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('pt_BR', null);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text.rich(
            TextSpan(
              text: "Escala",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Próximas"),
              Tab(text: "Anteriores"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildScheduleList(context, true),
            _buildScheduleList(context, false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeRegisterSchedule()),
            );
          },
          tooltip: 'Criar Nova Escala',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildScheduleList(BuildContext context, bool isUpcoming) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('schedule').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados.'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final schedules = snapshot.data!.docs;
        final filteredSchedules = schedules.where((schedule) {
          final date =
              (schedule.data() as Map<String, dynamic>)['date'] as Timestamp;
          final today = DateTime.now();
          final scheduleDate = date.toDate();
          final yesterday = today
              .subtract(const Duration(days: 1)); // Calcula a data de ontem

          if (isUpcoming) {
            return scheduleDate
                    .isAfter(today.subtract(const Duration(days: 1))) ||
                scheduleDate.isAtSameMomentAs(today);
          } else {
            return scheduleDate.isBefore(yesterday);
          }
        }).toList();

        return ListView.builder(
          itemCount: filteredSchedules.length,
          itemBuilder: (context, index) {
            final scheduleData =
                filteredSchedules[index].data() as Map<String, dynamic>;
            final date = (scheduleData['date'] as Timestamp).toDate();

            final formattedDate =
                DateFormat('dd/MM/yyyy \nEEEE', 'pt_BR').format(date);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: ListTile(
                title: Text(formattedDate.toUpperCase(),
                    style: const TextStyle(fontSize: 18)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeEditSchedule(
                                scheduleId: filteredSchedules[index].id,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeDetailsSchedule(
                          scheduleId: filteredSchedules[index].id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
