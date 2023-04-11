import 'package:book_exchange/data/services/book_contribution_service.dart';
import 'package:book_exchange/domain/entities/book_contribution.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/book_contribution_repo.dart';

import '../mapper/book_contribution_mapper.dart';

class ContributionBookRepoImpl extends ContributionBookRepo {
  final ContributionBookService _contributionBookService;

  ContributionBookRepoImpl(this._contributionBookService);

  @override
  Future<ApiResponse<ContributionBook>> uploadContributionBook(
      ContributionBook contributionBook, String token) async {
    return await _contributionBookService
        .uploadContributionBook(contributionBook, token)
        .then(
          (value) => ApiResponseContributionBookMapper().transfer(value),
        );
  }

  //   Future<ApiResponse<String>> uploadContributionBook(
  //     ContributionBook contributionBook, String token) async {
  //   return await _contributionBookService
  //       .uploadContributionBook(contributionBook, token)
  //       .then(
  //         (value) => ApiResponseContributionBookMapper().transferId(value),
  //       );
  // }

  @override
  Future<ApiResponse<ContributionBook>> getContributionBookByISBNBarcode(
      String isbnBarcode, String token) async {
    return await _contributionBookService
        .getContributionBookByISBNBarcode(isbnBarcode, token)
        .then(
          (value) => ApiResponseContributionBookMapper().transfer(value),
        );
  }

  @override
  Future<ApiResponse<ContributionBook>> getContributionBookByNormalBarcode(
      String normalBarcode, String token) async {
    return await _contributionBookService
        .getContributionBookByNormalBarcode(normalBarcode, token)
        .then(
          (value) => ApiResponseContributionBookMapper().transfer(value),
        );
  }

  @override
  Future<ApiResponse<List<ContributionBook>>> getContributionBooks(
      String token) {
    throw UnimplementedError();
  }
}
