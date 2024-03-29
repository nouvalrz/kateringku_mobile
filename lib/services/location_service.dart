import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:kateringku_mobile/models/address_model.dart';

class LocationService extends GetConnect implements GetxService {
  Future<Position> getCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // Return object from Position Class
    return await Geolocator.getCurrentPosition();
  }

  Future<AddressModel> getAddressFromCoordinates(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];

    List<String> localityList = placemark[0].locality!.split(" ");
    String localityFinal =
        localityList.sublist(1, localityList.length).join(" ");
    var address = placemark[0].street! + " " + placemark[0].subLocality!;

    return AddressModel(
        address: address,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        districtName: place.locality!.replaceAll("Kecamatan", ""),
        villageName: place.subLocality);
  }

  Future<Response> getDistanceFromCoordinates(
      {required double cateringLatitude,
      required double cateringLongitude,
      required double customerLatitude,
      required double customerLongitude}) async {
    Response response = await get(
        "https://api.mapbox.com/directions/v5/mapbox/driving/${customerLongitude},${customerLatitude};${cateringLongitude},${cateringLatitude}?access_token=pk.eyJ1Ijoibm91dmFscnoiLCJhIjoiY2xnamhwdjhyMHI2cDNxbnZ6OW5oc2d0NSJ9.EnL9_Z49uEAmotdB2FGCBA");
    return response;
  }
}
