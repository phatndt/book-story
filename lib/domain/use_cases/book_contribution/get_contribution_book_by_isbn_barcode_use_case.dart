import 'package:book_story/domain/entities/api_response.dart';
import 'package:book_story/domain/entities/book_contribution.dart';

abstract class GetContributionBookByISBNBarcodeUseCase {
  Future<ApiResponse<ContributionBook>> getContributionBookByISBNBarcode(
      String isbnBarcode, String token);
}
