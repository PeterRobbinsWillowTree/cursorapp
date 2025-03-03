import '../../domain/entities/historical_ship.dart';
import '../../domain/repositories/ships_repository.dart';
import 'package:logger/logger.dart';

class MockShipsRepository implements ShipsRepository {
  final _logger = Logger();
  final _mockShips = [
    HistoricalShip(
      name: 'HMS Canopus',
      country: 'United Kingdom',
      yearCommissioned: 1899,
      displacement: 13150,
      length: 131.1,
      beam: 22.9,
      draft: 7.9,
      maxSpeed: 18,
      imageUrl: 'assets/ships/canopus.jpg',
      description: 'Lead ship of the Canopus-class pre-dreadnought battleships. Served in World War I.',
      armament: [
        '4 × BL 12-inch Mk VIII guns',
        '12 × QF 6-inch guns',
        '10 × QF 12-pounder guns',
        '6 × QF 3-pounder guns',
      ],
    ),
    HistoricalShip(
      name: 'SMS Brandenburg',
      country: 'German Empire',
      yearCommissioned: 1893,
      displacement: 10670,
      length: 115.7,
      beam: 19.5,
      draft: 7.6,
      maxSpeed: 16.5,
      imageUrl: 'assets/ships/brandenburg.jpg',
      description: 'Lead ship of the Brandenburg-class pre-dreadnought battleships.',
      armament: [
        '6 × 28 cm SK L/40 guns',
        '8 × 10.5 cm SK L/35 guns',
        '8 × 8.8 cm SK L/30 guns',
      ],
    ),
    HistoricalShip(
      name: 'Mikasa',
      country: 'Japan',
      yearCommissioned: 1902,
      displacement: 15140,
      length: 131.7,
      beam: 23.2,
      draft: 8.2,
      maxSpeed: 18,
      imageUrl: 'assets/ships/mikasa.jpg',
      description: 'Admiral Tōgō\'s flagship during the Russo-Japanese War.',
      armament: [
        '4 × 12-inch guns',
        '14 × 6-inch guns',
        '20 × 12-pounder guns',
        '8 × 3-pounder guns',
      ],
    ),
  ];

  @override
  Future<List<HistoricalShip>> getPreDreadnoughtShips() async {
    _logger.i('Fetching mock pre-dreadnought ships data');
    await Future.delayed(const Duration(seconds: 1));
    _logger.i('Returned ${_mockShips.length} mock ships');
    return _mockShips;
  }

  @override
  Future<HistoricalShip> getShipDetails(String name) async {
    _logger.i('Fetching mock details for ship: $name');
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockShips.firstWhere(
      (ship) => ship.name == name,
      orElse: () {
        _logger.e('Ship not found: $name');
        throw Exception('Ship not found');
      },
    );
  }
} 