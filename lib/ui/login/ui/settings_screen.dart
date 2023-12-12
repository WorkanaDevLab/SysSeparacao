import 'package:flutter/material.dart';
import 'package:flutterbase/components/custombutton.dart';
import 'package:flutterbase/components/customtextfield.dart';
import 'package:flutterbase/constants.dart';
import 'package:flutterbase/network/app_endpoints.dart';
import 'package:flutterbase/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final GlobalKey<FormState> _globalKey = GlobalKey();
  TextEditingController urlController = TextEditingController();
  Utils utils = Utils();

  String? currentUrl;

  Future<bool> checkConnection(String url) async {
    try {
      final response = await http.get(Uri.parse('$url/getUnidadesEmpresariais'));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  Future<String> getCurrentUrl() async {
    try {
      return await utils.getLocalData(key: Constants.BASE_URL) ?? "http://52.4.98.235:9986";
    } catch (e) {
      return "http://52.4.98.235:9986";
    }
  }

  @override void initState() {
    super.initState();
    getUrlBase();
  }

  getUrlBase() async {
    await getCurrentUrl().then((value) {
      setState(() {
        currentUrl = value;
      });
    }).catchError((e) {
      currentUrl = "http://52.4.98.235:9986";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CONFIGURAÇÃO"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              CustomTextField(controller: urlController, labelText: "Digite a nova URL", validator: (url) {
                if(url!.isEmpty) return "Preencha a URL.";
                if(!url.isURL) return "Preencha uma URL válida";
                return null;
              },),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Text("Endereco atual: $currentUrl"),
                ],
              ),
              const SizedBox(height: 16,),
              CustomButton(onTap: () async {
                if(_globalKey.currentState!.validate()) {

                  final newUrl = urlController.text;
                  final isConnectionSuccessful = await checkConnection(newUrl);

                  if (isConnectionSuccessful) {
                    utils.saveLocalData(key: Constants.BASE_URL, data: urlController.text);
                    utils.showToast(message: "URL atualizada com sucesso!", isError: false);

                    setState(() {
                      currentUrl = newUrl;
                    });

                  } else {
                    utils.showToast(message: "Falha no teste de conexão com a URL inserida, verifique a URL e tente novamente.", isError: true);
                  }

                }
              }, buttonText: "Atualizar endereço", color: Colors.blue)
            ],
          ),
        ),
      ),
    );
  }
}
