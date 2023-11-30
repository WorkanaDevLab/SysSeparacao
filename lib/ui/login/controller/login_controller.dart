import 'dart:convert';

import 'package:flutterbase/constants.dart';
import 'package:flutterbase/data/models/unidade_empresarial.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/route/app_screens_name.dart';
import 'package:flutterbase/ui/login/repository/login_repository.dart';
import 'package:flutterbase/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../../data/models/setor.dart';
import '../../../network/response/api_result.dart';

class LoginController extends GetxController {

  final _repository = LoginRepository();
  Utils utils = Utils();

  RxList<UnidadeEmpresarial> unidades = <UnidadeEmpresarial>[].obs;
  RxBool isLoadingUnidades = false.obs;

  RxList<Setor> setor = <Setor>[].obs;
  RxBool isLoadingSetir = false.obs;

  RxList<Usuario> usuarios = <Usuario>[].obs;
  RxBool isLoadingUsuarios = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUnidadesEmpresariais();
    getSetor();
  }

  Future<void> signIn({required String password, required String usuarioId, required UnidadeEmpresarial unem, required Setor setor}) async {
    try {
      final usuario = usuarios.firstWhere((usr) => usr.USRS_ID == usuarioId);
      
      if (usuario.USRS_SENHA == password) {
        await utils.saveLocalData(key: Constants.user, data: jsonEncode(usuario.toJson()));
        await utils.saveLocalData(key: Constants.unem, data: jsonEncode(unem.toJson()));
        await utils.saveLocalData(key: Constants.setor, data: jsonEncode(setor.toJson()));

        Get.offAllNamed(AppScreensNames.main);
      }
    } catch (e) {
      print("Erro ao verificar a senha: $e");
    }
  }

  Future<void> getUnidadesEmpresariais() async {
    isLoadingUnidades.value = true;
    final ApiResult result = await _repository.getUnidadesEmpresariais();
    isLoadingUnidades.value = false;

    result.when(
      success: (list) {
        unidades.value = list;
        update();
      },
      error: (error) {
        print(error);
      },
    );
  }

  Future<void> getSetor() async {
    isLoadingUnidades.value = true;
    final ApiResult result = await _repository.getSetor();
    isLoadingUnidades.value = false;

    result.when(
      success: (list) {
        setor.value = list;
        update();
      },
      error: (error) {
        print(error);
      },
    );
  }

  Future<void> getUsuarios({required String unemId}) async {
    isLoadingUsuarios.value = true;
    final ApiResult result = await _repository.getUsuarios(unemId: unemId);
    isLoadingUsuarios.value = false;

    result.when(
      success: (list) {
        usuarios.value = list;
        update();
      },
      error: (error) {
        print(error);
      },
    );
  }


}