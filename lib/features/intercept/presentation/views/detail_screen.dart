import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/intercept_viewmodel.dart';
import '../../domain/entities/intercept_params.dart';
import './visualization_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double? distance;
  double? bearing;
  double? myShipCourse;
  double? myShipSpeed;
  double? targetCourse;
  double? targetSpeed;

  void _handleComputeIntercept(InterceptViewModel viewModel) async {
    final params = InterceptParams(
      distance: distance,
      bearing: bearing,
      myShipCourse: myShipCourse,
      myShipSpeed: myShipSpeed,
      targetCourse: targetCourse,
      targetSpeed: targetSpeed,
    );

    await viewModel.computeIntercept(params);

    if (!mounted) return;

    if (viewModel.result != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VisualizationScreen(
            result: viewModel.result!,
            params: params,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail View'),
      ),
      body: Consumer<InterceptViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Distance to Target',
                    border: OutlineInputBorder(),
                    hintText: 'Enter distance in nautical miles',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => distance = double.tryParse(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Bearing to Target',
                    border: OutlineInputBorder(),
                    hintText: 'Enter bearing in degrees',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => bearing = double.tryParse(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'My Ship Course',
                    border: OutlineInputBorder(),
                    hintText: 'Enter my ship course',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => myShipCourse = double.tryParse(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'My Ship Speed',
                    border: OutlineInputBorder(),
                    hintText: 'Enter my ship speed',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => myShipSpeed = double.tryParse(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Target Course',
                    border: OutlineInputBorder(),
                    hintText: 'Enter target course',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => targetCourse = double.tryParse(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Target Speed',
                    border: OutlineInputBorder(),
                    hintText: 'Enter target speed',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => targetSpeed = double.tryParse(value),
                ),
                const SizedBox(height: 24),
                if (viewModel.isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () => _handleComputeIntercept(viewModel),
                    child: const Text('Compute intercept course and speed'),
                  ),
                if (viewModel.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      viewModel.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (viewModel.result != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Intercept Course: ${viewModel.result!.interceptCourse.toStringAsFixed(1)}°'),
                        Text('Intercept Speed: ${viewModel.result!.interceptSpeed.toStringAsFixed(1)} kts'),
                        Text('Time to Intercept: ${viewModel.result!.timeToIntercept.toStringAsFixed(1)} minutes'),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
} 