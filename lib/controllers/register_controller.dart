import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:kateringku_mobile/data/repositories/register_repo.dart';
import 'package:kateringku_mobile/models/customer_check_email_body.dart';
import 'package:kateringku_mobile/models/customer_check_phone_body.dart';
import 'package:kateringku_mobile/models/customer_register_body.dart';
import 'package:kateringku_mobile/models/response_model.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';

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
  String lastRejectedEmail = '';
  String lastAvailableEmail = '';
  String lastRejectedPhone = '';
  String lastAvailablePhone = '';
  var isValid = false;
  var isLoading = false.obs;

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
    if (!value.isEmail) {
      return "Email is not valid format";
    } else if (lastAvailableEmail == value) {
      return null;
    } else if (lastRejectedEmail == value) {
      return "Email already taken";
    } else {
      CustomerCheckEmailBody customerCheckEmailBody =
          CustomerCheckEmailBody(email: value);
      checkEmail(customerCheckEmailBody);
      return "Validation is on progress";
    }
  }

  String? validatePhone(String value) {
    if (value.length <= 10) {
      return "Phone lenght must atleast 10 number";
    } else if (lastAvailablePhone == "62$value") {
      return null;
    } else if (lastRejectedPhone == "62$value") {
      return "Phone already taken";
    } else {
      CustomerCheckPhoneBody customerCheckPhoneBody =
          CustomerCheckPhoneBody(phone: "62$value");
      checkPhone(customerCheckPhoneBody);
      return "Validation is on progress";
    }
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

  Future<ResponseModel> registration(
      CustomerRegisterBody customerRegisterBody) async {
    isLoading.value = true;
    Response response = await registerRepo.registration(customerRegisterBody);
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["status"].toString());
    } else {
      responseModel = ResponseModel(false, response.body["status"].toString());
    }
    isLoading.value = false;
    update();
    return responseModel;
  }

  void checkFormRegisterValidation() async {
    isLoading.value = true;
    isValid = registerFormKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return;
    } else {
      isLoading.value = true;
      registerFormKey.currentState!.save();
      CustomerRegisterBody customerRegisterBody = CustomerRegisterBody(
          name: name,
          phone: "62$phone",
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation);
      await registration(customerRegisterBody).then((status) {
        if (status.isSuccess) {
          Get.toNamed(RouteHelper.getOtpValidation(
              customerRegisterBody.email, customerRegisterBody.password));
          return;
        }
      });
    }
    isLoading.value = false;
  }

  Future<void> checkEmail(CustomerCheckEmailBody customerCheckEmailBody) async {
    Response response =
        await registerRepo.checkEmailAvail(customerCheckEmailBody);
    if (response.statusCode == 422) {
      lastRejectedEmail = customerCheckEmailBody.email;
    } else {
      lastAvailableEmail = customerCheckEmailBody.email;
    }
    // registerFormKey.currentState!.validate();
    checkFormRegisterValidation();
  }

  Future<void> checkPhone(CustomerCheckPhoneBody customerCheckPhoneBody) async {
    Response response =
        await registerRepo.checkPhoneAvail(customerCheckPhoneBody);
    if (response.statusCode == 422) {
      lastRejectedPhone = customerCheckPhoneBody.phone;
    } else {
      lastAvailablePhone = customerCheckPhoneBody.phone;
    }
    checkFormRegisterValidation();
    // registerFormKey.currentState!.validate();
  }
}
