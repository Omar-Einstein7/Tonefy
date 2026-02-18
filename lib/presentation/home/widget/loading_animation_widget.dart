import 'package:flutter/material.dart';

class LoadingAnimationWidget extends StatefulWidget {
  final String message;

  const LoadingAnimationWidget({super.key, this.message = 'Loading...'});

  @override
  State<LoadingAnimationWidget> createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _animation,
            child: Icon(
              Icons.music_note, // Using a music note icon for a thematic touch
              size: 100,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.message,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
