import '../../entities/api_response.dart';
import '../../entities/user_post.dart';

abstract class GetUserByUserId {
    Future<ApiResponse<List<UserPost>>> getUserByUserId(List<String> userId, String token);
}