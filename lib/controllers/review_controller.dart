import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kateringku_mobile/base/show_custom_snackbar.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constant.dart';

class ReviewController extends GetxController{

  ReviewController({required this.apiClient});

  final ApiClient apiClient;
  var ratingStar = 0.0.obs;
  TextEditingController reviewDescriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? reviewImage;

  var isImageUpload = false.obs;

  var isLoading = false.obs;


  Future<void> pickImageFromCamera() async{
    isImageUpload.value = false;
    reviewImage = await picker.pickImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    isImageUpload.value = true;
  }

  Future<void> postReview({required String orderId, required String cateringId}) async{

    if(!isFormValid()){
      showCustomSnackBar(message: "Anda perlu melengkapi semua data", title: "Penuhi semua data!");
      return;
    }

    isLoading.value = true;
    // Create post body
    Random random = Random();
    int randomNumber = random.nextInt(99999999) + 10000000;

    Map<String, dynamic> body = {
      'star': ratingStar.value.toInt(),
      'description' : reviewDescriptionController.text,
      'order_id' : orderId,
      'catering_id' : cateringId
    };

    if(reviewImage != null){
      body['review_image'] = MultipartFile(File(reviewImage!.path), filename: "review.jpg");
    }

    FormData reviewBody = FormData(body);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeaderFormData(token);

    Response response = await apiClient.postData(AppConstant.POST_REVIEW, reviewBody);

    isLoading.value = false;
  }

  bool isFormValid(){
    if(ratingStar.value.toInt() == 0){
      return false;
    }
    if(reviewDescriptionController.text == ""){
      return false;
    }
    return true;
  }

  void setToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeaderFormData(token);
  }
}