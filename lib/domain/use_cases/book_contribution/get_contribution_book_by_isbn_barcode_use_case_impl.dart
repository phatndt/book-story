import 'package:book_story/domain/entities/book_contribution.dart';
import 'package:book_story/domain/entities/api_response.dart';
import 'package:book_story/domain/repository/book_contribution_repo.dart';
import 'package:book_story/domain/use_cases/book_contribution/get_contribution_book_by_isbn_barcode_use_case.dart';

class GetContributionBookByISBNBarcodeUseCaseImpl
    extends GetContributionBookByISBNBarcodeUseCase {
  final ContributionBookRepo _contributionBookRepo;

  GetContributionBookByISBNBarcodeUseCaseImpl(this._contributionBookRepo);

  @override
  Future<ApiResponse<ContributionBook>> getContributionBookByISBNBarcode(
      String isbnBarcode, String token) async {
    return await _contributionBookRepo.getContributionBookByISBNBarcode(
        isbnBarcode, token);
  }
}
