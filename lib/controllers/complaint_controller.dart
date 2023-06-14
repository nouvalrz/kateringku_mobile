import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base/show_custom_snackbar.dart';
import '../constants/app_constant.dart';
import '../data/api/api_client.dart';
import 'dart:io';

class ComplaintController extends GetxController {
  ComplaintController({required this.apiClient});

  final ApiClient apiClient;

  RxList<XFile?> images = RxList.empty();

  final ImagePicker picker = ImagePicker();

  var isLoading = false.obs;

  var problem = "";
  var solution_type = "";

  Future<void> pickImageFromCamera() async {
    // isImageUpload.value = false;
    XFile? image = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    images.add(image);
    // isImageUpload.value = true;
  }

  void deleteImage(int index) {
    images.value.removeAt(index);
    images.refresh();
  }

  Future<void> postComplaintSubs(
      {required String order_id, required String deliveryDateTime}) async {
    if (!isFormValid()) {
      showCustomSnackBar(
          message: "Anda perlu melengkapi semua data",
          title: "Penuhi semua data!");
      return;
    }

    isLoading.value = true;

    late String problemType;

    if (problem == "Makanan Rusak") {
      problemType = "damaged";
    } else if (problem == "Belum Sampai") {
      problemType = "not_received";
    } else if (problem == "Ada yang Kurang") {
      problemType = "incomplete";
    }

    Map<String, dynamic> body = {
      'problem': problemType,
      'orders_id': order_id,
      'delivery_datetime': deliveryDateTime.toString(),
    };

    FormData reviewBody = FormData(body);

    images.value.asMap().forEach((index, element) {
      // multipartImages.add(MultipartFile(File(element!.path!),
      //     filename: "review-${index + 1}.jpg"));
      reviewBody.files.add(MapEntry(
          "images[]",
          MultipartFile(File(element!.path!),
              filename: "review-${index + 1}.jpg")));
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeaderFormData(token);

    Response response =
        await apiClient.postData(AppConstant.POST_COMPLAINT_SUBS, reviewBody);

    isLoading.value = false;
  }

  Future<void> postComplain({required String order_id}) async {
    isLoading.value = true;

    late String problemType;

    if (problem == "Makanan Rusak") {
      problemType = "damaged";
    } else if (problem == "Belum Sampai") {
      problemType = "not_received";
    } else if (problem == "Ada yang Kurang") {
      problemType = "incomplete";
    }

    late String solution;

    if (solution_type == "Pengembalian Dana") {
      solution = "refund";
    } else if (solution_type == "Pengiriman Ulang") {
      solution = "retur";
    }

    Map<String, dynamic> body = {
      'problem': problemType,
      'orders_id': order_id,
      'solution_type': solution,
    };

    // var multipartImages = [];

    // body['images'] = multipartImages;

    FormData reviewBody = FormData(body);

    images.value.asMap().forEach((index, element) {
      // multipartImages.add(MultipartFile(File(element!.path!),
      //     filename: "review-${index + 1}.jpg"));
      reviewBody.files.add(MapEntry(
          "images[]",
          MultipartFile(File(element!.path!),
              filename: "review-${index + 1}.jpg")));
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeaderFormData(token);

    Response response =
        await apiClient.postData(AppConstant.POST_COMPLAINT, reviewBody);

    print(response);

    isLoading.value = false;
  }

  bool isFormValid() {
    if (problem == "") {
      return false;
    }
    if (solution_type == "") {
      return false;
    }
    if (images.value.length == 0) {
      return false;
    }
    return true;
  }
}
