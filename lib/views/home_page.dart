// ignore_for_file: use_build_context_synchronously

import 'package:cep_app/controllers/controller.dart';
import 'package:cep_app/database/database.dart';
import 'package:cep_app/models/address_model.dart';
import 'package:cep_app/repositories/via_cep_api_imp.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Controller(ViaCepApiImp());

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Row(
              children: const [
                Text('Adicionar CEP'),
                Icon(Icons.add),
              ],
            ),
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
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Insira um CEP'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String formatCEP =
                                textController.text.replaceAll('-', ''.trim());

                            print('FormtCEP: $formatCEP');
                            print('TextController: ${textController.text}');
                            if (formatCEP.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Insira um CEP'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              if (formatCEP.length > 8 ||
                                  formatCEP.length < 8) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('CEP inválido, confira'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                AddressModel infoCep = await controller
                                    .repository
                                    .getCepInfo(formatCEP);
                                print('INFOCEP: ${infoCep.cep}');
                                if (infoCep.cep == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('CEP não existe'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  textController.clear();
                                } else {
                                  var checkExistonDB = await AddressDataBase
                                      .instance
                                      .getAllCEP();
                                  var test = '';
                                  for (var i = 0;
                                      i < checkExistonDB.length;
                                      i++) {
                                    test = checkExistonDB
                                        .elementAt(i)
                                        .cep!
                                        .replaceFirst('-', ''.trim());
                                  }
                                  if (formatCEP == test) {
                                    textController.clear();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'CEP já adicionado anteriormente'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    AddressDataBase.instance
                                        .addAddress(infoCep);
                                    textController.clear();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('CEP Adicionado a lista'),
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                    setState(() {});
                                  }
                                }
                              }
                            }
                          },
                          child:
                              const Text('Adicionar CEP à Lista de Endereços'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
                        'Nenhum CEP Adicionado',
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
                              Navigator.of(context)
                                  .pushNamed('/mapPage', arguments: address);
                            },
                            onLongPress: () {
                              AddressDataBase.instance
                                  .deleteAddress(address.cep!);
                              setState(() {});
                            },
                          );
                        },
                      ).toList(),
                    );
            },
          ),
        ],
      ),
    );
  }
}
