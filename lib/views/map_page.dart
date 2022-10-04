import 'package:cep_app/controllers/geolocator_controller.dart';
import 'package:cep_app/models/address_model.dart';
import 'package:cep_app/repositories/geocode_api_imp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GeolocatorController geolocatorController =
      GeolocatorController(GeocodeApiImp());

  AddressModel args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CEP: ${args.cep!}'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target:
              LatLng(geolocatorController.latCep, geolocatorController.longCep),
          zoom: 20,
        ),
        onMapCreated: geolocatorController.onMapCreated,
        markers: <Marker>{
          Marker(
            markerId: MarkerId('${args.cep}'),
            position: LatLng(
                geolocatorController.latCep, geolocatorController.longCep),
          ),
        },
        onCameraMoveStarted: () {
          setState(() {});
        },
      ),
    );
  }
}
