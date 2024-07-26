import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressController extends GetxController{
  late LatLng centerCoordinate;
  var village = "";
  var district = "";
  var regency = "";
  var province = "";
  var isLoading = true.obs;

  void setCenterCoordinate(LatLng center){
    centerCoordinate = center;
    print("DARI CONTROLLER");
    print(centerCoordinate);
    getAddressFromLatLang(center);
  }

  void o

  Future<void> getAddressFromLatLang(LatLng latLng) async {
    isLoading.value = true;
    List<Placemark> placemark =
    await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = placemark[0];
    village = place.subLocality!;
    district = place.locality!;
    regency = place.subAdministrativeArea!;
    province = place.administrativeArea!;
    print("DARI CONTROLLER");
    print(placemark[0]);
    isLoading.value = false;
  }

  void setIntitalAddress(Placemark place){
    isLoading.value = true;
    village = place.subLocality!;
    district = place.locality!;
    regency = place.subAdministrativeArea!;
    province = place.administrativeArea!;
    isLoading.value = false;
    print(village + district +  regency + province);
  }



}