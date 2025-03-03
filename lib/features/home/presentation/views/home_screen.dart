import 'package:flutter/material.dart';
import 'package:cursorapp/features/intercept/presentation/views/detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cursorapp/features/intercept/presentation/viewmodels/intercept_viewmodel.dart';
import 'package:cursorapp/shared/di/injection_container.dart' as di;
import 'package:cursorapp/features/ships/presentation/views/ships_list_screen.dart';
import 'package:cursorapp/features/ships/presentation/viewmodels/ships_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> appTiles = const [
    {
      'title': 'Intercept',
      'icon': Icons.calculate,
      'color': Colors.blue,
      'description': 'Calculate intercept course and speed',
    },
    {
      'title': 'Show List Of Ships',
      'icon': Icons.directions_boat,
      'color': Colors.green,
      'description': 'View historical pre-dreadnought ships',
    },
    {
      'title': 'How to Use',
      'icon': Icons.help_outline,
      'color': Colors.green,
      'description': 'Instructions and examples',
    },
    {
      'title': 'About',
      'icon': Icons.info_outline,
      'color': Colors.orange,
      'description': 'About this application',
    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'color': Colors.purple,
      'description': 'App configuration',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Intercept Calculator'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: appTiles.length,
        itemBuilder: (context, index) {
          final tile = appTiles[index];
          return InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => di.sl<InterceptViewModel>(),
                      child: const DetailScreen(),
                    ),
                  ),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => di.sl<ShipsViewModel>(),
                      child: const ShipsListScreen(),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${tile['title']} coming soon')),
                );
              }
            },
            child: Card(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tile['color'],
                      tile['color'].withAlpha(200),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tile['icon'],
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tile['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        tile['description'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 