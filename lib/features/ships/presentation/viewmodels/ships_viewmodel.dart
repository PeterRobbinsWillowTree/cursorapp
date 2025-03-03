import 'package:flutter/foundation.dart';
import '../../domain/entities/historical_ship.dart';
import '../../domain/repositories/ships_repository.dart';

class ShipsViewModel extends ChangeNotifier {
  final ShipsRepository repository;
  
  List<HistoricalShip>? _ships;
  String? _error;
  bool _isLoading = false;

  List<HistoricalShip>? get ships => _ships;
  String? get error => _error;
  bool get isLoading => _isLoading;

  ShipsViewModel({required this.repository});

  Future<void> loadShips() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _ships = await repository.getPreDreadnoughtShips();
    } catch (e) {
      _error = e.toString();
      _ships = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 