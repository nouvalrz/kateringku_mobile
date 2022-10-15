import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/auth_repo.dart';
import 'package:kateringku_mobile/models/customer_login_body.dart';
import 'package:kateringku_mobile/models/response_model.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> login(CustomerLoginBody customerLoginBody) async {
    _isLoading = true;
    Response response = await authRepo.login(customerLoginBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = true;
    update();
    return responseModel;
  }
}
