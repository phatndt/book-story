import 'package:book_exchange/domain/entities/book_contribution.dart';

import 'package:book_exchange/domain/entities/api_response.dart';

import '../../repository/book_contribution_repo.dart';
import 'get_contribution_book_by_normal_barcode_use_case.dart';

class GetContributionBookByNormalBarcodeUseCaseImpl
    extends GetContributionBookByNormalBarcodeUseCase {
  final ContributionBookRepo _contributionBookRepo;

  GetContributionBookByNormalBarcodeUseCaseImpl(this._contributionBookRepo);

  @override
  Future<ApiResponse<ContributionBook>> getContributionBookByNormalBarcode(
      String normalBarcode, String token)  {
    return _contributionBookRepo.getContributionBookByNormalBarcode(
        normalBarcode, token);
  }
}
