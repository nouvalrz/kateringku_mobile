import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kateringku_mobile/constants/image_path.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
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
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userPasswordConfirmationController =
      TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPhone = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
    _passwordConfirmationVisible = false;
  }

  void _registration() {
    String name = _userName.text.trim();
    String email = _userEmail.text.trim();
    String phone = _userPhone.text.trim();
    String password = _userPasswordController.text.trim();
    String passwordConfirmation =
        _userPasswordConfirmationController.text.trim();

    if (name.isEmpty) {
    } else if (email.isEmpty) {
    } else if (!email.isEmail) {
    } else if (phone.isEmpty) {
    } else if (password.isEmpty) {
    } else if (passwordConfirmation.isEmpty) {
    } else if (!(password == passwordConfirmation)) {}
  }

  @override
  Widget build(BuildContext context) {
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40, bottom: 20, top: 90),
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
                            controller: _userName,
                            decoration:
                                const InputDecoration(hintText: 'Nama Lengkap'),
                            style: AppTheme.textTheme.labelMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            controller: _userEmail,
                            decoration:
                                const InputDecoration(hintText: 'Email'),
                            style: AppTheme.textTheme.labelMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            controller: _userPhone,
                            decoration: const InputDecoration(
                                hintText: 'Nomer Telepon'),
                            style: AppTheme.textTheme.labelMedium,
                          ),
                        ),
                        passwordInput(),
                        passwordConfirmationInput(),
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 120),
                          child: PrimaryButton(
                              title: 'Daftar Sekarang',
                              onTap: () {
                                Get.toNamed(RouteHelper.getOtpValidation(
                                    "anjay@gmail.com"));
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ]),
    );
  }

  Padding passwordInput() {
    return Padding(
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
                  color: AppTheme.secondaryBlack.withOpacity(0.5),
                  size: 20,
                ))),
        style: AppTheme.textTheme.labelMedium,
      ),
    );
  }

  Padding passwordConfirmationInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _userPasswordConfirmationController,
        obscureText: !_passwordConfirmationVisible,
        decoration: InputDecoration(
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
