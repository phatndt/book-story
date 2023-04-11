import 'package:book_exchange/data/repos/book_contribution_impl.dart';
import 'package:book_exchange/data/services/book_contribution_service.dart';
import 'package:book_exchange/domain/use_cases/book_contribution/get_contribution_book_by_isbn_barcode_use_case.dart';
import 'package:book_exchange/domain/use_cases/book_contribution/get_contribution_book_by_normal_barcode_use_case.dart';
import 'package:book_exchange/domain/use_cases/book_contribution/get_contribution_book_by_normal_barcode_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/book_contribution/upload_contribution_book_use_case.dart';
import 'package:book_exchange/domain/use_cases/book_contribution/upload_contribution_book_use_case_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/use_cases/book_contribution/get_contribution_book_by_isbn_barcode_use_case_impl.dart';
import '../view_models/add_contribution_book_view_model.dart';

final contributionBookServiceProvider =
    Provider<ContributionBookService>((ref) => ContributionBookService());

final contributionBookRepoProvider = Provider<ContributionBookRepoImpl>((ref) =>
    ContributionBookRepoImpl(ref.watch(contributionBookServiceProvider)));

final uploadContributionBookUseCaseProvider =
    Provider<UploadContributionBookUseCase>((ref) =>
        UploadContributionBookUseCaseImpl(
            ref.watch(contributionBookRepoProvider)));

final getContributionBookByNormalBarcodeUseCase =
    Provider<GetContributionBookByNormalBarcodeUseCase>((ref) =>
        GetContributionBookByNormalBarcodeUseCaseImpl(
            ref.watch(contributionBookRepoProvider)));

final getContributionBookByISBNBarcodeUseCase =
    Provider<GetContributionBookByISBNBarcodeUseCase>((ref) =>
        GetContributionBookByISBNBarcodeUseCaseImpl(
            ref.watch(contributionBookRepoProvider)));

final addContributionBookSettingNotifierProvider = StateNotifierProvider.autoDispose<
        AddContributionBookSettingNotifier, AddContributionBookSetting>(
    ((ref) => AddContributionBookSettingNotifier(
        ref, ref.watch(uploadContributionBookUseCaseProvider))));
