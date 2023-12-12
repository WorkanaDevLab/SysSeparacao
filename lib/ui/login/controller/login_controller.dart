import 'dart:convert';

import 'package:flutterbase/constants.dart';
import 'package:flutterbase/data/models/unidade_empresarial.dart';
import 'package:flutterbase/data/models/usuario.dart';
import 'package:flutterbase/route/app_screens_name.dart';
import 'package:flutterbase/ui/login/repository/login_repository.dart';
import 'package:flutterbase/utils.dart';
import 'package:get/get.dart';
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

  Rx<Usuario?> userLogged = Rx<Usuario?>(null);
  Rx<UnidadeEmpresarial?> unemLogged = Rx<UnidadeEmpresarial?>(null);
  Rx<Setor?> setorLogged = Rx<Setor?>(null);
  RxBool isUserLoggedIn = false.obs;

  RxBool hasError = false.obs;


  @override
  void onInit() {
    super.onInit();
    checkIfUserIsLoggedIn();
  }

  Future<void> logout() async {

    await utils.deleteLocalData(key: Constants.user);
    await utils.deleteLocalData(key: Constants.unem);
    await utils.deleteLocalData(key: Constants.setor);

    isUserLoggedIn.value = false;
    userLogged.value = null;
    unemLogged.value = null;
    setorLogged.value = null;

    Get.offAllNamed('/login');
  }

  void checkIfUserIsLoggedIn() async {
    try {
      String? userJson = await utils.getLocalData(key: Constants.user);

      print(userJson);
      if (userJson != null && userJson.isNotEmpty) {
        Map<String, dynamic> userMap = jsonDecode(userJson);
        userLogged.value = Usuario.fromJson(userMap);
        isUserLoggedIn.value = true;

        String? unemJson = await utils.getLocalData(key: Constants.unem);
        if (unemJson != null && unemJson.isNotEmpty) {
          Map<String, dynamic> unemMap = jsonDecode(unemJson);
          unemLogged.value = UnidadeEmpresarial.fromJson(unemMap);
        }

        String? setorJson = await utils.getLocalData(key: Constants.setor);
        if (setorJson != null && setorJson.isNotEmpty) {
          Map<String, dynamic> setorMap = jsonDecode(setorJson);
          setorLogged.value = Setor.fromJson(setorMap);
        }
      } else {
        isUserLoggedIn.value = false;
      }

      update();
    } catch (e) {
      isUserLoggedIn.value = false;
      print("Erro ao carregar as informações do usuário: $e");
    }
  }

  Future<void> signIn({required String password, required String usuarioId, required UnidadeEmpresarial unem, required Setor setor}) async {
    try {
      final usuario = usuarios.firstWhere((usr) => usr.USRS_ID == usuarioId);

      if (usuario.USRS_SENHA == password) {
        await utils.saveLocalData(key: Constants.user, data: jsonEncode(usuario.toJson()));
        await utils.saveLocalData(key: Constants.unem, data: jsonEncode(unem.toJson()));
        await utils.saveLocalData(key: Constants.setor, data: jsonEncode(setor.toJson()));

        userLogged.value = usuario;
        unemLogged.value = unem;
        setorLogged.value = setor;

        update();

        Get.offAllNamed(AppScreensNames.main);
      } else {
        utils.showToast(message: "Usuário ou senha não conferem, tente novamente.", isError: true);
      }
    } catch (e) {
      print("Erro ao verificar a senha: $e");
      utils.showToast(message: "Ocorreu um erro interno, tente novamente.", isError: true);
    }
  }

  Future<void> getUnidadesEmpresariais() async {
    isLoadingUnidades.value = true;
    final ApiResult result = await _repository.getUnidadesEmpresariais();
    isLoadingUnidades.value = false;

    result.when(
      success: (list) {
        unidades.value = list;
      },
      error: (error) {
        hasError.value = true;
      },
    );

    update();
  }

  Future<void> getSetor() async {
    isLoadingUnidades.value = true;
    final ApiResult result = await _repository.getSetor();
    isLoadingUnidades.value = false;

    result.when(
      success: (list) {
        setor.value = list;
      },
      error: (error) {
        hasError.value = true;
      },
    );

    update();
  }

  Future<void> getUsuarios({required String unemId}) async {
    isLoadingUsuarios.value = true;
    final ApiResult result = await _repository.getUsuarios(unemId: unemId);
    isLoadingUsuarios.value = false;

    result.when(
      success: (list) {
        usuarios.value = list;
      },
      error: (error) {
        hasError.value = true;
      },
    );

    update();
  }

}