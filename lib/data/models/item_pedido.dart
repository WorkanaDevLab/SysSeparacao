import 'package:json_annotation/json_annotation.dart';

part 'item_pedido.g.dart';

@JsonSerializable()
class ItemPedido {
  String? ITPD_ID;
  String? ITPD_QTDE;
  String? ITPD_QTD_CONFERIDO;
  String? PROD_ID;
  String? PROD_CODIGO;
  String? PROD_NOME;
  String? PROD_ENDERECO;
  String? SETR_NOME;

  ItemPedido(
      {this.ITPD_ID,
        this.ITPD_QTDE,
        this.ITPD_QTD_CONFERIDO,
        this.PROD_ID,
        this.PROD_CODIGO,
        this.PROD_NOME,
        this.PROD_ENDERECO,
        this.SETR_NOME});

  factory ItemPedido.fromJson(Map<String, dynamic> json) => _$ItemPedidoFromJson(json);

  Map<String, dynamic> toJson() => _$ItemPedidoToJson(this);

  @override
  String toString() {
    return 'ItemPedido{ITPD_ID: $ITPD_ID, ITPD_QTDE: $ITPD_QTDE, ITPD_QTD_CONFERIDO: $ITPD_QTD_CONFERIDO, PROD_ID: $PROD_ID, PROD_CODIGO: $PROD_CODIGO, PROD_NOME: $PROD_NOME, PROD_ENDERECO: $PROD_ENDERECO, SETR_NOME: $SETR_NOME}';
  }

}
