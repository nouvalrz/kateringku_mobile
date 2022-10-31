import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Stack(children: [
            Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.75,
                child: Container(color: AppTheme.primaryGreen),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.75 - 20.0,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ]),
            Align(
              child: Transform.scale(
                child: SvgPicture.asset(
                  VectorPath.orangeRadial,
                ),
                scaleY: -1,
                scaleX: -1,
              ),
              alignment: Alignment.topRight,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, right: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 46),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lokasi anda",
                              style: AppTheme.textTheme.labelSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.map_outlined,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      "Jl. Bypass Ngurah Rai No. 120",
                                      style: AppTheme.textTheme.labelMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "Mau cari apa?",
                              prefixIcon: Icon(
                                Icons.search_outlined,
                                color: AppTheme.secondaryBlack.withOpacity(0.7),
                              ))),
                      height: 46,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Kategori",
                      style: AppTheme.textTheme.labelMedium!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
