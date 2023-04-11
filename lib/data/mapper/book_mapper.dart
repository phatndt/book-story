import 'package:book_exchange/data/entities/api_response_dto.dart';
import 'package:book_exchange/data/entities/book_dto.dart';

import '../../domain/entities/api_response.dart';
import '../../domain/entities/book.dart';
import '../base/base_mapper.dart';

class ApiResponseBookMapper
    extends BaseMapper<ApiResponseDTO<BookDTO>, ApiResponse<Book>> {
  @override
  ApiResponse<Book> transfer(ApiResponseDTO<BookDTO> d) {
    return ApiResponse(
      data: BookMapper().transfer(d.data),
      statusCode: d.statusCode,
      message: d.message,
    );
  }
}

class ApiResponseBookListMapper
    extends BaseMapper<ApiResponseDTO<List<BookDTO>>, ApiResponse<List<Book>>> {
  @override
  ApiResponse<List<Book>> transfer(ApiResponseDTO<List<BookDTO>> d) {
    return ApiResponse(
      data: d.data.map((e) => BookMapper().transfer(e)).toList(),
      statusCode: d.statusCode,
      message: d.message,
    );
  }
}

class BookMapper extends BaseMapper<BookDTO, Book> {
  @override
  Book transfer(BookDTO d) {
    return Book(
      id: d.id,
      name: d.name,
      author: d.author,
      description: d.description,
      rate: d.rate,
      imageURL: d.imageURL,
      userId: d.userId,
      delete: d.delete,
    );
  }
}
