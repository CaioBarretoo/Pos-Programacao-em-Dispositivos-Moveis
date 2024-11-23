import 'package:get/get.dart';
import 'package:ip_to_geo/controllers/db_controller.dart';
import 'package:ip_to_geo/controllers/rest_controller.dart';
import 'package:ip_to_geo/source/local/database.dart';
import 'package:ip_to_geo/source/remote/rest_client.dart';
import 'package:ip_to_geo/repositories/db_repository.dart';
import 'package:ip_to_geo/repositories/rest_repository.dart';
import 'package:dio/dio.dart';

class MainBindings extends Bindings{

  @override
  void dependencies() {
    Get.put(AppDatabase());
    Get.put(RestClient(Dio()));
    Get.put(RestController(repository: RestRepositoryImpl()));
    Get.put(DbController(repository: DbRepositoryImpl()));
  }

}