import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/explore_repo.dart';

import '../models/catering_display_model.dart';

class CategoryController extends GetxController implements GetxService {
  final ExploreRepo exploreRepo;

  CategoryController({required this.exploreRepo});

  var isLoading = false.obs;

  var cateringResult = <CateringDisplayModel>[];


  Future<void> getCategoryResult(String keyword, String district_name) async{
    isLoading.value = true;

    cateringResult.clear();

    Map<String, dynamic> keywordBody = <String, dynamic>{};
    keywordBody['keyword'] = keyword;
    keywordBody['district_name'] = district_name;

    Response response = await exploreRepo.getCategoryResult(keywordBody);

    if (response.statusCode == 200) {
      for (var i = 0; i < response.body['caterings'].length; i++) {
        cateringResult.add(CateringDisplayModel.fromJson(response.body['caterings'][i]));
      }
      update();
    }

    isLoading.value = false;
  }
}