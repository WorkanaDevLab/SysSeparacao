// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pedido _$PedidoFromJson(Map<String, dynamic> json) => Pedido(
      PDDS_ID: json['PDDS_ID'] as String?,
      PDDS_CODIGO: json['PDDS_CODIGO'] as String?,
      PESS_FANTAZIA: json['PESS_FANTAZIA'] as String?,
      PDDS_STATUS: json['PDDS_STATUS'] as String?,
      PDDS_PREV_ENTG: json['PDDS_PREV_ENTG'] as String?,
      PDDS_ENTREGA: json['PDDS_ENTREGA'] as String?,
      PDDS_SEPARADOR: json['PDDS_SEPARADOR'] as String?,
      PDHT_STATUS: json['PDHT_STATUS'] as String?,
    );

Map<String, dynamic> _$PedidoToJson(Pedido instance) => <String, dynamic>{
      'PDDS_ID': instance.PDDS_ID,
      'PDDS_CODIGO': instance.PDDS_CODIGO,
      'PESS_FANTAZIA': instance.PESS_FANTAZIA,
      'PDDS_STATUS': instance.PDDS_STATUS,
      'PDDS_PREV_ENTG': instance.PDDS_PREV_ENTG,
      'PDDS_ENTREGA': instance.PDDS_ENTREGA,
      'PDDS_SEPARADOR': instance.PDDS_SEPARADOR,
      'PDHT_STATUS': instance.PDHT_STATUS,
    };
