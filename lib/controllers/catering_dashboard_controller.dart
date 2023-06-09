import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/auth_repo.dart';
import 'package:kateringku_mobile/data/repositories/catering_client_repo.dart';
import 'package:kateringku_mobile/data/repositories/catering_repo.dart';
import 'package:kateringku_mobile/models/catering_dashboard_model.dart';

import '../base/show_custom_snackbar.dart';
import '../routes/route_helper.dart';

class CateringDashboardController extends GetxController {
  final CateringClientRepo cateringClientRepo;
  final AuthRepo authRepo;

  var isLoading = false.obs;

  CateringDashboardController(
      {required this.cateringClientRepo, required this.authRepo});
  CateringDashboardModel? cateringDashboardModel;

  Future<void> getCateringDashboard() async {
    isLoading.value = true;

    Response response = await cateringClientRepo.getCateringDashboard();

    if (response.statusCode == 200) {
      cateringDashboardModel = CateringDashboardModel.fromJson(response.body);
    }

    isLoading.value = false;
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
    }

    isLoading.value = false;
  }
}
