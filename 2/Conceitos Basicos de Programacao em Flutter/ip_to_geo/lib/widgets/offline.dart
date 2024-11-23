import 'package:flutter/material.dart';
import 'package:ip_to_geo/source/local/database.dart';

class Offline extends StatefulWidget {
  const Offline({super.key});
  @override
  State<Offline> createState() => _OfflineState();
}
class _OfflineState extends State<Offline> {
  final database = AppDatabase();
  List<Widget> _listItens = [];
  @override
  void initState() {
    super.initState();
    readDB();
  }
  void readDB() async {
    List<GeoDataData> allItems = await database.select(database.geoData).get();
    _listItens = allItems
        .map(
          (geo) => ListTile(
            title: Text(geo.ip),
            subtitle: Text(geo.city),
          ),
        )
        .toList();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => _listItens[index],
        separatorBuilder: (context, index) => const Divider(
              height: 1,
            ),
        itemCount: _listItens.length);
  }
}