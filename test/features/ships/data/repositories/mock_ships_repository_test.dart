import 'package:flutter_test/flutter_test.dart';
import 'package:cursorapp/features/ships/data/repositories/mock_ships_repository.dart';
import 'package:cursorapp/features/ships/domain/entities/historical_ship.dart';

void main() {
  late MockShipsRepository repository;

  setUp(() {
    repository = MockShipsRepository();
  });

  group('MockShipsRepository', () {
    test('getPreDreadnoughtShips returns mock data', () async {
      final ships = await repository.getPreDreadnoughtShips();
      
      expect(ships, isA<List<HistoricalShip>>());
      expect(ships.length, 3);  // We have 3 mock ships
      expect(ships.first.name, 'HMS Canopus');
    });

    test('getShipDetails returns correct mock ship', () async {
      final ship = await repository.getShipDetails('Mikasa');
      
      expect(ship, isA<HistoricalShip>());
      expect(ship.name, 'Mikasa');
      expect(ship.country, 'Japan');
    });

    test('getShipDetails throws exception for non-existent ship', () async {
      expect(
        () => repository.getShipDetails('Non-existent Ship'),
        throwsException,
      );
    });

    test('mock data contains required fields', () async {
      final ships = await repository.getPreDreadnoughtShips();
      
      for (final ship in ships) {
        expect(ship.name, isNotEmpty);
        expect(ship.imageUrl, isNotEmpty);
        expect(ship.armament, isNotEmpty);
        expect(ship.displacement, isPositive);
        expect(ship.maxSpeed, isPositive);
      }
    });
  });
} 