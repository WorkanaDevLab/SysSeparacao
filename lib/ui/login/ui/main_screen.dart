import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbase/components/customtextfield.dart';
import 'package:flutterbase/ui/login/controller/login_controller.dart';
import 'package:flutterbase/ui/login/controller/main_controller.dart';
import 'package:flutterbase/utils.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainController mainController = Get.find<MainController>();
  LoginController loginController = Get.find<LoginController>();
  TextEditingController codeController = TextEditingController();
  TextEditingController produtoController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey();
  final GlobalKey<FormState> _produtoKey = GlobalKey();
  Utils utils = Utils();

  TextInputType currentKeyboardType = TextInputType.number;

  late FocusNode codeFocusNode = FocusNode();
  late FocusNode productFocusNode = FocusNode();

  Timer? _debounce;
  Timer? _debounceCode;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    codeFocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    codeFocusNode.dispose();
    productFocusNode.dispose();
  }

  void _onCodeChange(String value) {
    _debounceCode?.cancel();
    _debounceCode = Timer(const Duration(milliseconds: 500), () async {
      await mainController.getPedidos(codigoPedido: codeController.text);
    });
  }

  Future<void> _saveItems() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      await mainController.postSaveItens();
      clearControllers();
    } catch (e) {
      // Handle error if needed
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
                accountName: Text("SYS SEPARAÇÃO"), accountEmail: Text("")),
            GetBuilder<MainController>(builder: (logic) {
              if (logic.pedidoSelected.value != null &&
                  logic.pedidoSelected.value?.PDDS_ID != null &&
                  logic.pedidoSelected.value?.PDDS_ID != "") {
                return Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        await mainController.setReiniciaConferencia(
                            pddsID: logic.pedidoSelected.value!.PDDS_ID!);
                        clearControllers();

                        Get.back();
                      },
                      title: const Text("Reiniciar conferência"),
                    ),
                    ListTile(
                      onTap: () async {
                        await mainController.setCancelaConferencia(
                            pddsID: logic.pedidoSelected.value!.PDDS_ID!);
                        clearControllers();
                        Get.back();
                      },
                      title: const Text("Cancelar conferência"),
                    ),
                    ListTile(
                      onTap: () async {
                        await mainController.recarregarItensPedidos();
                        Get.back();
                      },
                      title: const Text("Carregar códigos antigos"),
                    ),
                  ],
                );
              }

              return Container();
            }),
            ListTile(
              onTap: () async {
                await loginController.logout();
              },
              title: const Text("Sair"),
            ),
            Expanded(child: Container()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                    "versão 1.0.5",
                    style: TextStyle(color: Colors.grey),
                  )),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("SYSSEPARAÇÃO"),
        backgroundColor: Colors.blue,
        actions: [
          GetBuilder<MainController>(builder: (controller) {
            if (controller.itemsList.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("0/0"),
                ),
              );
            }

            int index = controller.itemsList
                .indexOf(controller.itemPedidoSelected.value);

            if (index == -1) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Item não selecionado"),
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${index + 1}/${controller.itemsList.length}"),
                ),
              );
            }
          })
        ],
      ),
      body: Column(
        children: [
          GetBuilder<MainController>(builder: (logic) {
            if (logic.pedidoSelected.value != null &&
                logic.pedidoSelected.value?.PDDS_ID != null &&
                logic.pedidoSelected.value?.PDDS_ID != "") {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(logic.pedidoSelected.value!.PESS_FANTAZIA!),
                        Text(
                            "PEDIDO: ${logic.pedidoSelected.value!.PDDS_CODIGO!}"),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Container();
          }),
          GetBuilder<MainController>(builder: (logic) {
            if (logic.itemsList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _globalKey,
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                            focusNode: codeFocusNode,
                            controller: codeController,
                            labelText: "Informe o código do pedido",
                            keyboardType: TextInputType.number,
                            validator: (code) {
                              return null;
                            },
                            onChanged: _onCodeChange,
                            onFieldSubmitted: (value) async {
                              await mainController.getPedidos(
                                  codigoPedido: codeController.text);
                              productFocusNode.requestFocus();
                            },
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      GetBuilder<MainController>(builder: (logic) {
                        return FloatingActionButton(
                          onPressed: () async {
                            if (_globalKey.currentState!.validate()) {
                              await mainController.getPedidos(
                                  codigoPedido: codeController.text);
                              productFocusNode.requestFocus();
                            }
                          },
                          child: const Icon(Icons.check),
                        );
                      })
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _produtoKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: CustomTextField(
                              focusNode: productFocusNode,
                              controller: produtoController,
                              labelText: "Produto",
                              keyboardType: currentKeyboardType,
                              validator: (code) {
                                if (code!.isEmpty) {
                                  return "Por favor, preencha o código do produto";
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                _debounce?.cancel();

                                _debounce = Timer(const Duration(milliseconds: 500),
                                        () {
                                      mainController.incrementarQuantidadeConferida(
                                          produtoController.text,
                                          showMessage: true);
                                      produtoController.clear();
                                      productFocusNode.requestFocus();
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                    });
                              },
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        GetBuilder<MainController>(builder: (logic) {
                          return FloatingActionButton(
                            onPressed: () async {
                              mainController.incrementarQuantidadeConferida(
                                  produtoController.text);
                              produtoController.clear();

                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              productFocusNode.requestFocus();
                            },
                            child: const Icon(Icons.search),
                          );
                        }),
                        const SizedBox(
                          width: 8,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              if (currentKeyboardType ==
                                  TextInputType.number) {
                                currentKeyboardType = TextInputType.none;
                              } else {
                                currentKeyboardType = TextInputType.number;
                              }

                              if (productFocusNode.hasFocus) {
                                productFocusNode.unfocus();
                                Future.delayed(const Duration(milliseconds: 100),
                                        () {
                                      productFocusNode.requestFocus();
                                    });
                              }
                            });
                          },
                          backgroundColor:
                          currentKeyboardType == TextInputType.number
                              ? Colors.green
                              : Colors.grey,
                          child: const Icon(Icons.keyboard),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GetBuilder<MainController>(builder: (logic) {
                          return FloatingActionButton(
                            backgroundColor: Colors.green,
                            onPressed: isSaving ? null : _saveItems,
                            child: isSaving
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : const Icon(Icons.save),
                          );
                        })
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Produto: ",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(logic.selectedProdutoName.text),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Endereço: ",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(logic.selectedProdutoEndereco.text),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Separar: ",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                logic.itemPedidoSelected.value.ITPD_QTDE != null
                                    ? Text(logic.itemPedidoSelected.value
                                    .ITPD_QTDE!)
                                    : const Text("0"),
                              ],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Conferida: ",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                logic.itemPedidoSelected.value
                                    .ITPD_QTD_CONFERIDO !=
                                    null
                                    ? Text(logic.itemPedidoSelected.value
                                    .ITPD_QTD_CONFERIDO!)
                                    : const Text("0"),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const Divider(),
          const Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Código do produto",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ))),
              Expanded(
                  flex: 4,
                  child: Center(
                      child: Text(
                        "Nome",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
            ],
          ),
          GetBuilder<MainController>(builder: (controller) {
            if (controller.isLoadingItens.value) {
              return const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }

            if (controller.itemsList.isEmpty) {
              return Container();
            }

            return Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: controller.itemsList.length,
                  itemBuilder: (context, index) {
                    final item = controller.itemsList[index];

                    Color? cardColor =
                    (item.ITPD_QTD_CONFERIDO == item.ITPD_QTDE)
                        ? Colors.green[100]
                        : Colors.white;

                    return Card(
                      color: cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 2,
                                child: Center(child: Text(item.PROD_CODIGO!))),
                            Flexible(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.PROD_NOME!.trim(),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item.PROD_ENDERECO!.trim()),
                                        Row(
                                          children: [
                                            Center(
                                                child: Text(
                                                    "Qntd: ${item.ITPD_QTDE!.toString()}")),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Center(
                                                child: Text(
                                                    "Conferido: ${item.ITPD_QTD_CONFERIDO!.toString()}")),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          })
        ],
      ),
    );
  }

  void clearControllers() {
    produtoController.clear();
    codeController.clear();
    produtoController.clear();
  }
}
