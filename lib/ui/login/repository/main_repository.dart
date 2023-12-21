import 'dart:async';
import 'dart:convert';

import 'package:flutterbase/data/models/item_pedido.dart';
import 'package:flutterbase/data/models/itens_lidos.dart';
import 'package:flutterbase/data/models/pedido.dart';
import 'package:flutterbase/utils.dart';

import '../../../constants.dart';
import '../../../network/app_endpoints.dart';
import '../../../network/http_manager.dart';
import '../../../network/response/api_result.dart';
import 'package:http/http.dart' as http;

class MainRepository {

  final HttpManager _httpManager = HttpManager();
  Utils utils = Utils();

  String username = 'hjsystems';
  String password = '11032011';

  Future<String> _getBaseUrl() async {
    String? baseUrl = await utils.getLocalData(key: Constants.BASE_URL);
    return baseUrl ?? 'http://52.4.98.235:9986';
  }


  Future<dynamic> setGravaConferencia({required List<ItemLido> itens}) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    String baseUrl = await _getBaseUrl();

    List<Map<String, dynamic>> itensMap = itens.map((item) => item.toJson()).toList();

    String jsonBody = jsonEncode(itensMap);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/setGravaConferencia"),
        headers: <String, String>{
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print("dados enviados com sucesso");
        return true;
      } else {

        print('Falha ao enviar dados');
        return false;
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return false;
    }
  }

  Future<ApiResult> getItensPedidos({required String pddsID, required String setorID}) async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    String baseUrl = await _getBaseUrl();

    final result = await _httpManager.restRequest(
      url: "$baseUrl/getItensPedidos?pddsid=$pddsID&setorid=$setorID",
      method: HttpMethods.get,
      headers: {
        'Authorization': basicAuth,
      },
    );

    print(result);

    if (result != null) {
      List<ItemPedido> itemPedido = List<Map<String, dynamic>>.from(result).map(ItemPedido.fromJson).toList();
      return ApiResult<List<ItemPedido>>.success(itemPedido);
    } else {
      return ApiResult.error('Não foi possível recuperar a lista de unidades empresariais');
    }
  }

  Future<ApiResult> getPedidos({required String unemID, required String codigoPedido}) async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    String baseUrl = await _getBaseUrl();

    final result = await _httpManager.restRequest(
      url: "$baseUrl/getPedidos?unemid=$unemID&pedido=$codigoPedido",
      method: HttpMethods.get,
      headers: {
        'Authorization': basicAuth,
      },
    );

    try {
      if (result != null) {
        if (result is List && result.isEmpty) {
          return ApiResult<List<Pedido>>.success([]);
        } else {
          List<Pedido> itemPedido = List<Map<String, dynamic>>.from(result)
              .map(Pedido.fromJson)
              .toList();
          return ApiResult<List<Pedido>>.success(itemPedido);
        }
      } else {
        return ApiResult.error(
            'Não foi possível recuperar a lista de itens do pedido');
      }
    } catch (e) {
      if (e is TimeoutException) {
        return ApiResult.error('Tempo limite atingido. Tente novamente mais tarde.');
      } else {
        return ApiResult.error('Ocorreu um erro durante a requisição. Tente novamente mais tarde.');
      }
    }

  }

  Future<dynamic> setReiniciaConferencia({required String pddsID}) async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    String baseUrl = await _getBaseUrl();

    final result = await _httpManager.restRequest(
      url: "$baseUrl/setReiniciaConferencia?pddsid=$pddsID",
      method: HttpMethods.post,
      headers: {
        'Authorization': basicAuth,
      },
    );

    return result;
  }

  Future<dynamic> setCancelaConferencia({required String pddsID}) async {

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    String baseUrl = await _getBaseUrl();

    final result = await _httpManager.restRequest(
      url: "$baseUrl/setCancelaConferencia?pddsid=$pddsID",
      method: HttpMethods.post,
      headers: {
        'Authorization': basicAuth,
      },
    );

    return result;
  }

}