import 'package:book_exchange/domain/entities/book_contribution.dart';

import '../../entities/api_response.dart';

abstract class UploadContributionBookUseCase {
  Future<ApiResponse<ContributionBook>> uploadContributionBook(
      ContributionBook contributionBook, String token);
}
