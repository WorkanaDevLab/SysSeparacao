import 'package:flutterbase/network/response/api_result.dart';
import 'package:flutterbase/ui/base/model/post_model.dart';
import 'package:flutterbase/ui/base/repository/base_repository.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {

  final _repository = BaseRepository();

  RxList<Post> posts = <Post>[].obs;
  RxBool isLoadingPosts = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPosts();
  }

  Future<void> getPosts() async {
    isLoadingPosts.value = true;
    final ApiResult result = await _repository.getPosts();
    isLoadingPosts.value = false;

    result.when(
      success: (list) {
        posts.value = list;
        update();
      },
      error: (error) {
        print(error);
      },
    );
  }


}