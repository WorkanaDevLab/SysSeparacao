import 'package:flutter/cupertino.dart';
import 'package:flutterbase/constants.dart';
import 'package:flutterbase/data/models/item_pedido.dart';
import 'package:flutterbase/ui/login/controller/login_controller.dart';
import 'package:flutterbase/ui/login/repository/main_repository.dart';
import 'package:get/get.dart';

import '../../../data/models/itens_lidos.dart';
import '../../../data/models/pedido.dart';
import '../../../network/response/api_result.dart';
import '../../../utils.dart';

class MainController extends GetxController {
  LoginController loginController = Get.find<LoginController>();
  final _repository = MainRepository();
  Utils utils = Utils();

  TextEditingController selectedProdutoName = TextEditingController();
  TextEditingController selectedProdutoEndereco = TextEditingController();

  RxList<ItemPedido> itemsList = <ItemPedido>[].obs;
  RxBool isLoadingItens = false.obs;

  RxList<Pedido> pedidos = <Pedido>[].obs;
  RxBool isLoadingPedidos = false.obs;

  RxBool isLoadingSyncItens = false.obs;

  Rx<Pedido?> pedidoSelected = Pedido().obs;
  Rx<ItemPedido> itemPedidoSelected = ItemPedido().obs;
  List<ItemLido> itensModificados = [];

  Future<Pedido?> validateCode(String? codigoPedido) async {
    if (codigoPedido == null || codigoPedido.isEmpty) {
      if (pedidos.isNotEmpty) {
        pedidoSelected.value = pedidos.first;
        return pedidoSelected.value;
      } else {
        return Pedido();
      }
    }

    final existePedido =
        pedidos.where((pedido) => pedido.PDDS_CODIGO == codigoPedido);

    if (existePedido.isNotEmpty) {
      pedidoSelected.value = existePedido.first;
      return pedidoSelected.value;
    }

    return Pedido();
  }

  void adicionarOuAtualizarItemModificado(ItemLido item) {
    int index = itensModificados.indexWhere((it) => it.itpdId == item.itpdId);
    if (index != -1) {
      itensModificados[index] = item;
    } else {
      itensModificados.add(item);
    }
  }

  Future<void> incrementarQuantidadeConferida(String codigoItem,
      {bool showMessage = true}) async {
    if (codigoItem.length > 12) {
      codigoItem = codigoItem.substring(7, 12);
    }

    final itemPedido = itemsList.firstWhereOrNull(
          (item) => item.PROD_CODIGO == codigoItem ||
          item.PROD_CODIGO1 == codigoItem ||
          item.PROD_CODIGO2 == codigoItem ||
          item.PROD_CODIGO3 == codigoItem ||
          item.PROD_CODIGO4 == codigoItem,
    );

    if (itemPedido != null) {
      itemPedidoSelected.value = itemPedido;
      selectedProdutoName.text = itemPedidoSelected.value.PROD_NOME!;
      selectedProdutoEndereco.text = itemPedidoSelected.value.PROD_ENDERECO!;
    }

    if (itemPedido != null &&
        int.tryParse(itemPedido.ITPD_QTD_CONFERIDO!)! <
            int.tryParse(itemPedido.ITPD_QTDE!)!) {
      itemPedido.ITPD_QTD_CONFERIDO =
          (int.tryParse(itemPedido.ITPD_QTD_CONFERIDO!)! + 1).toString();

      int index = itemsList.indexOf(itemPedido);
      itemsList[index] = itemPedido;
      adicionarOuAtualizarItemModificado(ItemLido(
          itpdId: itemPedido.ITPD_ID,
          itpdQtdConf: itemPedido.ITPD_QTD_CONFERIDO,
          usrsId: loginController.userLogged.value!.USRS_ID!));
    } else {
      if (showMessage) {
        utils.showToast(
            message: "Item não encontrado ou já totalmente conferido.",
            isError: true);
      }
    }

    update();
  }

  Future<void> postSaveItens() async {
    if (itensModificados.isEmpty) {
      utils.showToast(
          message: "Nenhum item para sincronizar no momento.", isError: true);
      return;
    }

    isLoadingSyncItens.value = true;
    bool result =
        await _repository.setGravaConferencia(itens: itensModificados);
    isLoadingSyncItens.value = false;

    if (result) {
      utils.showToast(message: "Dados salvos com sucesso!", isError: false);

      for (var itemModificado in itensModificados) {
        itemsList.removeWhere((item) => item.ITPD_ID == itemModificado.itpdId);
      }

      pedidoSelected.value = Pedido();
      itensModificados.clear();
      itemsList.clear();
      selectedProdutoEndereco.text = "";
      selectedProdutoName.text = "";
      itemPedidoSelected.value = ItemPedido();

      update();
    } else {
      utils.showToast(
          message:
              "Ocorreu um erro ao realizar ao gravar os dados, tente novamente.",
          isError: true);
    }
  }

  Future<void> getPedidos({required String codigoPedido}) async {
    isLoadingPedidos.value = true;

    final ApiResult result = await _repository.getPedidos(
        unemID: loginController.unemLogged.value!.unem_Id!,
        codigoPedido: codigoPedido);
    isLoadingPedidos.value = false;

    print("RESULTADO DOS PEDIDOS");
    print(result);

    result.when(
      success: (list) async {
        pedidos.value = list;

        if (codigoPedido.isNotEmpty) {
          Pedido? pedidoValidado = await validateCode(codigoPedido);
          if (pedidoValidado != null && pedidoValidado.PDDS_ID != null) {
            pedidoSelected.value = pedidoValidado;
          } else {
            utils.showToast(
                message: "Código do pedido inválido ou não encontrado.",
                isError: true);
            return;
          }
        } else if (pedidos.isNotEmpty) {
          pedidoSelected.value = pedidos.first;
        } else {
          pedidoSelected.value = Pedido();
          utils.showToast(message: "Nenhum pedido encontrado.", isError: true);
          return;
        }

        await getItensPedidos(
            pddsID: pedidoSelected.value!.PDDS_ID!,
            setorID: loginController.setorLogged.value!.SETR_ID!);
      },
      error: (error) {
        isLoadingPedidos.value = false;
        utils.showToast(
            message:
                "Ocorreu um erro ao realizar a busca da lista de pedidos, tente novamente.",
            isError: true);
      },
    );

    update();
  }

  Future<void> getItensPedidos(
      {required String pddsID, required String setorID}) async {
    isLoadingItens.value = true;
    final ApiResult result =
        await _repository.getItensPedidos(pddsID: pddsID, setorID: setorID);
    isLoadingItens.value = false;

    result.when(
      success: (list) {
        itemsList.value = list;
      },
      error: (error) {
        utils.showToast(
            message:
                "Ocorreu um erro ao realizar a busca da lista de itens, tente novamente.",
            isError: true);
      },
    );

    update();
  }

  Future<void> setReiniciaConferencia({required String pddsID}) async {
    isLoadingItens.value = true;
    final dynamic result =
        await _repository.setReiniciaConferencia(pddsID: pddsID);
    isLoadingItens.value = false;

    if (result != null) {

      selectedProdutoName.text = "";
      selectedProdutoEndereco.text = "";
      itemPedidoSelected.value = ItemPedido();

      await getItensPedidos(
          pddsID: pedidoSelected.value!.PDDS_ID!,
          setorID: loginController.setorLogged.value!.SETR_ID!);
    } else {
      utils.showToast(
          message: "Erro ao reiniciar a conferência.", isError: true);
    }

    update();
  }

  Future<void> setCancelaConferencia({required String pddsID}) async {
    isLoadingItens.value = true;
    final dynamic result =
        await _repository.setCancelaConferencia(pddsID: pddsID);
    isLoadingItens.value = false;

    print(result);
    if (result != null) {
      itemsList.clear();
      pedidoSelected.value = Pedido();
      selectedProdutoEndereco.text = "";
      selectedProdutoName.text = "";
      itemPedidoSelected.value = ItemPedido();

      utils.showToast(
          message: "Conferência cancelada com sucesso.", isError: false);
    } else {
      utils.showToast(
          message: "Erro ao cancelar a conferência.", isError: true);
    }

    update();
  }

  Future<void> recarregarItensPedidos() async {
    if (pedidoSelected.value?.PDDS_ID == null) {
      return;
    }

    isLoadingItens.value = true;
    final ApiResult result = await _repository.getItensPedidos(
        pddsID: pedidoSelected.value!.PDDS_ID!,
        setorID: loginController.setorLogged.value!.SETR_ID!);
    isLoadingItens.value = false;

    result.when(
      success: (novosItens) {
        for (var item in novosItens) {
          int index = itemsList.indexWhere((it) => it.ITPD_ID == item.ITPD_ID);
          if (index != -1) {
            itemsList[index] = item;
          } else {
            itemsList.add(item);
          }
        }
        utils.showToast(
            message: "Itens carregados com sucesso.", isError: false);
      },
      error: (error) {
        utils.showToast(
            message: "Erro ao recarregar a lista de itens, tente novamente.", isError: true);
      },
    );

    update();
  }

}
