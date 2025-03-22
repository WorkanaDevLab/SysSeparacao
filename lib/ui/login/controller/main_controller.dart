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

  Future<void> enviarItemModificado(ItemLido item) async {
    bool result = await _repository.setGravaConferencia(itens: [item]);

    if (result) {
      utils.showToast(message: "Item ${item.itpdId} sincronizado com sucesso!",
          isError: false);
    } else {
      utils.showToast(
          message: "Ocorreu um erro ao gravar o item ${item
              .itpdId}, tente novamente.",
          isError: true);
    }
  }

  void marcarItemComoEdicao(String itemId) async {
    int indexItemsList = itemsList.indexWhere((item) => item.ITPD_ID == itemId);
    if (indexItemsList != -1) {
      var item = itemsList[indexItemsList];
      item.ITPD_EDICAO = (!(item.ITPD_EDICAO == "True") ? "True" : "False");
      itemsList[indexItemsList] = item;
    }

    int indexItensModificados = itensModificados.indexWhere((it) =>
    it.itpdId == itemId);
    ItemLido itemModificado;
    if (indexItensModificados != -1) {
      var item = itensModificados[indexItensModificados];
      item.edicao = (!(item.edicao == "True") ? "True" : "False");
      item.itpdQtdConf = itemsList
          .firstWhere((it) => it.ITPD_ID == itemId)
          .ITPD_QTD_CONFERIDO;
      item.usrsId = loginController.userLogged.value!.USRS_ID!;
      itensModificados[indexItensModificados] = item;
      itemModificado = item;
    } else {
      var itemFromList = itemsList.firstWhere((it) => it.ITPD_ID == itemId);
      itemModificado = ItemLido(
        itpdId: itemId,
        edicao: "True",
        itpdQtdConf: itemFromList.ITPD_QTD_CONFERIDO,
        usrsId: loginController.userLogged.value!.USRS_ID!,
      );
      itensModificados.add(itemModificado);
    }

    await enviarItemModificado(itemModificado);

    update();
  }

  Future<void> incrementarQuantidadeConferida(String codigoItem,
      {bool showMessage = true}) async {
    if (codigoItem.length > 12) {
      codigoItem = codigoItem.substring(7, 12);
    }

    List<ItemPedido> itemsWithSameCode = itemsList.where((item) => item.PROD_CODIGO == codigoItem).toList();

    bool anyItemNotFullyConferred = itemsWithSameCode.any((item) =>
    int.tryParse(item.ITPD_QTD_CONFERIDO!)! < int.tryParse(item.ITPD_QTDE!)!);

    if (anyItemNotFullyConferred) {
      ItemPedido itemToIncrement = itemsWithSameCode.firstWhere((item) =>
      int.tryParse(item.ITPD_QTD_CONFERIDO!)! < int.tryParse(item.ITPD_QTDE!)!);
      itemToIncrement.ITPD_QTD_CONFERIDO =
          (int.tryParse(itemToIncrement.ITPD_QTD_CONFERIDO!)! + 1).toString();

      adicionarOuAtualizarItemModificado(ItemLido(
          itpdId: itemToIncrement.ITPD_ID,
          itpdQtdConf: itemToIncrement.ITPD_QTD_CONFERIDO,
          usrsId: loginController.userLogged.value!.USRS_ID!));

      await _repository.setGravaConferencia(itens: [ItemLido(
          itpdId: itemToIncrement.ITPD_ID,
          itpdQtdConf: itemToIncrement.ITPD_QTD_CONFERIDO,
          usrsId: loginController.userLogged.value!.USRS_ID!)]);

      // Remover e adicionar novamente o item para movê-lo para o final da lista
      itemsList.remove(itemToIncrement);
      itemsList.add(itemToIncrement);
    } else {
      if (showMessage) {
        utils.showToast(
            message: "Item não encontrado ou já totalmente conferido.",
            isError: true);
      }
    }

    // Verifica se todos os itens foram conferidos
    bool allItemsConferred = itemsList.every((item) =>
    int.tryParse(item.ITPD_QTD_CONFERIDO!)! >= int.tryParse(item.ITPD_QTDE!)!);

    if (allItemsConferred) {
      await postSaveItens();
      clearController();
    }

    update();
  }

  void clearController() {
    pedidoSelected.value = Pedido();
    itensModificados.clear();
    itemsList.clear();
    selectedProdutoEndereco.text = "";
    selectedProdutoName.text = "";
    itemPedidoSelected.value = ItemPedido();
  }

  Future<void> postSaveItens() async {
    if (itensModificados.isEmpty) {
      utils.showToast(
          message: "Nenhum item para sincronizar no momento.",
          isError: true
      );
      clear();
      return;
    }

    isLoadingSyncItens.value = true;

    for (var itemModificado in itensModificados) {
      bool result = await _repository.setGravaConferencia(itens: [itemModificado]);

      if (result) {
        itemsList.removeWhere((item) => item.ITPD_ID == itemModificado.itpdId);
      } else {
        utils.showToast(
            message: "Ocorreu um erro ao gravar o item ${itemModificado.itpdId}, tente novamente.",
            isError: true
        );
        break;
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }

    isLoadingSyncItens.value = false;

    clear();
    utils.showToast(
        message: "Todos os itens foram sincronizados com sucesso!",
        isError: false
    );

    update();
  }

  void clear() {
    pedidoSelected.value = Pedido();
    itensModificados.clear();
    itemsList.clear();
    selectedProdutoEndereco.text = "";
    selectedProdutoName.text = "";
    itemPedidoSelected.value = ItemPedido();
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
            message: "Erro ao recarregar a lista de itens, tente novamente.",
            isError: true);
      },
    );

    update();
  }

}
