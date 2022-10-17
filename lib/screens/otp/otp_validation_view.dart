import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kateringku_mobile/components/primary_button.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

import '../../constants/vector_path.dart';

class OtpValidationView extends StatefulWidget {
  String email;

  OtpValidationView({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpValidationView> createState() => _OtpValidationViewState();
}

class _OtpValidationViewState extends State<OtpValidationView> {
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
                      decoration: const InputDecoration(),
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(),
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(),
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(),
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 220),
              child: PrimaryButton(title: 'Lanjutkan', onTap: () {}),
            ),
          ],
        ),
      )
    ]));
  }
}
