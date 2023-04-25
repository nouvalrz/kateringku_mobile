import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../themes/app_theme.dart';

class CateringReviewView extends StatefulWidget {
  const CateringReviewView({Key? key}) : super(key: key);

  @override
  State<CateringReviewView> createState() => _CateringReviewViewState();
}

class _CateringReviewViewState extends State<CateringReviewView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: 10,
              child: Container(
                color: Colors.grey[200],
                width: 600,
              ),
            ),
            top: 90,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ulasan dan Rating",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          Text("Vegan Food Nayla",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ]),
        ],
      ),
    );
  }
}
