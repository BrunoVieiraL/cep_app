import 'package:cep_app/controllers/repository_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../database/database.dart';
import '../models/address_model.dart';

class AddCEPButtonComponent extends StatefulWidget {
  final TextEditingController textController;
  final RepositoryController controller;
  const AddCEPButtonComponent(
      {super.key, required this.textController, required this.controller});

  @override
  State<AddCEPButtonComponent> createState() => _AddCEPButtonComponentState();
}

class _AddCEPButtonComponentState extends State<AddCEPButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
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
              height: 120,
              width: 300,
              child: Column(
                children: [
                  TextField(
                    controller: widget.textController,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Insira um CEP'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String formatCEP =
                          widget.textController.text.replaceAll('-', ''.trim());
                      if (formatCEP.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Insira um CEP'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        if (formatCEP.length > 8 || formatCEP.length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('CEP inv??lido, confira'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          AddressModel infoCep = await widget
                              .controller.repository
                              .getInfo(formatCEP);
                          if (infoCep.cep == null && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('CEP n??o existe'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            widget.textController.clear();
                          } else {
                            var checkExistonDB =
                                await AddressDataBase.instance.getAllCEP();
                            var test = '';
                            for (var i = 0; i < checkExistonDB.length; i++) {
                              test = checkExistonDB
                                  .elementAt(i)
                                  .cep!
                                  .replaceFirst('-', ''.trim());
                            }
                            if (formatCEP == test && mounted) {
                              widget.textController.clear();
                              Get.back();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('CEP j?? adicionado anteriormente'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              AddressDataBase.instance.addAddress(infoCep);
                              widget.textController.clear();
                              Get.back();
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
                    child: const Text('Adicionar CEP ?? Lista de Endere??os'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
