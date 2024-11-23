import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ip_to_geo/controllers/db_controller.dart';

class Offline extends GetView<DbController> {
  @override
  Widget build(BuildContext context) {
    controller.getSavedData();
    return controller.obx((allItems) {
      List<ListTile> listItens = allItems
          ?.map(
            (geo) => ListTile(
          title: Text(geo.ip),
          subtitle: Text(geo.city),
        ),
      )
          .toList() ??
          [];
      return ListView.separated(
          itemBuilder: (context, index) => listItens[index],
          separatorBuilder: (context, index) => const Divider(
            height: 1,
          ),
          itemCount: listItens.length);
    },
        onError: (error) => Text(error.toString()),
        onLoading: const CircularProgressIndicator());
  }
}