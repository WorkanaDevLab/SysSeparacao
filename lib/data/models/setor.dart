import 'package:json_annotation/json_annotation.dart';

part 'setor.g.dart';

@JsonSerializable()
class Setor {
  String? SETR_ID;
  String? SETR_NOME;

  Setor({this.SETR_ID, this.SETR_NOME});

  factory Setor.fromJson(Map<String, dynamic> json) => _$SetorFromJson(json);

  Map<String, dynamic> toJson() => _$SetorToJson(this);

}
