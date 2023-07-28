import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/controllers/category_controller.dart';
import 'package:kateringku_mobile/controllers/search_controller.dart';
import 'package:kateringku_mobile/models/catering_display_model.dart';
import 'package:kateringku_mobile/screens/dashboard/dashboard_view.dart';

import '../../themes/app_theme.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  var categoryController = Get.find<CategoryController>();
  String? districtName;
  String? keyword;
  double? customerLatitude;
  double? customerLongitude;

  @override
  void initState() {
    keyword = Get.arguments!['keyword'];
    districtName = Get.arguments!['district_name'];
    customerLatitude = double.parse(Get.arguments!['customer_latitude']);
    customerLongitude = double.parse(Get.arguments!['customer_longitude']);
    categoryController.getCategoryResult(
        keyword!, districtName!, customerLatitude!, customerLongitude!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
          child: Container(
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kategori " + keyword!,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 4,
                    ),
                    Text("Hasil Pencarian",
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 11, fontWeight: FontWeight.w400)),
                  ],
                )
              ],
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 12, left: 25, right: 25),
        //   child: SizedBox(
        //     child: TextFormField(
        //         controller: searchController.searchTextController,
        //         onFieldSubmitted: (value){
        //           searchController.getSearchResult(value, districtName!);
        //         },
        //         decoration: InputDecoration(
        //             hintText: "Mau cari apa?",
        //             prefixIcon: Icon(
        //               Icons.search_outlined,
        //               color: AppTheme.secondaryBlack.withOpacity(0.7),
        //             ))),
        //     height: 46,
        //   ),
        // ),
        SizedBox(
          height: 6,
        ),
        Expanded(child: Obx(() {
          if (categoryController.isLoading.value) {
            return Center(
                child: CircularProgressIndicator(
              color: AppTheme.primaryGreen,
            ));
          } else {
            if (categoryController.cateringResult.isEmpty) {
              return Center(
                child: Text("Produk tidak ditemukan!",
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
              );
            } else {
              return SingleChildScrollView(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: DashboardProductCard(
                          cateringDistance: categoryController
                              .cateringResult[index].distance!,
                          cateringRate:
                              categoryController.cateringResult[index].rate,
                          fromSearch: true,
                          cateringDisplayModel:
                              categoryController.cateringResult[index],
                          cateringLatitude: double.parse(categoryController
                              .cateringResult[index].latitude!),
                          cateringLongitude: double.parse(categoryController
                              .cateringResult[index].longitude!),
                          cateringImage:
                              categoryController.cateringResult[index].image!,
                          cateringName:
                              categoryController.cateringResult[index].name!,
                          cateringCategory: categoryController
                              .cateringResult[index]
                              .mergeCategories(),
                          cateringLocation: categoryController
                              .cateringResult[index].village!.name!.capitalize!,
                          categorySalesCount: 234,
                          bestProductCatering1: categoryController
                              .cateringResult[index]
                              .recommendationProducts![0]
                              .name!,
                          bestProductCatering2: categoryController
                                  .cateringResult[index].recommendationProducts!
                                  .asMap()
                                  .containsKey(1)
                              ? categoryController.cateringResult[index]
                                  .recommendationProducts![1].name
                              : null,
                          bestProductCateringPrice1: categoryController
                              .cateringResult[index]
                              .recommendationProducts![0]
                              .price!,
                          bestProductCateringPrice2: categoryController
                                  .cateringResult[index].recommendationProducts!
                                  .asMap()
                                  .containsKey(1)
                              ? categoryController.cateringResult[index]
                                  .recommendationProducts![1].price
                              : null,
                          bestProductCateringImage1: categoryController
                              .cateringResult[index]
                              .recommendationProducts![0]
                              .image!,
                          bestProductCateringImage2: categoryController
                                  .cateringResult[index].recommendationProducts!
                                  .asMap()
                                  .containsKey(1)
                              ? categoryController.cateringResult[index]
                                  .recommendationProducts![1].image
                              : null,
                          cateringId: categoryController
                              .cateringResult[index].id
                              .toString(),
                        ));
                  },
                  itemCount: categoryController.cateringResult.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 12),
                ),
              );
            }
          }
        }))
      ]),
    ]));
  }
}
