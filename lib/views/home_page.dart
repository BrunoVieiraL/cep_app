// ignore_for_file: use_build_context_synchronously

import 'package:cep_app/components/add_cep_button_component.dart';
import 'package:cep_app/components/home_page_body_component.dart';
import 'package:cep_app/controllers/controller.dart';
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
          AddCEPButtonComponent(
              textController: textController, controller: controller),
        ],
      ),
      body: const HomePageBodyComponent(),
    );
  }
}
