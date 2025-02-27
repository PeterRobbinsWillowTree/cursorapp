import 'package:flutter/foundation.dart';
import '../../domain/entities/intercept_params.dart';
import '../../domain/entities/intercept_result.dart';
import '../../domain/usecases/calculate_intercept.dart';

class InterceptViewModel extends ChangeNotifier {
  final CalculateIntercept calculateIntercept;
  
  InterceptResult? _result;
  String? _error;
  bool _isLoading = false;

  InterceptResult? get result => _result;
  String? get error => _error;
  bool get isLoading => _isLoading;

  InterceptViewModel({required this.calculateIntercept});

  Future<void> computeIntercept(InterceptParams params) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _result = await calculateIntercept(params);
      _error = null;
    } catch (e) {
      _error = 'Error calculating intercept: ${e.toString()}';
      _result = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 