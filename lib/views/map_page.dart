import 'package:cep_app/controllers/geolocator_controller.dart';
import 'package:cep_app/models/address_model.dart';
import 'package:cep_app/models/directions_model.dart';
import 'package:cep_app/repositories/geocode_api_imp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../repositories/directions_repository.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GeolocatorController geolocatorController =
      GeolocatorController(GeocodeApiImp());
  AddressModel args = Get.arguments;

  Directions? info;

  @override
  Widget build(BuildContext context) {
    Marker origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'Origem'),
      position:
          LatLng(geolocatorController.userLat, geolocatorController.userLong),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    Marker destination = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'Destino'),
      position:
          LatLng(geolocatorController.latCep, geolocatorController.longCep),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('CEP: ${args.cep!} '),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target:
              LatLng(geolocatorController.latCep, geolocatorController.longCep),
          zoom: 20,
        ),
        onMapCreated: geolocatorController.onMapCreated,
        markers: <Marker>{
          origin,
          destination,
        },
        polylines: <Polyline>{
          if (info != null)
            Polyline(
              polylineId: const PolylineId('overview_polyline'),
              color: Colors.red,
              width: 5,
              points: info!.polylinePoints
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList(),
            ),
        },
        onCameraMoveStarted: () async {
          setState(() {});
          final directions = await DirectionsRepository().getDirections(
              origin: origin.position, destination: destination.position);
          info = directions;
          setState(() {});
        },
      ),
    );
  }
}
