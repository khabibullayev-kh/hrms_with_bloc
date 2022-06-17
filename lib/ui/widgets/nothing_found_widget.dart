import 'package:flutter/material.dart';

class NothingFoundWidget extends StatelessWidget {
  final String text;

  const NothingFoundWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Center(
        child: Text(text),
      ),
    );
  }
}
