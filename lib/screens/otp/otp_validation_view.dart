import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/base/show_custom_snackbar.dart';
import 'package:kateringku_mobile/components/primary_button.dart';
import 'package:kateringku_mobile/controllers/otp_validation_controller.dart';
import 'package:kateringku_mobile/models/otp_validation_body.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

import '../../constants/vector_path.dart';

class OtpValidationView extends StatefulWidget {
  String email;
  String password;

  OtpValidationView({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<OtpValidationView> createState() => _OtpValidationViewState();
}

class _OtpValidationViewState extends State<OtpValidationView> {
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();

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
      Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verifikasi Emailmu',
              style: AppTheme.textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Masukan 4 digit kode yang dikirimkan di',
                style: AppTheme.textTheme.labelMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                widget.email,
                style: AppTheme.textTheme.labelMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: pin1,
                      decoration: const InputDecoration(),
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: pin2,
                      decoration: const InputDecoration(),
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(),
                      controller: pin3,
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: pin4,
                        decoration: const InputDecoration(),
                        inputFormatters: [LengthLimitingTextInputFormatter(1)],
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        }),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 220),
              child: PrimaryButton(
                  title: 'Lanjutkan',
                  onTap: () {
                    var otpValidationController =
                        Get.find<OtpValidationController>();
                    var pin = "";
                    pin = pin + pin1.text.trim();
                    pin = pin + pin2.text.trim();
                    pin = pin + pin3.text.trim();
                    pin = pin + pin4.text.trim();
                    OtpValidationBody otpValidationBody = OtpValidationBody(
                        otp: pin,
                        email: widget.email,
                        password: widget.password);
                    otpValidationController
                        .validate(otpValidationBody)
                        .then((status) {
                      if (status.isSuccess) {
                        showCustomSnackBar(
                            message: "OTP Validation is success",
                            title: "SUCCESS");
                      } else {
                        showCustomSnackBar(message: status.message);
                      }
                    });
                  }),
            ),
          ],
        ),
      )
    ]));
  }
}
