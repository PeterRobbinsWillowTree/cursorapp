import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cursorapp/features/ships/domain/repositories/ships_repository.dart';
import 'package:cursorapp/shared/di/injection_container.dart' as di;

class MockShipsRepository extends Mock implements ShipsRepository {}

Future<void> setupTestDependencies() async {
  final sl = GetIt.instance;
  
  // Register mocks
  sl.registerLazySingleton<ShipsRepository>(() => MockShipsRepository());
  
  // Initialize other dependencies
  await di.init();
}

void tearDownTestDependencies() {
  GetIt.instance.reset();
} 