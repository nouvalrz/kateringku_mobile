import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kateringku_mobile/controllers/add_address_controller.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../components/primary_button.dart';
import '../../controllers/customer_dashboard_controller.dart';
import '../../routes/route_helper.dart';
import '../../themes/app_theme.dart';
// import '../maps_test/google_maps_view.dart';

class AddAddressMapView extends StatefulWidget {
  const AddAddressMapView({Key? key}) : super(key: key);

  @override
  State<AddAddressMapView> createState() => _AddAddressMapViewState();
}

class _AddAddressMapViewState extends State<AddAddressMapView> {
  LatLng? currentPosition;
  late MapboxMapController mapController;
  var forEditRecommendation = false;

  var addAddressController = Get.put(AddAddressController());
  late CustomerDashboardController customerDashboardController;

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    addAddressController.setIntitalAddress(placemark[0]);
    addAddressController
        .setCenterCoordinate(LatLng(position.latitude, position.longitude));
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    addAddressController = Get.put(AddAddressController());
    _getUserLocation();
    forEditRecommendation =
        Get.arguments != null ? Get.arguments["forEditRecommendation"] : false;
    if (forEditRecommendation) {
      customerDashboardController = Get.find<CustomerDashboardController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Tentukan Pin Lokasi",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child: currentPosition == null
                      ? Center(
                          child: CircularProgressIndicator(
                          color: AppTheme.primaryGreen,
                        ))
                      :
                      // MapSample(currentPosition!)
                      MapboxMap(
                          trackCameraPosition: true,
                          //   onCameraTrackingChanged: (MyLocationTrackingMode k) {
                          //     print("MOVE");
                          //   },
                          //   compassEnabled: true,
                          //   onCameraTrackingDismissed: () {
                          //     print("MOVING");
                          //   },
                          // gestureRecognizers: ,
                          onCameraIdle: () {
                            addAddressController.setCenterCoordinate(
                                mapController!.cameraPosition!.target!);
                          },
                          myLocationEnabled: true,
                          // onUserLocationUpdated: ,
                          onMapCreated: (MapboxMapController controller) {
                            mapController = controller;
                          },
                          // onUserLocationUpdated: (UserLocation userLocation){
                          //   addAddressController.setCenterCoordinate(userLocation.position);
                          //   print("${userLocation.position.longitude} || ${userLocation.position.latitude}");
                          // },
                          initialCameraPosition: CameraPosition(
                              target: currentPosition!, zoom: 15),
                          accessToken:
                              "pk.eyJ1Ijoibm91dmFscnoiLCJhIjoiY2xnamhwdjhyMHI2cDNxbnZ6OW5oc2d0NSJ9.EnL9_Z49uEAmotdB2FGCBA",
                        )),
              SizedBox(
                height: 220,
              )
            ],
          ),
          Align(
            child: SizedBox(
              height: 220,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[350]!)),
                    color: Colors.white),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text("Lokasi Anda",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.pin_drop_outlined,
                            color: Colors.grey[600],
                            size: 30,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Obx(() => addAddressController.isLoading.value
                              ? Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: CircularProgressIndicator(
                                        color: AppTheme.primaryGreen,
                                      )),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  width: 280,
                                  child: Column(
                                    children: [
                                      Text(addAddressController.village,
                                          style: AppTheme.textTheme.titleLarge!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                      Text(
                                          "${addAddressController.district}, ${addAddressController.regency}, ${addAddressController.province}",
                                          style: AppTheme.textTheme.titleLarge!
                                              .copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400)),
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                                title: 'Gunakan Lokasi',
                                onTap: () {
                                  if (forEditRecommendation) {
                                    var currentPosition = Position(
                                        longitude: addAddressController
                                            .centerCoordinate.longitude,
                                        latitude: addAddressController
                                            .centerCoordinate.latitude,
                                        timestamp: DateTime.now(),
                                        accuracy: 0.0,
                                        altitude: 0.0,
                                        heading: 0.0,
                                        speed: 0.0,
                                        speedAccuracy: 0.0);
                                    customerDashboardController
                                        .getAgainRelevantCateringProducts(
                                            currentPosition);
                                    customerDashboardController
                                        .currentCoordinates = currentPosition;
                                    Get.back();
                                  } else {
                                    Get.offNamed(
                                        RouteHelper.getAddAddressDetail(),
                                        arguments: [
                                          addAddressController.centerCoordinate,
                                          addAddressController.village,
                                          addAddressController.district,
                                          addAddressController.regency,
                                          addAddressController.province
                                        ]);
                                  }
                                },
                                state: ButtonState.idle),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    var position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    mapController!.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(
                          position.latitude,
                          position.longitude,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Center(
                        child: Text("Cari Lokasi Saat Ini",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w600))),
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.primaryGreen)),
                  ),
                ),
              ],
            ),
            bottom: 230,
          ),
          Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 88,
                ),
                Expanded(
                    child: Center(
                        child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: currentPosition != null
                      ? Icon(
                          Icons.location_pin,
                          color: AppTheme.primaryGreen,
                          size: 50,
                          shadows: <Shadow>[
                            Shadow(color: Colors.grey, blurRadius: 12.0)
                          ],
                        )
                      : Container(),
                ))),
                SizedBox(
                  height: 220,
                )
              ],
            ),
            alignment: Alignment.center,
          )
        ],
        alignment: Alignment.center,
      ),
    );
  }
}

// class MapSample extends StatefulWidget {
//   LatLng intialPosition;
//
//   MapSample(this.intialPosition);
//
//   @override
//   State<MapSample> createState() => MapSampleState();
//
// }
//
// class MapSampleState extends State<MapSample> {
//   Completer<GoogleMapController> _controller = Completer();
//
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(-8.711665642276632, 115.21433327458034),
//     zoom: 18.4746,
//   );
//
//   static final CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//   var listCenter = <LatLng>[];
//   @override
//   Widget build(BuildContext context) {
//     var addAddressController = Get.find<AddAddressController>();
//     return Container(
//       child: GoogleMap(
//         mapType: MapType.normal,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         initialCameraPosition: CameraPosition(target: widget.intialPosition, zoom: 16),
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         onCameraMove: (CameraPosition cp) {
//           LatLng center = cp.target;
//           listCenter.add(center);
//           print(center);
//         },
//         onCameraIdle: (){
//           print("INI TERAKHIR");
//           print(listCenter.last);
//           addAddressController.setCenterCoordinate(listCenter.last);
//         },
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
