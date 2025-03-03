import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cursorapp/features/ships/domain/repositories/ships_repository.dart';
import 'package:cursorapp/features/ships/domain/entities/historical_ship.dart';

class MockShipsRepository extends Mock implements ShipsRepository {}

void main() {
  late MockShipsRepository repository;

  setUp(() {
    repository = MockShipsRepository();
  });

  final testShip = HistoricalShip(
    name: 'HMS Canopus',
    country: 'United Kingdom',
    yearCommissioned: 1899,
    displacement: 13150,
    length: 131.1,
    beam: 22.9,
    draft: 7.9,
    maxSpeed: 18,
    imageUrl: 'https://example.com/canopus.jpg',
    description: 'Test description',
    armament: ['Test armament'],
  );

  group('getPreDreadnoughtShips', () {
    test('should return list of ships when successful', () async {
      // Arrange
      when(() => repository.getPreDreadnoughtShips())
          .thenAnswer((_) async => [testShip]);

      // Act
      final result = await repository.getPreDreadnoughtShips();

      // Assert
      expect(result, isA<List<HistoricalShip>>());
      expect(result.first.name, equals('HMS Canopus'));
      verify(() => repository.getPreDreadnoughtShips()).called(1);
    });

    test('should throw exception when API fails', () {
      // Arrange
      when(() => repository.getPreDreadnoughtShips())
          .thenThrow(Exception('API Error'));

      // Act & Assert
      expect(
        () => repository.getPreDreadnoughtShips(),
        throwsException,
      );
    });
  });
} 