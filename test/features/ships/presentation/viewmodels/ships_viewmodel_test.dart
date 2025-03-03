import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:cursorapp/features/ships/presentation/viewmodels/ships_viewmodel.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late ShipsViewModel viewModel;

  setUp(() async {
    await setupTestDependencies();
    viewModel = ShipsViewModel(repository: GetIt.instance());
  });

  tearDown(() {
    tearDownTestDependencies();
  });

  test('loadShips uses mock repository', () async {
    await viewModel.loadShips();
    expect(viewModel.ships, isNotNull);
    expect(viewModel.isLoading, isFalse);
  });
} 