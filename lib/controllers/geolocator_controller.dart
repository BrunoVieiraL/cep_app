import 'package:cep_app/repositories/geocode_api_imp.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/address_model.dart';
import '../models/geocode_model.dart';

class GeolocatorController extends ChangeNotifier {
  final GeocodeApiImp geocodeApiImp;
  String error = '';
  double latCep = 0.0;
  double longCep = 0.0;
  double userLat = 0.0;
  double userLong = 0.0;

  late GoogleMapController googleMapController;
  AddressModel args = Get.arguments;

  GeolocatorController(this.geocodeApiImp);

  get mapsController => googleMapController;

  onMapCreated(GoogleMapController mapController) async {
    googleMapController = mapController;
    getPosition();
  }

  getPosition() async {
    try {
      GeocodeModel geocode = await geocodeApiImp.getInfo(args.cep!);
      Location geocodeLocation =
          geocode.results!.elementAt(0).geometry!.location as Location;
      latCep = geocodeLocation.lat!;
      longCep = geocodeLocation.lng!;
      googleMapController
          .animateCamera(CameraUpdate.newLatLng(LatLng(latCep, longCep)));
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<Position> currentPosition() async {
    LocationPermission permission;
    bool isAuth = await Geolocator.isLocationServiceEnabled();
    if (!isAuth) {
      return Future.error('Habilite a localização no smartphone');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Autorize o acesso a localização');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Future.error('Autorize o acesso a localização');
    }
    return await Geolocator.getCurrentPosition();
  }
}
