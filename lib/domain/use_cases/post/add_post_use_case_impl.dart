import 'package:book_exchange/domain/entities/post.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/post_repo.dart';
import 'package:book_exchange/domain/use_cases/post/add_post_use_case.dart';

class AddPostUseCaseImpl extends AddPostUseCase {
  final PostRepo _postRepo;

  AddPostUseCaseImpl(this._postRepo);

  @override
  Future<ApiResponse<String>> createPost(Post post, String token) {
    return _postRepo.createPost(post, token);
  }
}
