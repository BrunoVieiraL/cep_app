import 'package:cep_app/models/address_model.dart';
import 'package:flutter/material.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AddressModel args =
        ModalRoute.of(context)!.settings.arguments as AddressModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('CEP: ${args.cep!}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
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
