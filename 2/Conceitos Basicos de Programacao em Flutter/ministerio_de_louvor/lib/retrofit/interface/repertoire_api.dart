import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:ministerio_de_louvor/retrofit/repertoire.dart';

part 'repertoire_api.g.dart';

@RestApi(baseUrl: "https://repetorio-api.onrender.com/") // http://localhost:3000/ http://10.0.2.2:3000/
abstract class RepertoireApi {
  factory RepertoireApi(Dio dio, {String baseUrl}) = _RepertoireApi;

  @GET("repertorio")
  Future<List<Repertoire>> getRepertoire();

  @POST("repertorio")
  Future<void> addMusic(@Body() List<Repertoire> musicas);

  @PATCH("repertorio/{id}")
  Future<void> updateMusic(@Path("id") int id, @Body() Repertoire music,);

  @DELETE("repertorio/{id}")
  Future<void> deleteMusic(@Path("id") int id);

}