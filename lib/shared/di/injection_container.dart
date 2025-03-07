import 'package:get_it/get_it.dart';
import '../../features/intercept/data/repositories/intercept_repository_impl.dart';
import '../../features/intercept/domain/repositories/intercept_repository.dart';
import '../../features/intercept/domain/usecases/calculate_intercept.dart';
import '../../features/intercept/presentation/viewmodels/intercept_viewmodel.dart';
import '../../features/ships/domain/repositories/ships_repository.dart';
import '../../features/ships/presentation/viewmodels/ships_viewmodel.dart';
import '../../features/ships/data/repositories/mock_ships_repository.dart';
import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/services/config_service.dart';
import '../../features/ships/data/repositories/ships_repository_impl.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Services
  final config = ConfigService.development();  // This ensures offline mode
  
  sl.registerLazySingleton(() => config);
  
  sl.registerLazySingleton(() => Dio(BaseOptions(
    baseUrl: config.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  )));
  
  sl.registerLazySingleton(() => ApiClient(
    dio: sl(),
    isOffline: config.isOffline,  // This should be true in development
  ));

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
    () => ShipsRepositoryImpl(
      apiClient: sl(),
      config: sl(),
      mockRepository: MockShipsRepository(),  // Make sure this is registered
    ),
  );

  // ViewModels
  sl.registerFactory(() => ShipsViewModel(repository: sl()));
} 