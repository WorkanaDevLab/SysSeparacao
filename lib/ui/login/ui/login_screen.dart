import 'package:flutter/material.dart';
import 'package:flutterbase/components/custom_dropdown_unidade.dart';
import 'package:flutterbase/components/custom_dropdown_usuario.dart';
import 'package:flutterbase/components/custombutton.dart';
import 'package:flutterbase/components/customtextfield.dart';
import 'package:flutterbase/data/models/setor.dart';
import 'package:flutterbase/data/models/unidade_empresarial.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/route/app_screens_name.dart';
import 'package:flutterbase/ui/login/controller/login_controller.dart';
import 'package:flutterbase/utils.dart';
import 'package:get/get.dart';

import '../../../components/custom_dropdown_setor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Utils utils = Utils();

  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController passwordController = TextEditingController();

  UnidadeEmpresarial? _selectedUnidade;
  Setor? _selectedSetor;
  Usuario? _selectedUsuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("SYS SEPARAÇÃO"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AppScreensNames.settings);
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "REALIZAR LOGIN",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black45,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GetBuilder<LoginController>(
                builder: (controller) {
                  if (controller.isLoadingUnidades.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return CustomDropdownUnidade(
                      options: controller.unidades,
                      onChanged: (selected) {
                        setState(() {
                          _selectedUnidade = controller.unidades.firstWhere(
                                  (un) => un.unem_Id == selected!.unem_Id,
                              orElse: () => UnidadeEmpresarial());
                          controller.getUsuarios(
                              unemId: _selectedUnidade!.unem_Id!);
                        });
                      },
                      selectedOption: _selectedUnidade,
                    );
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              GetBuilder<LoginController>(
                builder: (controller) {
                  if (controller.isLoadingUsuarios.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return CustomDropdownUsuario(
                      options: controller.usuarios,
                      onChanged: (selected) {
                        setState(() {
                          _selectedUsuario = controller.usuarios.firstWhere(
                                  (un) => un.USRS_ID == selected!.USRS_ID,
                              orElse: () => Usuario());
                        });
                      },
                      selectedOption: _selectedUsuario,
                    );
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              GetBuilder<LoginController>(
                builder: (controller) {
                  if (controller.isLoadingSetir.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return CustomDropdownSetor(
                      options: controller.setor,
                      onChanged: (selected) {
                        setState(() {
                          _selectedSetor = controller.setor.firstWhere(
                                  (un) => un.SETR_ID == selected!.SETR_ID,
                              orElse: () => Setor());
                        });
                      },
                      selectedOption: _selectedSetor,
                    );
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextField(
                controller: TextEditingController(),
                labelText: "Senha",
                isSecret: true,
                validator: (password) {
                  if (password!.isEmpty) return "Por favor preencha a senha.";
                  return null;
                },
                prefixIcon: Icons.lock,
              ),
              const SizedBox(
                height: 8,
              ),
              GetBuilder<LoginController>(builder: (controller) {
                return Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                            onTap: () {

                              Get.toNamed(AppScreensNames.main);
                              /*
                              if (_formKey.currentState!.validate()) {
                                if(_selectedUsuario != null && _selectedUnidade != null && _selectedSetor != null) {
                                  controller.signIn(
                                      password: passwordController.text.trim(),
                                      usuarioId: _selectedUsuario!.USRS_ID!,
                                      unem: _selectedUnidade!,
                                      setor: _selectedSetor!);
                                } else {
                                  utils.showToast(message: "Preencha todas as informações.", isError: true);
                                }
                              }

                               */
                            }, buttonText: "LOGIN", color: Colors.blue)),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
