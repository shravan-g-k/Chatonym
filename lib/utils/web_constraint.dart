import 'package:flutter/widgets.dart';

class WebConstraint extends StatelessWidget {
  final Widget child;
  const WebConstraint({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: child,
      ),
    );
  }
}
