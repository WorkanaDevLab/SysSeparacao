import 'package:json_annotation/json_annotation.dart';

part 'usuario.g.dart';

@JsonSerializable()
class Usuario {
  String? USRS_ID;
  String? USRS_LOGIN;
  String? USRS_SENHA;

  Usuario({this.USRS_ID, this.USRS_LOGIN, this.USRS_SENHA});

  factory Usuario.fromJson(Map<String, dynamic> json) => _$UsuarioFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);

  @override
  String toString() {
    return 'Usuario{USRS_ID: $USRS_ID, USRS_LOGIN: $USRS_LOGIN, USRS_SENHA: $USRS_SENHA}';
  }

}
