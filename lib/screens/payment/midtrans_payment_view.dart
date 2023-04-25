import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/base/show_custom_snackbar.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/data/repositories/order_repo.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../themes/app_theme.dart';
import '../home/home_view.dart';

class MidtransPaymentView extends StatefulWidget {
  const MidtransPaymentView({Key? key}) : super(key: key);

  @override
  State<MidtransPaymentView> createState() => _MidtransPaymentViewState();
}

class _MidtransPaymentViewState extends State<MidtransPaymentView> {

  var orderId;
  var orderRepo = Get.find<OrderRepo>();

  void initState() {
    super.initState();
    var state = Get.arguments!;
    orderId = state[0];
  }

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel("MidtransBack", onMessageReceived: (message){
        var homeController = Get.find<HomeController>();
        homeController.tabController.value.index = 2;
        Get.back();
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          '${AppConstant.BASE_URL_NGROK}customer/preorder/showsnaptoken/$orderId'));

    return WillPopScope(
      onWillPop: () async{
        var response = await orderRepo.getOrderPaidStatus(orderId);
        if(response.body['paid_status'] == "CREATED"){
          showCustomSnackBar(message: "Anda harus pilih metode pembayaran sebelum kembali", title: "Pilih Metode Pembayaran");
          return false;
        }else{
          var homeController = Get.find<HomeController>();
          homeController.tabController.value.index = 2;
          return true;
        }
      },
      child: Scaffold(
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
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Selesaikan Pembayaran",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w600))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(child: WebViewWidget(controller: controller))
              // Expanded(child: child)
            ])
          ],
        ),
      ),
    );
  }
}
