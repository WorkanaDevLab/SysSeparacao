import 'package:flutterbase/network/response/api_result.dart';
import 'package:flutterbase/ui/base/model/post_model.dart';

import '../../../network/app_endpoints.dart';
import '../../../network/http_manager.dart';

class BaseRepository {

  final HttpManager _httpManager = HttpManager();

  Future<ApiResult> getPosts() async {
    final result = await _httpManager.restRequest(
      url: ApiEndPoints.getPosts,
      method: HttpMethods.get,
    );

    if (result != null) {
      List<Post> posts = List<Map<String, dynamic>>.from(result).map(Post.fromJson).toList();
      return ApiResult<List<Post>>.success(posts);
    } else {
      return ApiResult.error('Não foi possível recuperar os pedidos');
    }
  }


}