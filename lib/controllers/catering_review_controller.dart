import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/review_repo.dart';
import 'package:kateringku_mobile/models/catering_review_model.dart';

class CateringReviewController extends GetxController {
  var isLoading = false.obs;

  final ReviewRepo reviewRepo;

  CateringReviewController({required this.reviewRepo});

  var cateringReview = CateringReviewModel();

  Future<void> getCateringReview(int cateringId) async {
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    Response response = await reviewRepo.getCateringReview(cateringId);

    if (response.statusCode == 200) {
      cateringReview =
          CateringReviewModel.fromJson(response.body['catering_review']);
    }

    isLoading.value = false;
    EasyLoading.dismiss();
  }
}
