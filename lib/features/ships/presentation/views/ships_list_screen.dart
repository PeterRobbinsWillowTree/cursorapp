import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ships_viewmodel.dart';
import '../views/ship_detail_screen.dart';

class ShipsListScreen extends StatefulWidget {
  const ShipsListScreen({super.key});

  @override
  State<ShipsListScreen> createState() => _ShipsListScreenState();
}

class _ShipsListScreenState extends State<ShipsListScreen> {
  @override
  void initState() {
    super.initState();
    // Load ships when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShipsViewModel>().loadShips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-Dreadnought Ships'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              label: const Text('MOCK DATA'),
              backgroundColor: Colors.orange.withAlpha(77),
            ),
          ),
        ],
      ),
      body: Consumer<ShipsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          if (viewModel.ships == null || viewModel.ships!.isEmpty) {
            return const Center(child: Text('No ships found'));
          }

          return ListView.builder(
            itemCount: viewModel.ships!.length,
            itemBuilder: (context, index) {
              final ship = viewModel.ships![index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(ship.name),
                  subtitle: Text('${ship.country} - ${ship.yearCommissioned}'),
                  trailing: Text('${ship.maxSpeed} kts'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShipDetailScreen(ship: ship),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 