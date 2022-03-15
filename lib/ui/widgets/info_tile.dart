import 'package:flutter/material.dart';

class InfoTile extends StatefulWidget {
  final String label;
  final String labelInfo;

  const InfoTile({Key? key, required this.label, required this.labelInfo})
      : super(key: key);

  @override
  _InfoTileState createState() => _InfoTileState();
}

class _InfoTileState extends State<InfoTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const SizedBox(height: 8),
        Text(
          widget.label + ':',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.labelInfo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Divider(
          height: 10,
          indent: 32,
          thickness: 1,
        )
      ],
    );
  }
}
