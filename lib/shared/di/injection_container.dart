import 'package:get_it/get_it.dart';
import '../../features/intercept/data/repositories/intercept_repository_impl.dart';
import '../../features/intercept/domain/repositories/intercept_repository.dart';
import '../../features/intercept/domain/usecases/calculate_intercept.dart';
import '../../features/intercept/presentation/viewmodels/intercept_viewmodel.dart';
import '../../features/ships/domain/repositories/ships_repository.dart';
import '../../features/ships/presentation/viewmodels/ships_viewmodel.dart';
import '../../features/ships/data/repositories/mock_ships_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Repository
  sl.registerLazySingleton<InterceptRepository>(
    () => InterceptRepositoryImpl(),
  );

  // Use cases
  sl.registerLazySingleton(() => CalculateIntercept(sl()));

  // ViewModels
  sl.registerFactory(() => InterceptViewModel(calculateIntercept: sl()));

  // Repositories
  sl.registerLazySingleton<ShipsRepository>(
    () => MockShipsRepository(),
  );

  // ViewModels
  sl.registerFactory(() => ShipsViewModel(repository: sl()));
} 