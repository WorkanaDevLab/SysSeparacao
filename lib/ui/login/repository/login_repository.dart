import 'dart:convert';

import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/unidade_empresarial.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/data/models/usuario.dart';

import '../../../network/app_endpoints.dart';
import '../../../network/http_manager.dart';
import '../../../network/response/api_result.dart';

class LoginRepository {

  final HttpManager _httpManager = HttpManager();

  String username = 'hjsystems';
  String password = '11032011';


  Future<ApiResult> getUnidadesEmpresariais() async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final result = await _httpManager.restRequest(
      url: ApiEndPoints.getUnidadadesEmpresarias,
      method: HttpMethods.get,
      headers: {
        'Authorization': basicAuth,
      },
    );

    if (result != null) {
      List<UnidadeEmpresarial> unidades = List<Map<String, dynamic>>.from(result).map(UnidadeEmpresarial.fromJson).toList();
      return ApiResult<List<UnidadeEmpresarial>>.success(unidades);
    } else {
      return ApiResult.error('Não foi possível recuperar a lista de unidades empresariais');
    }
  }

  Future<ApiResult> getSetor() async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final result = await _httpManager.restRequest(
      url: ApiEndPoints.getSetor,
      method: HttpMethods.get,
      headers: {
        'Authorization': basicAuth,
      },
    );

    if (result != null) {
      List<Setor> unidades = List<Map<String, dynamic>>.from(result).map(Setor.fromJson).toList();
      return ApiResult<List<Setor>>.success(unidades);
    } else {
      return ApiResult.error('Não foi possível recuperar a lista de setores');
    }
  }

  Future<ApiResult> getUsuarios({required String unemId}) async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final result = await _httpManager.restRequest(
      url: "${ApiEndPoints.getUsuarios}?unemid=$unemId",
      method: HttpMethods.get,
      headers: {
        'Authorization': basicAuth,
      },
    );

    if (result != null) {
      List<Usuario> usuarios = List<Map<String, dynamic>>.from(result).map(Usuario.fromJson).toList();
      return ApiResult<List<Usuario>>.success(usuarios);
    } else {
      return ApiResult.error('Não foi possível recuperar a lista de usuários');
    }
  }

}