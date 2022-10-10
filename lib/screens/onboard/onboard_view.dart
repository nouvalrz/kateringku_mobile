import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kateringku_mobile/components/primary_button.dart';
// ignore: unused_import
import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:kateringku_mobile/constants/image_path.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

class OnboardView extends StatelessWidget {
  const OnboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            child: Transform.scale(
              child: SvgPicture.asset(VectorPath.orangeRadial),
              scaleX: -1,
            ),
            alignment: Alignment.bottomRight,
          ),
          Align(
            child: Transform.scale(
              child: SvgPicture.asset(VectorPath.greenRadial),
              scaleX: -1,
            ),
            alignment: Alignment.topLeft,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 14, 0),
              child: Image.asset(
                ImagePath.kateringkuLogo,
                height: 100,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 120),
                    child: Image.asset(
                      ImagePath.welcomeIllustration,
                      height: 220,
                    ),
                  ),
                ],
              ),
              Image.asset(ImagePath.gradientBlurSeparator),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 30, right: 40),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Selamat datang di',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: AppTheme.primaryBlack,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'KateringKu',
                          style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 38,
                              color: AppTheme.primaryBlack,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 70, 0, 10),
                      child: PrimaryButton(title: 'Login', onTap: () {}),
                    ),
                    PrimaryButton(
                      title: "Register",
                      onTap: () {},
                      color: const Color.fromARGB(0, 108, 19, 19),
                      titleStyle: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: AppTheme.primaryBlack,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        ],
      ),
    );
  }
}
