import '../entities/intercept_params.dart';
import '../entities/intercept_result.dart';
import '../repositories/intercept_repository.dart';

class CalculateIntercept {
  final InterceptRepository repository;

  CalculateIntercept(this.repository);

  Future<InterceptResult> call(InterceptParams params) {
    return repository.calculateIntercept(params);
  }
} 