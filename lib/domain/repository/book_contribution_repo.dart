import '../entities/api_response.dart';
import '../entities/book_contribution.dart';

abstract class ContributionBookRepo {
  Future<ApiResponse<ContributionBook>> uploadContributionBook(
      ContributionBook contributionBook, String token);

  Future<ApiResponse<List<ContributionBook>>> getContributionBooks(
      String token);

  Future<ApiResponse<ContributionBook>> getContributionBookByNormalBarcode(
      String normalBarcode, String token);

  Future<ApiResponse<ContributionBook>> getContributionBookByISBNBarcode(
      String isbnBarcode, String token);
}
