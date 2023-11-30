import 'package:json_annotation/json_annotation.dart';

part 'pedido.g.dart';

@JsonSerializable()
class Pedido {
  String? PDDS_ID;
  String? PDDS_CODIGO;
  String? PESS_FANTAZIA;
  String? PDDS_STATUS;
  String? PDDS_PREV_ENTG;
  String? PDDS_ENTREGA;
  String? PDDS_SEPARADOR;
  String? PDHT_STATUS;

  Pedido(
      {this.PDDS_ID,
        this.PDDS_CODIGO,
        this.PESS_FANTAZIA,
        this.PDDS_STATUS,
        this.PDDS_PREV_ENTG,
        this.PDDS_ENTREGA,
        this.PDDS_SEPARADOR,
        this.PDHT_STATUS});

  factory Pedido.fromJson(Map<String, dynamic> json) => _$PedidoFromJson(json);

  Map<String, dynamic> toJson() => _$PedidoToJson(this);



}
