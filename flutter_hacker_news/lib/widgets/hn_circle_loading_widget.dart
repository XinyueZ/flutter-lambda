import 'package:flutter/material.dart';

class HNCircleLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Padding(
        padding: const EdgeInsets.all(8.0),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
