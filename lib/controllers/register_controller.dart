import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:kateringku_mobile/data/repositories/register_repo.dart';
import 'package:kateringku_mobile/models/customer_register_body.dart';
import 'package:kateringku_mobile/models/response_model.dart';

class RegisterController extends GetxController implements GetxService {
  final RegisterRepo registerRepo;

  RegisterController({
    required this.registerRepo,
  });

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  late TextEditingController nameController,
      emailController,
      phoneController,
      passwordController,
      passwordConfirmationController;
  var name = '';
  var email = '';
  var phone = '';
  var password = '';
  var passwordConfirmation = '';

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Email is not valid format";
    }
    return null;
  }

  String? validatePhone(String value) {
    if (value.length <= 10) {
      return "Phone lenght must atleast 10 number";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password is empty";
    } else if (value.length <= 10) {
      return "Password must atleast 10 character and have atleast one number";
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return "Password must have atleast one number";
    }
    return null;
  }

  String? validatePasswordConfirmation(String value1, String value2) {
    if (value1.isEmpty) {
      return "Password confirmation is empty";
    } else if (value1 != value2) {
      return "Password confirmation not same";
    }
    return null;
  }

  String? validateName(String value) {
    if (value.length <= 5) {
      return "Name must atleast 5 character";
    }
    return null;
  }

  void checkFormRegisterValidation() {
    final isValid = registerFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    registerFormKey.currentState!.save();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> registration(
      CustomerRegisterBody customerRegisterBody) async {
    _isLoading = true;
    Response response = await registerRepo.registration(customerRegisterBody);
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["status"].toString());
    } else {
      responseModel = ResponseModel(false, response.body["status"].toString());
    }
    _isLoading = true;
    update();
    return responseModel;
  }
}
