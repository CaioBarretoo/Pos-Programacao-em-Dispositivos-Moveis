import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ip_to_geo/controllers/rest_controller.dart';
import 'package:ip_to_geo/repositories/rest_repository.dart';
import 'package:ip_to_geo/source/remote/rest_client.dart';
import 'package:ip_to_geo/model/geo_data.dart';
import 'package:get/get.dart';

import 'rest_controller_test.mocks.dart';

@GenerateMocks([RestClient, RestRepository])
void main(){

  late MockRestRepository restRepository;

  setUp(() {
    Get.put<RestClient>(MockRestClient());
    restRepository = MockRestRepository();
  });

  test('', () async {
    GeoData fakeGeoData = const GeoData(
        query: "200.200.200.200",
        region: "RS",
        country: "Brasil",
        city: "Passo Fundo",
        countryCode: "BR",
        lat: 0.0,
        lon: 0.0,
        regionName: "RS",
        zip: "99980000"
    );

    when(restRepository.getDataByIp(ip: anyNamed("ip")))
        .thenAnswer((_) async {
      return fakeGeoData;
    });

    final RestController controller = RestController(repository: restRepository);
    await controller.getGeoIp(ip: "200.200.200.200");

    expect(fakeGeoData.query, controller.state?.query);
  });

}