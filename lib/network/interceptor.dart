import 'package:dio/dio.dart';

class CustomIntercetors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    /*
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('apiUrl')) {
      options.baseUrl = prefs.getString('apiUrl') ?? "";
    }

     */
    print(
        'REQUEST[${options.method}] => PATH: ${options.path} - BASE ${options.baseUrl}');

    return handler.next(options);
  }

  @override
  onResponse(response, handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return handler.next(err); //continue
  }
}