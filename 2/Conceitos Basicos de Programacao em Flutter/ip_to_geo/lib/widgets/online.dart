import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ip_to_geo/main.dart';
import 'package:ip_to_geo/source/local/database.dart';
import 'package:ip_to_geo/model/geo_data.dart' as model;
import 'package:ip_to_geo/source/remote/rest_client.dart';

class Online extends StatelessWidget {
  Online({super.key});

  final TextEditingController _ipController = TextEditingController();
  final client = RestClient(Dio());
  final database = AppDatabase();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _ipController,
              maxLength: 15,
              decoration: const InputDecoration(
                labelText: 'My IP',
              ),
            ),
            TextButton(
                onPressed: () async {
                  // 1 - busca da posição atrás do IP
                  model.GeoData geo = await client.getGeoData(_ipController.text);
                  showBottomSheet(
                    enableDrag: true,
                    showDragHandle: true,
                    context: context,
                    builder: (context) {
                      return Wrap(
                        children: [
                          ListTile(
                            title: Text('City: ${geo.city}'),
                          ),
                          ListTile(
                            title: Text('Region Name: ${geo.regionName}'),
                          ),
                          ListTile(
                            title: Text('Country: ${geo.country}'),
                          ),
                          IconButton(
                              onPressed: () {
                                // 3 - no clique do ícone de mapa, manda para o mapa
                                Navigator.pushNamed(context, mapRoute,
                                    arguments: {
                                      "lat": geo.lat,
                                      "lon": geo.lon
                                    });
                              },
                              icon: const Icon(Icons.map_outlined))
                        ],
                      );
                    },
                  );
                  // 2 - chama a função que salva o resultado da busca no banco
                  _save(data: geo);
                },
                child: const Text("Find"))
          ],
        ));
  }
  void _save({required model.GeoData data}) {
    database.into(database.geoData).insert(GeoDataCompanion.insert(
          ip: data.query ?? "",
          city: data.city ?? "",
          regionName: data.regionName ?? "",
          country: data.country ?? "",
          lat: "${data.lat}",
          lon: "${data.lon}",
        ));
  }
}