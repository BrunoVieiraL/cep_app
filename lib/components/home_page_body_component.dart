import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/address_model.dart';

class HomePageBodyComponent extends StatefulWidget {
  const HomePageBodyComponent({super.key});

  @override
  State<HomePageBodyComponent> createState() => _HomePageBodyComponentState();
}

class _HomePageBodyComponentState extends State<HomePageBodyComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: AddressDataBase.instance.getAllCEP(),
          builder: (context, AsyncSnapshot<List<AddressModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                heightFactor: 20,
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data!.isEmpty
                ? const Center(
                    heightFactor: 10,
                    child: Text(
                      'Nenhum CEP Adicionado',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => snapshot.data!.map(
                      (address) {
                        return ListTile(
                          leading: Text(address.uf!),
                          title: Text(address.cep!),
                          subtitle: Text(address.logradouro!),
                          trailing: Text(address.bairro!),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/mapsPage', arguments: address);
                          },
                          onLongPress: () {
                            AddressDataBase.instance
                                .deleteAddress(address.cep!);
                            setState(() {});
                          },
                        );
                      },
                    ).elementAt(index),
                  );
          },
        ),
      ],
    );
  }
}
