import '../entities/historical_ship.dart';

abstract class ShipsRepository {
  Future<List<HistoricalShip>> getPreDreadnoughtShips();
  Future<HistoricalShip> getShipDetails(String name);
} 