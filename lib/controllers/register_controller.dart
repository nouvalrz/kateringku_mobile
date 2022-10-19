import 'package:get/get.dart';

import 'package:kateringku_mobile/data/repositories/register_repo.dart';
import 'package:kateringku_mobile/models/customer_register_body.dart';
import 'package:kateringku_mobile/models/response_model.dart';

class RegisterController extends GetxController implements GetxService {
  final RegisterRepo registerRepo;

  RegisterController({
    required this.registerRepo,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> registration(
      CustomerRegisterBody customerRegisterBody) async {
    _isLoading = true;
    Response response = await registerRepo.registration(customerRegisterBody);
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["status"].toString());
    } else {
      responseModel = ResponseModel(false, response.body["status"].toString());
    }
    _isLoading = true;
    update();
    return responseModel;
  }
}
