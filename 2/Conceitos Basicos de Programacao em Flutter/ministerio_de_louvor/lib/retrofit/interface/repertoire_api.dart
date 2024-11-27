import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:ministerio_de_louvor/retrofit/music.dart';

part 'repertoire_api.g.dart';

@RestApi(baseUrl: "http://localhost:3000/") // http://localhost:3000/ http://10.0.2.2:3000/
abstract class RepertoireApi {
  factory RepertoireApi(Dio dio, {String baseUrl}) = _RepertoireApi;

  @GET("repertorio")
  Future<List<Music>> getRepertoire();

  @POST("repertorio")
  Future<Music> addMusic(@Body() Music music);
}