import 'package:book_exchange/data/repos/map_repo_impl.dart';
import 'package:book_exchange/data/services/map_service.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/use_cases/map/get_all_user_use_case.dart';
import 'package:book_exchange/domain/use_cases/post/get_all_post_use_case.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:book_exchange/presentation/view_models/map/map_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/user.dart';

final mapService = Provider<MapService>(
  (ref) => MapService(),
);

final mapProvider = Provider<MapRepoImpl>(
  (ref) => MapRepoImpl(
    ref.watch(mapService),
  ),
);

final getAllUserUseCase = Provider<GetAllUserUserCase>(
  (ref) => GetAllUserUserCase(
    ref.watch(mapProvider),
  ),
);

final getAllUserProvider = FutureProvider.autoDispose
    .family<ApiResponse<List<User>>, GetAllUserUserCase>(
  (ref, getAllUserUseCase) =>
      getAllUserUseCase.getAllUser(BookAppModel.jwtToken),
);

final mapNotifierProvider = StateNotifierProvider<MapNotifier, MapState>(
  (ref) => MapNotifier(ref),
);
