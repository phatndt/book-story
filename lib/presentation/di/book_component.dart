import 'package:book_exchange/data/repos/book_repo_impl.dart';
import 'package:book_exchange/domain/use_cases/book/delete_book_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/book/edit_book_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/book/get_list_book_by_id_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/book/upload_book_use_case_impl.dart';
import 'package:book_exchange/presentation/di/book_contribution_component.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/services/book_service.dart';
import '../../domain/repository/book_repo.dart';
import '../../domain/use_cases/book/delete_book_use_case.dart';
import '../../domain/use_cases/book/edit_book_use_case.dart';
import '../../domain/use_cases/book/get_list_book_by_id_use_case.dart';
import '../../domain/use_cases/book/upload_book_use_case.dart';
import '../../domain/use_cases/upload_image_use_case.dart';
import '../../domain/use_cases/upload_image_use_case_impl.dart';
import '../view_models/add_book_viewmodels.dart';
import '../view_models/book_detail_viewmodel.dart';
import '../view_models/collection_viewmodels.dart';
import '../view_models/edit_book_viewmodels.dart';

final bookServiceProvider = Provider<BookService>((ref) => BookService());

final booksRepoProvider =
    Provider<BookRepo>((ref) => BookRepoImpl(ref.watch(bookServiceProvider)));

final uploadImageToCloudinaryUseCaseProvider =
    Provider<UploadImageToCloudinaryUseCase>((ref) =>
        UploadImageToCloudinaryUseCaseImpl(ref.watch(booksRepoProvider)));

final editBookUseCaseProvider = Provider<EditBookUseCase>(
    (ref) => EditBookUseCaseImpl(ref.watch(booksRepoProvider)));

final uploadBookUseCaseProvider = Provider<UploadBookUseCase>(
    (ref) => UploadBookUseCaseImpl(ref.watch(booksRepoProvider)));

final deleteBookUseCaseProvider = Provider<DeleteBookUseCase>(
    (ref) => DeleteBookUseCaseImpl(ref.watch(booksRepoProvider)));

final getListBookUseCaseProvider = Provider<GetListBookUseCase>(
    (ref) => GetListBookByIdUseCaseImpl(ref.watch(booksRepoProvider)));

final addBookSettingNotifierProvider =
    StateNotifierProvider<AddBookSettingNotifier, AddBookSetting>(
        ((ref) => AddBookSettingNotifier(
              ref,
              ref.watch(uploadImageToCloudinaryUseCaseProvider),
              ref.watch(uploadBookUseCaseProvider),
              ref.watch(getContributionBookByISBNBarcodeUseCase),
              ref.watch(getContributionBookByNormalBarcodeUseCase),
            )));

final collectionSettingNotifierProvider =
    StateNotifierProvider<CollectionSettingNotifier, CollectionSetting>(
        ((ref) => CollectionSettingNotifier(ref)));

final editBookSettingNotifierProvider =
    StateNotifierProvider<EditBookSettingNotifier, EditBookSetting>(((ref) =>
        EditBookSettingNotifier(ref, ref.watch(editBookUseCaseProvider),
            ref.watch(deleteBookUseCaseProvider))));
final bookDetailSettingNotifierProvider =
    StateNotifierProvider<BookDetailSettingNotifier, BookDetailSetting>(
        ((ref) => BookDetailSettingNotifier(ref)));
