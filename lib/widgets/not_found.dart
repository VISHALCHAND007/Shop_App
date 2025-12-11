import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  final IconData icon;
  final String title;

  const NotFound({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(icon, size: 60),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}