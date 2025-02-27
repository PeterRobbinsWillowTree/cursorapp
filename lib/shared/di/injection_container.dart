import 'package:get_it/get_it.dart';
import '../../features/intercept/data/repositories/intercept_repository_impl.dart';
import '../../features/intercept/domain/repositories/intercept_repository.dart';
import '../../features/intercept/domain/usecases/calculate_intercept.dart';
import '../../features/intercept/presentation/viewmodels/intercept_viewmodel.dart';

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
} 