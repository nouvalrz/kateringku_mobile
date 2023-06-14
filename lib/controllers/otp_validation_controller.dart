import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/otp_validation_repo.dart';
import 'package:kateringku_mobile/models/otp_validation_body.dart';
import 'package:kateringku_mobile/models/response_model.dart';

class OtpValidationController extends GetxController implements GetxService {
  final OtpValidationRepo otpValidationRepo;
  OtpValidationController({required this.otpValidationRepo});

  var isLoading = false.obs;

  Future<ResponseModel> validate(OtpValidationBody otpValidationBody) async {
    isLoading.value = true;
    Response response = await otpValidationRepo.validate(otpValidationBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      otpValidationRepo.saveUserToken(response.body["token"]);
      responseModel =
          ResponseModel(true, response.body["token"], response.body['type']);
    } else {
      responseModel =
          ResponseModel(false, response.body["message"], response.body['type']);
    }
    update();
    isLoading.value = false;
    return responseModel;
  }
}
