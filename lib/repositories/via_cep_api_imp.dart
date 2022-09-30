import 'package:cep_app/models/address_model.dart';
import 'package:dio/dio.dart';

import 'via_cep_api.dart';

class ViaCepApiImp implements ViaCepApi {
  @override
  getCepInfo(String cep) async {
    final dio = Dio();
    try {
      final result = await dio.get('https://viacep.com.br/ws/$cep/json/');
      final jsonDecode = AddressModel.fromJson(result.data);
      return jsonDecode;
    } finally {
      dio.close();
    }
  }
}
