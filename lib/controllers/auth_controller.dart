import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/base/show_custom_snackbar.dart';
import 'package:kateringku_mobile/data/repositories/auth_repo.dart';
import 'package:kateringku_mobile/models/customer_login_body.dart';
import 'package:kateringku_mobile/models/response_model.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  var isLoading = false.obs;

  Future<ResponseModel> login(CustomerLoginBody customerLoginBody) async {
    isLoading.value = true;
    // final fcmToken = "jhjhj";
    final fcmToken = await FirebaseMessaging.instance.getToken();
    customerLoginBody.fcm_token = fcmToken;
    Response response = await authRepo.login(customerLoginBody);
    late ResponseModel responseModel;
    print(response.body);
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      showCustomSnackBar(message: response.body, title: response.statusCode.toString());
      responseModel = ResponseModel(false, response.statusText!);
    }
    isLoading.value = false;
    update();
    return responseModel;
  }
}
