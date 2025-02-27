import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cursorapp/animated_intercept_visualization.dart';

class AnimatedInterceptView extends StatefulWidget {
  final double? myShipCourse;
  final double? myShipSpeed;
  final double? targetCourse;
  final double? targetSpeed;
  final double? bearing;
  final double? distance;
  final double? interceptCourse;
  final double? interceptSpeed;
  final double? timeToIntercept;
  final String result;

  const AnimatedInterceptView({
    super.key,
    required this.myShipCourse,
    required this.myShipSpeed,
    required this.targetCourse,
    required this.targetSpeed,
    required this.bearing,
    required this.distance,
    required this.interceptCourse,
    required this.interceptSpeed,
    required this.timeToIntercept,
    required this.result,
  });

  @override
  State<AnimatedInterceptView> createState() => _AnimatedInterceptViewState();
}

class _AnimatedInterceptViewState extends State<AnimatedInterceptView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _blinkAnimation;
  bool _hasIntercepted = false;

  @override
  void initState() {
    super.initState();
    // Calculate animation duration based on time to intercept
    final duration = widget.timeToIntercept != null 
        ? Duration(milliseconds: (widget.timeToIntercept! * 1000).round())
        : const Duration(seconds: 5);

    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,  // Use linear for accurate time representation
    ));

    // Add blinking animation
    _blinkAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: FlutterLoopingCurve(period: 0.5),  // Blink every half second
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intercept Animation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Visualization with fixed height
            SizedBox(
              height: 400,  // Fixed height for visualization
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: AnimatedInterceptVisualization(
                      myShipCourse: widget.myShipCourse,
                      myShipSpeed: widget.myShipSpeed,
                      targetCourse: widget.targetCourse,
                      targetSpeed: widget.targetSpeed,
                      bearing: widget.bearing,
                      distance: widget.distance,
                      interceptCourse: widget.interceptCourse,
                      interceptSpeed: widget.interceptSpeed,
                      timeToIntercept: widget.timeToIntercept,
                      animationValue: _animation.value,
                      blinkValue: _blinkAnimation.value,
                      onIntercept: () {
                        if (!_hasIntercepted) {
                          _hasIntercepted = true;
                          _controller.stop();
                        }
                      },
                    ),
                    size: Size.infinite,
                  );
                },
              ),
            ),
            // Input data with reduced top padding
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),  // Reduced top padding from 16 to 4
              child: SizedBox(  // Changed from Container to SizedBox
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(26),  // ~0.1 opacity (26/255)
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Initial conditions:',
                              style: Theme.of(context).textTheme.titleSmall),
                          Text('Distance: ${widget.distance?.toStringAsFixed(1)} nm'),
                          Text('Bearing: ${widget.bearing?.toStringAsFixed(1)}°'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(26),  // ~0.1 opacity (26/255)
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My ship:', 
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.blue)),
                          Text('Course: ${widget.myShipCourse?.toStringAsFixed(1)}°'),
                          Text('Speed: ${widget.myShipSpeed?.toStringAsFixed(1)} kts'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(26),  // ~0.1 opacity (26/255)
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target:', 
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.red)),
                          Text('Course: ${widget.targetCourse?.toStringAsFixed(1)}°'),
                          Text('Speed: ${widget.targetSpeed?.toStringAsFixed(1)} kts'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Add solution text at bottom
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.result,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.isAnimating) {
            _controller.stop();
          } else {
            if (_hasIntercepted || _controller.isCompleted) {
              _hasIntercepted = false;
              _controller.reset();
            }
            _controller.forward();
          }
        },
        child: Icon(_controller.isAnimating ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}

class FlutterLoopingCurve extends Curve {
  final double period;

  const FlutterLoopingCurve({this.period = 1.0});

  @override
  double transform(double t) {
    if (t >= 1.0) return 1.0;
    if (t <= 0.0) return 0.0;
    final sinValue = sin(t * 2 * pi / period);
    return (sinValue + 1) / 2;  // Convert from -1..1 to 0..1
  }
} 