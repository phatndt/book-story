import 'package:book_exchange/domain/entities/post.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/post_repo.dart';
import 'package:book_exchange/domain/use_cases/post/get_my_post_use_case.dart';

class GetMyPostUseCaseImpl extends GetMyPostUseCase {
  final PostRepo _postRepo;

  GetMyPostUseCaseImpl(this._postRepo);

  @override
  Future<ApiResponse<List<Post>>> getMyPost(String token) {
    return _postRepo.getMyPost(token);
  }
}
