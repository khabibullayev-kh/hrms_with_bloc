import 'package:flutter/material.dart';

class ReusableDropDownButton extends StatelessWidget {
  final Function(dynamic)? onChanged;
  final dynamic value;
  final List<DropdownMenuItem<dynamic>> items;
  final String? hint;

  const ReusableDropDownButton({
    Key? key,
    required this.onChanged,
    required this.value,
    required this.items,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            )),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            hint: Text(hint ?? ''),
              isExpanded: true,
              value: value,
              items: items,
              onChanged: onChanged),
        ),
      ),
    );
  }
}
