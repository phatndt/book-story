import '../../entities/api_response.dart';
import '../../entities/book_contribution.dart';

abstract class GetContributionBookByNormalBarcodeUseCase {
  Future<ApiResponse<ContributionBook>> getContributionBookByNormalBarcode(
      String normalBarcode, String token);
}
