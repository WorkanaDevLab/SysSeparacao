// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_pedido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemPedido _$ItemPedidoFromJson(Map<String, dynamic> json) => ItemPedido(
      ITPD_ID: json['ITPD_ID'] as String?,
      ITPD_QTDE: json['ITPD_QTDE'] as String?,
      ITPD_QTD_CONFERIDO: json['ITPD_QTD_CONFERIDO'] as String?,
      PROD_ID: json['PROD_ID'] as String?,
      PROD_CODIGO: json['PROD_CODIGO'] as String?,
      PROD_NOME: json['PROD_NOME'] as String?,
      PROD_ENDERECO: json['PROD_ENDERECO'] as String?,
      SETR_NOME: json['SETR_NOME'] as String?,
    );

Map<String, dynamic> _$ItemPedidoToJson(ItemPedido instance) =>
    <String, dynamic>{
      'ITPD_ID': instance.ITPD_ID,
      'ITPD_QTDE': instance.ITPD_QTDE,
      'ITPD_QTD_CONFERIDO': instance.ITPD_QTD_CONFERIDO,
      'PROD_ID': instance.PROD_ID,
      'PROD_CODIGO': instance.PROD_CODIGO,
      'PROD_NOME': instance.PROD_NOME,
      'PROD_ENDERECO': instance.PROD_ENDERECO,
      'SETR_NOME': instance.SETR_NOME,
    };
