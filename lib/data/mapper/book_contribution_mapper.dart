import '../../domain/entities/api_response.dart';
import '../../domain/entities/book_contribution.dart';
import '../base/base_mapper.dart';
import '../entities/api_response_dto.dart';
import '../entities/book_contribution_dto.dart';

class ApiResponseContributionBookMapper extends BaseMapper<
    ApiResponseDTO<ContributionBookDTO>, ApiResponse<ContributionBook>> {
  @override
  ApiResponse<ContributionBook> transfer(
      ApiResponseDTO<ContributionBookDTO> d) {
    return ApiResponse(
      data: ContributionBookMapper().transfer(d.data),
      statusCode: d.statusCode,
      message: d.message,
    );
  }

  ApiResponse<String> transferId(ApiResponseDTO<ContributionBookDTO> d) {
    return ApiResponse(
      data: ContributionBookMapper().transferId(d.data),
      statusCode: d.statusCode,
      message: d.message,
    );
  }
}

class ApiResponseContributionBookListMapper extends BaseMapper<
    ApiResponseDTO<List<ContributionBookDTO>>,
    ApiResponse<List<ContributionBook>>> {
  @override
  ApiResponse<List<ContributionBook>> transfer(
      ApiResponseDTO<List<ContributionBookDTO>> d) {
    return ApiResponse(
      data: d.data.map((e) => ContributionBookMapper().transfer(e)).toList(),
      statusCode: d.statusCode,
      message: d.message,
    );
  }
}

class ContributionBookMapper
    extends BaseMapper<ContributionBookDTO, ContributionBook> {
  @override
  ContributionBook transfer(ContributionBookDTO d) {
    return ContributionBook(
      id: d.id,
      name: d.name,
      author: d.author,
      description: d.description,
      imageUrl: d.imageUrl,
      delete: d.deleted,
      verified: d.verified,
      isbnBarcode: d.isbnBarcode,
      normalBarcode: d.normalBarcode,
    );
  }

  String transferId(ContributionBookDTO d) {
    return d.id;
  }
}
