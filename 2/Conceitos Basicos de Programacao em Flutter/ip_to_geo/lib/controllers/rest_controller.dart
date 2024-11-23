import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ip_to_geo/model/geo_data.dart';
import 'package:get/get.dart';
import 'package:ip_to_geo/repositories/rest_repository.dart';

class RestController extends GetxController with StateMixin<GeoData>{

  RestController({required this.repository}){
    change(null, status: RxStatus.empty());
  }

  final RestRepository repository;

  Future<void> getGeoIp({required String ip}) async {
    change(null, status: RxStatus.loading());

    await repository.getDataByIp(ip: ip)
        .then((value) {
      change(value, status: RxStatus.success());
    })
        .onError((error, stackTrace) {
      change(null, status: RxStatus.error(error.toString()));
    });
  }

}