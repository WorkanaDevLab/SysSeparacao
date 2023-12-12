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

  @override
  void onInit() {
    super.onInit();
    getPedidos(
        unemID: int.tryParse(loginController.unemLogged.value!.unem_Id!)!);
  }

  RxList<ItemPedido> itemsList = <ItemPedido>[].obs;
  RxBool isLoadingItens = false.obs;

  RxList<Pedido> pedidos = <Pedido>[].obs;
  RxBool isLoadingPedidos = false.obs;

  RxBool isLoadingSyncItens = false.obs;

  Rx<Pedido?> pedidoSelected = Pedido().obs;
  Rx<ItemPedido> itemPedidoSelected = ItemPedido().obs;
  List<ItemLido> itensModificados = [];

  Future<Pedido?> validateCode(String? codigoPedido) async {
    // Verifica se o código do pedido não foi informado
    if (codigoPedido == null || codigoPedido.isEmpty) {
      // Se a lista de pedidos não estiver vazia, atribua o primeiro pedido
      if (pedidos.isNotEmpty) {
        pedidoSelected.value = pedidos.first;
        return pedidoSelected.value;
      } else {
        // Se a lista de pedidos estiver vazia, retorna falso
        return Pedido();
      }
    }

    // Continuação do código original para buscar pelo código
    final existePedido =
    pedidos.where((pedido) => pedido.PDDS_ID == codigoPedido);

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

  Future<void> incrementarQuantidadeConferida(String codigoItem, {bool showMessage = true}) async {
    final itemPedido = itemsList.firstWhereOrNull(
      (item) => item.ITPD_ID == codigoItem,
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
      if(showMessage) {
        utils.showToast(
          message: "Item não encontrado ou já totalmente conferido.",
          isError: true);
      }
    }

    update();
  }

  Future<void> postSaveItens() async {

    if(itensModificados.isEmpty) {
      utils.showToast(
          message:
          "Nenhum item para sincronizar no momento.",
          isError: true);
      return;
    }

    isLoadingSyncItens.value = true;
    bool result =
        await _repository.setGravaConferencia(itens: itensModificados);
    isLoadingSyncItens.value = false;

    if(result) {
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

  Future<void> getPedidos({required int unemID}) async {
    isLoadingPedidos.value = true;
    final ApiResult result = await _repository.getPedidos(unemID: unemID);
    isLoadingPedidos.value = false;

    result.when(
      success: (list) {
        pedidos.value = list;
        update();
      },
      error: (error) {
        utils.showToast(
            message:
                "Ocorreu um erro ao realizar a busca da lista de pedidos, tente novamente.",
            isError: true);
      },
    );
  }

  Future<void> getItensPedidos(
      {required int pddsID, required int setorID}) async {
    isLoadingItens.value = true;
    final ApiResult result =
        await _repository.getItensPedidos(pddsID: pddsID, setorID: setorID);
    isLoadingItens.value = false;

    result.when(
      success: (list) {
        itemsList.value = list;
        update();
      },
      error: (error) {
        utils.showToast(
            message:
                "Ocorreu um erro ao realizar a busca da lista de itens, tente novamente.",
            isError: true);
      },
    );
  }
}