import 'package:cep_app/models/geocode_model.dart';
import 'package:cep_app/repositories/get_api_repository.dart';
import 'package:dio/dio.dart';

import '../.env.dart';

class GeocodeApiImp implements GetApiRepository {
  @override
  getInfo(String cep) async {
    final dio = Dio();
    try {
      final result = await dio.get(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$cep&key=$googleAPIKey');
      final jsonDecode = GeocodeModel.fromMap(result.data);
      return jsonDecode;
    } finally {
      dio.close();
    }
  }
}
