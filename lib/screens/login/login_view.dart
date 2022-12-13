import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/components/primary_button.dart';
import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kateringku_mobile/constants/image_path.dart';
import 'package:kateringku_mobile/controllers/auth_controller.dart';
import 'package:kateringku_mobile/models/customer_login_body.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Initially password is obscure
  bool _passwordVisible = true;
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
  }

  void _login() {
    var authController = Get.find<AuthController>();
    String email = _userEmailController.text.trim();
    String password = _userPasswordController.text.trim();
    CustomerLoginBody customerLoginBody =
        CustomerLoginBody(email: email, password: password);
    // print(customerLoginBody.email.toString());
    // print(customerLoginBody.password.toString());
    authController.login(customerLoginBody).then((status) {
      if (status.isSuccess) {
        Get.offNamed(RouteHelper.mainHome);
      } else {
        print("Failed Login ${status.isSuccess}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var authController = Get.find<AuthController>();
    return Scaffold(
      body: Stack(
        children: [
          Align(
            child: SvgPicture.asset(VectorPath.orangeRadial),
            alignment: Alignment.bottomLeft,
          ),
          Align(
            child: SvgPicture.asset(VectorPath.greenRadial),
            alignment: Alignment.topRight,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                          child: Image.asset(
                            ImagePath.kateringkuLogo,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, bottom: 40),
                      child: Text(
                        'Masuk Akun',
                        style: AppTheme.textTheme.titleLarge,
                      ),
                    ),
                  ],
                )
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _userEmailController,
                        decoration: const InputDecoration(hintText: 'Email'),
                        style: AppTheme.textTheme.labelMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _userPasswordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
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
                                  color:
                                      AppTheme.secondaryBlack.withOpacity(0.5),
                                  size: 20,
                                ))),
                        style: AppTheme.textTheme.labelMedium,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Lupa Password?',
                          style: AppTheme.textTheme.labelSmall,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 85, bottom: 15),
                      child: Obx((() => PrimaryButton(
                          title: 'Login',
                          onTap: () {
                            _login();
                          },
                          state: authController.isLoading.value
                              ? ButtonState.loading
                              : ButtonState.idle))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: AppTheme.textTheme.labelMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offNamed(RouteHelper.getRegister());
                          },
                          child: Text(
                            "Registrasi",
                            style: AppTheme.textTheme.labelMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
