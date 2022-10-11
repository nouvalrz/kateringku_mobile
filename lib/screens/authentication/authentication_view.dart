import 'package:flutter/material.dart';
import 'package:kateringku_mobile/components/primary_button.dart';
import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kateringku_mobile/constants/image_path.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  // Initially password is obscure
  bool _passwordVisible = true;
  final TextEditingController _userPasswordController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
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
                      child: TextField(
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
                      child: PrimaryButton(title: 'Login', onTap: () {}),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: AppTheme.textTheme.labelMedium,
                        ),
                        Text(
                          "Registrasi",
                          style: AppTheme.textTheme.labelMedium!
                              .copyWith(fontWeight: FontWeight.w600),
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
