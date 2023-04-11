import 'package:book_exchange/domain/entities/book_contribution.dart';

import 'package:book_exchange/domain/entities/api_response.dart';

import '../../repository/book_contribution_repo.dart';
import 'upload_contribution_book_use_case.dart';

class UploadContributionBookUseCaseImpl extends UploadContributionBookUseCase {
  final ContributionBookRepo _contributionBookRepo;

  UploadContributionBookUseCaseImpl(this._contributionBookRepo);

  @override
  Future<ApiResponse<ContributionBook>> uploadContributionBook(
      ContributionBook contributionBook, String token) async {
    return await _contributionBookRepo.uploadContributionBook(
        contributionBook, token);
  }
}
