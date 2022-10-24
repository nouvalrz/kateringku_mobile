import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/otp_validation_repo.dart';
import 'package:kateringku_mobile/models/otp_validation_body.dart';
import 'package:kateringku_mobile/models/response_model.dart';

class OtpValidationController extends GetxController implements GetxService {
  final OtpValidationRepo otpValidationRepo;
  OtpValidationController({required this.otpValidationRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> validate(OtpValidationBody otpValidationBody) async {
    _isLoading = true;
    Response response = await otpValidationRepo.validate(otpValidationBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      otpValidationRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.body["message"]);
    }
    _isLoading = true;
    update();
    return responseModel;
  }
}
