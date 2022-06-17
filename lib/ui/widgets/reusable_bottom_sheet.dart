import 'package:flutter/material.dart';

class ReusableBottomSheet extends StatelessWidget {
  final Widget children;

  const ReusableBottomSheet({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Container(
            height: 4,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        children,
        const SizedBox(height: 48),
      ],
    );
  }
}
