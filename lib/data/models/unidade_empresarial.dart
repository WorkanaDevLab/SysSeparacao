import 'package:json_annotation/json_annotation.dart';

part 'unidade_empresarial.g.dart';

@JsonSerializable()
class UnidadeEmpresarial {
  String? unem_Fantasia;
  String? unem_Id;
  String? unem_Sigla;

  UnidadeEmpresarial({this.unem_Fantasia, this.unem_Id, this.unem_Sigla});

  factory UnidadeEmpresarial.fromJson(Map<String, dynamic> json) => _$UnidadeEmpresarialFromJson(json);

  Map<String, dynamic> toJson() => _$UnidadeEmpresarialToJson(this);

  @override
  String toString() {
    return 'UnidadeEmpresarial{unem_Fantasia: $unem_Fantasia, unem_Id: $unem_Id, unem_Sigla: $unem_Sigla}';
  }

}
