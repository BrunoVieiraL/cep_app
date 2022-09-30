import 'package:cep_app/controllers/controller.dart';
import 'package:cep_app/database/database.dart';
import 'package:cep_app/models/address_model.dart';
import 'package:cep_app/repositories/via_cep_api_imp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final controller = Controller(ViaCepApiImp());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Column(
                        children: [
                          TextField(
                            controller: textController,
                            decoration: const InputDecoration(
                              label: Text('Insira um CEP'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (textController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Insira um CEP'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                if (textController.text.length > 8 ||
                                    textController.text.length < 8) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('CEP inválido, confira'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else {
                                  AddressModel infoCep = await controller
                                      .repository
                                      .getCepInfo(textController.text);
                                  if (infoCep.cep == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('CEP não existe'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    textController.clear();
                                  } else {
                                    var cepExist = await AddressDataBase
                                        .instance
                                        .getCEP(infoCep.cep!);
                                    var cepOnDB = cepExist
                                        .elementAt(0)
                                        .cep!
                                        .replaceFirst('-', ''.trim());

                                    if (textController.text == cepOnDB) {
                                      Get.toNamed('/listAddressPage');
                                      textController.clear();
                                    } else {
                                      AddressDataBase.instance
                                          .addAddress(infoCep);
                                      Get.toNamed('/listAddressPage');
                                      textController.clear();
                                    }
                                  }
                                }
                              }
                            },
                            child: const Text(
                                'Adicionar CEP à Lista de Endereços'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: AddressDataBase.instance.getAllCEP(),
              builder: (context, AsyncSnapshot<List<AddressModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      children: const [
                        Text('Carregando lista de CEPs'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
                return snapshot.data!.isEmpty
                    ? const Center(
                        heightFactor: 25,
                        child: Text(
                          'Nenhuma CEP Adicionado',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.map(
                          (address) {
                            return ListTile(
                              leading: Text(address.uf!),
                              title: Text(address.cep!),
                              subtitle: Text(address.logradouro!),
                              trailing: Text(address.bairro!),
                              onTap: () {
                                Get.toNamed('/mapPage', arguments: address);
                              },
                              onLongPress: () {
                                AddressDataBase.instance
                                    .deleteAddress(address.cep!);
                              },
                            );
                          },
                        ).toList(),
                      );
              },
            ),
          ],
        ));
  }
}
