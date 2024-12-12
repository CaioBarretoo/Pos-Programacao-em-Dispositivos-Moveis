import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class VolumeChecker {
  static const platform = MethodChannel('volume_channel');

  static Future<void> checkVolume(BuildContext context) async {
    try {
      final int volume = await platform.invokeMethod('getVolume');
      if (volume == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Aumente o volume caso deseja escutar o repertório!'),
        ));
      } else if (volume >= 15) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Cuidado com o volume alto para escutar o repertório!'),
        ));
      }
    } on PlatformException catch (e) {
      print("Erro ao obter o volume: '${e.message}'.");
    }
  }
}
