import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kateringku_mobile/constants/image_path.dart';
import 'package:kateringku_mobile/controllers/register_controller.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';
import 'package:kateringku_mobile/components/primary_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _passwordVisible = true;
  bool _passwordConfirmationVisible = true;

  @override
  void initState() {
    _passwordVisible = false;
    _passwordConfirmationVisible = false;
  }

  var password = "";

  @override
  Widget build(BuildContext context) {
    var registerControler = Get.find<RegisterController>();
    return Scaffold(
      body: Stack(children: [
        Align(
          child: SvgPicture.asset(VectorPath.orangeRadial),
          alignment: Alignment.bottomLeft,
        ),
        Align(
          child: SvgPicture.asset(VectorPath.greenRadial),
          alignment: Alignment.topRight,
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Stack(children: [
              Form(
                key: registerControler.registerFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, bottom: 20, top: 90),
                        child: Image.asset(
                          ImagePath.kateringkuLogo,
                          height: 80,
                        ),
                      )
                    ]),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40, bottom: 40),
                          child: Text(
                            'Registrasi Akun',
                            style: AppTheme.textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: registerControler.nameController,
                              onSaved: (value) {
                                registerControler.name = value!;
                              },
                              validator: (value) {
                                return registerControler.validateName(value!);
                              },
                              decoration: InputDecoration(
                                hintText: 'Nama Lengkap',
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 215, 80, 46),
                                        width: 0.6)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 215, 80, 46),
                                        width: 0.6)),
                              ),
                              style: AppTheme.textTheme.labelMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: registerControler.emailController,
                              onSaved: (value) {
                                registerControler.email = value!;
                              },
                              validator: (value) {
                                return registerControler.validateEmail(value!);
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 215, 80, 46),
                                        width: 0.6)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 215, 80, 46),
                                        width: 0.6)),
                              ),
                              style: AppTheme.textTheme.labelMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: registerControler.phoneController,
                              onSaved: (value) {
                                registerControler.phone = value!;
                              },
                              validator: (value) {
                                return registerControler.validatePhone(value!);
                              },
                              decoration: InputDecoration(
                                hintText: '  Nomer Telepon',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 12,
                                  ),
                                  child: SvgPicture.asset(VectorPath.phoneCode),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                    maxHeight: 120,
                                    maxWidth: 120,
                                    minWidth: 46,
                                    minHeight: 56),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 215, 80, 46),
                                        width: 0.6)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 215, 80, 46),
                                        width: 0.6)),
                              ),
                              style: AppTheme.textTheme.labelMedium,
                            ),
                          ),
                          passwordInput(),
                          passwordConfirmationInput(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 40, bottom: 120),
                            child: Obx(() => PrimaryButton(
                                  title: 'Daftar Sekarang',
                                  onTap: () {
                                    // Get.toNamed(RouteHelper.getOtpValidation(
                                    //     "anjay@gmail.com"));
                                    // _registration();
                                    registerControler
                                        .checkFormRegisterValidation();
                                  },
                                  state: registerControler.isLoading.value
                                      ? ButtonState.loading
                                      : ButtonState.idle,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ]),
    );
  }

  Padding passwordInput() {
    var registerControler = Get.find<RegisterController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: registerControler.passwordController,
        onSaved: (value) {
          registerControler.password = value!;
        },
        onChanged: (value) {
          password = value;
        },
        validator: (value) {
          return registerControler.validatePassword(value!);
        },
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 215, 80, 46), width: 0.6)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 215, 80, 46), width: 0.6)),
            hintText: 'Password',
            suffixIcon: IconButton(
                splashColor: Colors.transparent,
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppTheme.secondaryBlack.withOpacity(0.5),
                  size: 20,
                ))),
        style: AppTheme.textTheme.labelMedium,
      ),
    );
  }

  Padding passwordConfirmationInput() {
    var registerControler = Get.find<RegisterController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: registerControler.passwordConfirmationController,
        onSaved: (value) {
          registerControler.passwordConfirmation = value!;
        },
        validator: (value) {
          return registerControler.validatePasswordConfirmation(
              value!, password);
        },
        obscureText: !_passwordConfirmationVisible,
        decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 215, 80, 46), width: 0.6)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 215, 80, 46), width: 0.6)),
            hintText: 'Ulangi Password',
            suffixIcon: IconButton(
                splashColor: Colors.transparent,
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordConfirmationVisible =
                        !_passwordConfirmationVisible;
                  });
                },
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordConfirmationVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppTheme.secondaryBlack.withOpacity(0.5),
                  size: 20,
                ))),
        style: AppTheme.textTheme.labelMedium,
      ),
    );
  }
}
