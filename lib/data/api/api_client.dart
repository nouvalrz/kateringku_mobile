import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late Map<String, String> _mainHeaders;

  Map<String, String> get mainHeaders => _mainHeaders;

  ApiClient({required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token = AppConstant.TOKEN;
    _mainHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(String uri) async {
    try {
      Response response = await get(uri);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> getDataWithToken(String uri, String token) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      Response response = await get(uri, headers: headers);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      // print(uri);
      // print(body);
      // print(_mainHeaders);
      return response;
    } catch (e) {
      // print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeaderFormData(String token) {
    _mainHeaders = {
      'Authorization': 'Bearer $token',
    };
  }

}
