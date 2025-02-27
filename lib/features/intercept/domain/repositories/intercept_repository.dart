import '../entities/intercept_params.dart';
import '../entities/intercept_result.dart';

abstract class InterceptRepository {
  Future<InterceptResult> calculateIntercept(InterceptParams params);
} 