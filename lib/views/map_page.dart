import 'package:cep_app/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AddressModel args = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('CEP: ${args.cep!}'),
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed('/homePage');
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Column(
        children: const [],
      ),
    );
  }
}
