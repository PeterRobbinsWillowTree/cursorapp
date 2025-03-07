import '../../domain/entities/historical_ship.dart';
import '../../domain/repositories/ships_repository.dart';
import 'package:cursorapp/core/services/api_client.dart';
import 'package:cursorapp/core/services/config_service.dart';
import 'mock_ships_repository.dart';

class ShipsRepositoryImpl implements ShipsRepository {
  final ApiClient apiClient;
  final ConfigService config;
  final MockShipsRepository mockRepository;

  ShipsRepositoryImpl({
    required this.apiClient,
    required this.config,
    required this.mockRepository,
  });

  @override
  Future<List<HistoricalShip>> getPreDreadnoughtShips() async {
    try {
      if (config.isOffline) {
        return mockRepository.getPreDreadnoughtShips();
      }

      final response = await apiClient.get('/ships/pre-dreadnought');
      final List<dynamic> data = response.data['ships'];
      return data.map((json) => HistoricalShip(
        name: json['name'],
        country: json['country'],
        yearCommissioned: json['yearCommissioned'],
        displacement: json['displacement'].toDouble(),
        length: json['length'].toDouble(),
        beam: json['beam'].toDouble(),
        draft: json['draft'].toDouble(),
        maxSpeed: json['maxSpeed'].toDouble(),
        imageUrl: json['imageUrl'],
        description: json['description'],
        armament: List<String>.from(json['armament']),
      )).toList();
    } on OfflineModeException {
      return mockRepository.getPreDreadnoughtShips();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HistoricalShip> getShipDetails(String name) async {
    try {
      if (config.isOffline) {
        return mockRepository.getShipDetails(name);
      }

      final response = await apiClient.get('/ships/$name');
      final json = response.data['ship'];
      return HistoricalShip(
        name: json['name'],
        country: json['country'],
        yearCommissioned: json['yearCommissioned'],
        displacement: json['displacement'].toDouble(),
        length: json['length'].toDouble(),
        beam: json['beam'].toDouble(),
        draft: json['draft'].toDouble(),
        maxSpeed: json['maxSpeed'].toDouble(),
        imageUrl: json['imageUrl'],
        description: json['description'],
        armament: List<String>.from(json['armament']),
      );
    } on OfflineModeException {
      return mockRepository.getShipDetails(name);
    } catch (e) {
      rethrow;
    }
  }
} 