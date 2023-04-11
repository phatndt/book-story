import 'package:book_exchange/domain/entities/post.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/post_repo.dart';
import 'package:book_exchange/domain/use_cases/post/get_all_post_use_case.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:intl/intl.dart';

class GetAllPostUseCaseImpl extends GetAllPostUseCase {
  final PostRepo _postRepo;

  GetAllPostUseCaseImpl(this._postRepo);

  @override
  Future<ApiResponse<List<Post>>> getAllPost(String token) {
    return _postRepo.getAllPost(token).then((value) async {
      DateFormat format = DateFormat("yyyy-MM-dd");
      final list = value.data
          .takeWhile((value) => value.id != BookAppModel.user.id)
          .toList();
      list.sort(
        (a, b) => DateTime.fromMillisecondsSinceEpoch(int.parse(b.createDate))
            .compareTo(
                DateTime.fromMillisecondsSinceEpoch(int.parse(a.createDate))),
      );
      return ApiResponse(
          data: list, statusCode: value.statusCode, message: value.message);
    });
  }
}
