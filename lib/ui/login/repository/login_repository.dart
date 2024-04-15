import 'dart:convert';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/unidade_empresarial.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/utils.dart';
import '../../../constants.dart';
import '../../../network/http_manager.dart';
import '../../../network/response/api_result.dart';

class LoginRepository {

  final HttpManager _httpManager = HttpManager();
  Utils utils = Utils();

  String username = 'hjsystems';
  String password = '11032011';

  Future<String> _getBaseUrl() async {
    String? baseUrl = await utils.getLocalData(key: Constants.BASE_URL);
    return baseUrl ?? 'http://45.191.204.61:8087';
  }

  Future<ApiResult> getUnidadesEmpresariais() async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    String baseUrl = await _getBaseUrl();

    final result = await _httpManager.restRequest(
      url: "$baseUrl/getUnidadesEmpresariais",
      method: HttpMethods.get,
      headers: {
        'Authorization': basicAuth,
      },
    );

    try {
      if (result != null) {
        List<UnidadeEmpresarial> unidades = List<Map<String, dynamic>>.from(
            result).map(UnidadeEmpresarial.fromJson).toList();
        return ApiResult<List<UnidadeEmpresarial>>.success(unidades);
      } else {
        return ApiResult.error(
            'Não foi possível recuperar a lista de unidades empresariais');
      }
    }catch (e) {
      print("erro ao recuperar lista de empresas $e");
      return ApiResult.error(
          'Não foi possível recuperar a lista de unidades empresariais');
    }
  }

  Future<ApiResult> getSetor() async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    String baseUrl = await _getBaseUrl();

    final result = await _httpManager.restRequest(
      url: "$baseUrl/getSetor",
      method: HttpMethods.get,
      headers: {
        'Authorization': basicAuth,
      },
    );

    try {
      if (result != null) {
        List<Setor> unidades = List<Map<String, dynamic>>.from(result).map(
            Setor.fromJson).toList();
        return ApiResult<List<Setor>>.success(unidades);
      } else {
        return ApiResult.error('Não foi possível recuperar a lista de setores');
      }
    } catch (e) {
      print("erro ao recuperar lista de setores $e");
      return ApiResult.error('Não foi possível recuperar a lista de setores');
    }
  }

  Future<ApiResult> getUsuarios({required String unemId}) async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    String baseUrl = await _getBaseUrl();

    final result = await _httpManager.restRequest(
      url: "$baseUrl/getUsuarios?unemid=$unemId",
      method: HttpMethods.get,
      headers: {
        'Authorization': basicAuth,
      },
    );

    try {
      if (result != null) {
        List<Usuario> usuarios = List<Map<String, dynamic>>.from(result).map(
            Usuario.fromJson).toList();
        return ApiResult<List<Usuario>>.success(usuarios);
      } else {
        return ApiResult.error(
            'Não foi possível recuperar a lista de usuários');
      }
    } catch (e) {
      print("erro ao recuperar lista de usuarios $e");
      return ApiResult.error(
          'Não foi possível recuperar a lista de usuários');
    }
  }

}