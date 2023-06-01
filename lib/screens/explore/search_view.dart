import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/controllers/search_controller.dart';
import 'package:kateringku_mobile/models/catering_display_model.dart';
import 'package:kateringku_mobile/screens/dashboard/dashboard_view.dart';

import '../../themes/app_theme.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  var searchController = Get.find<SearchController>();
  String? districtName;
  String? keyword;

  @override
  void initState() {
    keyword = Get.arguments!['keyword'];
    districtName = Get.arguments!['district_name'];
    searchController.searchTextController.text = keyword!;
    searchController.getSearchResult(keyword!, districtName!);
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
                Text("Hasil Pencarian",
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w600))
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 25, right: 25),
          child: SizedBox(
            child: TextFormField(
                controller: searchController.searchTextController,
                onFieldSubmitted: (value) {
                  searchController.getSearchResult(value, districtName!);
                },
                decoration: InputDecoration(
                    hintText: "Mau cari apa?",
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: AppTheme.secondaryBlack.withOpacity(0.7),
                    ))),
            height: 46,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Expanded(child: Obx(() {
          if (searchController.isLoading.value) {
            return Center(
                child: CircularProgressIndicator(
              color: AppTheme.primaryGreen,
            ));
          } else {
            if (searchController.cateringResult.isEmpty) {
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
                          cateringRate:
                              searchController.cateringResult[index].rate,
                          fromSearch: true,
                          cateringDisplayModel:
                              searchController.cateringResult[index],
                          cateringLatitude: double.parse(
                              searchController.cateringResult[index].latitude!),
                          cateringLongitude: double.parse(searchController
                              .cateringResult[index].longitude!),
                          cateringImage:
                              searchController.cateringResult[index].image!,
                          cateringName:
                              searchController.cateringResult[index].name!,
                          cateringCategory: searchController
                              .cateringResult[index]
                              .mergeCategories(),
                          cateringLocation: searchController
                              .cateringResult[index].village!.name!.capitalize!,
                          categorySalesCount: 234,
                          bestProductCatering1: searchController
                              .cateringResult[index]
                              .recommendationProducts![0]
                              .name!,
                          bestProductCatering2: searchController
                                  .cateringResult[index].recommendationProducts!
                                  .asMap()
                                  .containsKey(1)
                              ? searchController.cateringResult[index]
                                  .recommendationProducts![1].name
                              : null,
                          bestProductCateringPrice1: searchController
                              .cateringResult[index]
                              .recommendationProducts![0]
                              .price!,
                          bestProductCateringPrice2: searchController
                                  .cateringResult[index].recommendationProducts!
                                  .asMap()
                                  .containsKey(1)
                              ? searchController.cateringResult[index]
                                  .recommendationProducts![1].price
                              : null,
                          bestProductCateringImage1: searchController
                              .cateringResult[index]
                              .recommendationProducts![0]
                              .image!,
                          bestProductCateringImage2: searchController
                                  .cateringResult[index].recommendationProducts!
                                  .asMap()
                                  .containsKey(1)
                              ? searchController.cateringResult[index]
                                  .recommendationProducts![1].image
                              : null,
                          cateringId: searchController.cateringResult[index].id
                              .toString(),
                        ));
                  },
                  itemCount: searchController.cateringResult.length,
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
