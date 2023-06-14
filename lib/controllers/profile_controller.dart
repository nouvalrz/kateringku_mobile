import 'package:get/get.dart';
import 'package:kateringku_mobile/base/show_custom_snackbar.dart';
import 'package:kateringku_mobile/data/repositories/auth_repo.dart';
import 'package:kateringku_mobile/data/repositories/otp_validation_repo.dart';
import 'package:kateringku_mobile/models/otp_validation_body.dart';
import 'package:kateringku_mobile/models/profile_model.dart';
import 'package:kateringku_mobile/models/response_model.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';

class ProfileController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  ProfileController({required this.authRepo});

  var isLoading = true.obs;

  // @override
  // void onInit(){
  //   super.onInit();
  //   getProfile();
  // }

  ProfileModel? profileModel;

  Future<void> getProfile() async {
    isLoading.value = true;
    Response response = await authRepo.profile();

    profileModel = ProfileModel(
        name: response.body["name"],
        email: response.body["email"],
        phone: response.body["phone"],
        balance: response.body["balance"]);

    // late ResponseModel responseModel;
    // if (response.statusCode == 200) {
    //   // response.body
    //   responseModel = ResponseModel(true, response.body["token"]);
    // } else {
    //   responseModel = ResponseModel(false, response.body["message"]);
    // }
    isLoading.value = false;
    // update();
  }

  Future<void> getProfileForOrder() async {
    // isLoading.value = true;
    Response response = await authRepo.profile();

    profileModel = ProfileModel(
        name: response.body["name"],
        email: response.body["email"],
        phone: response.body["phone"],
        balance: response.body["balance"]);

    // late ResponseModel responseModel;
    // if (response.statusCode == 200) {
    //   // response.body
    //   responseModel = ResponseModel(true, response.body["token"]);
    // } else {
    //   responseModel = ResponseModel(false, response.body["message"]);
    // }
    // isLoading.value = false;
    // update();
  }

  Future<void> logout() async {
    isLoading.value = true;

    Response response = await authRepo.logout();

    if (response.statusCode == 200) {
      authRepo.deleteUserToken();
      showCustomSnackBar(
          message: "Anda telah keluar dari akun",
          title: "Keluar Akun Berhasil");
      Get.offAllNamed(RouteHelper.onboard);
      Get.deleteAll();
    }

    isLoading.value = false;
  }
}
