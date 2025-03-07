import 'package:flutter/material.dart';
import '../../domain/entities/historical_ship.dart';

class ShipDetailScreen extends StatelessWidget {
  final HistoricalShip ship;

  const ShipDetailScreen({super.key, required this.ship});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ship.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                ship.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error_outline, size: 50),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Country: ${ship.country}'),
            Text('Year Commissioned: ${ship.yearCommissioned}'),
            Text('Displacement: ${ship.displacement} tons'),
            Text('Length: ${ship.length} meters'),
            Text('Beam: ${ship.beam} meters'),
            Text('Draft: ${ship.draft} meters'),
            Text('Max Speed: ${ship.maxSpeed} knots'),
            const SizedBox(height: 16),
            Text('Description: ${ship.description}'),
            const SizedBox(height: 16),
            const Text('Armament:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...ship.armament.map((a) => Text('• $a')),
          ],
        ),
      ),
    );
  }
} 