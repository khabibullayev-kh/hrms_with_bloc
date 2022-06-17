import 'package:flutter/material.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/styles.dart';

class TextFieldTile extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? textInputType;
  final String label;
  final String? hintText;
  final bool? readOnly;
  final int? maxLength;
  //final bool? capitalize;

  const TextFieldTile({
    Key? key,
    required this.controller,
    this.textInputType,
    required this.label,
    this.hintText,
    this.readOnly,
    this.maxLength,
    //this.capitalize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(label, style: HRMSStyles.labelStyle),
          const SizedBox(height: 8),
          TextFormField(
            textInputAction: TextInputAction.done,
            keyboardType: textInputType,
            maxLength: maxLength,
            readOnly: readOnly ?? false,
            //textCapitalization: TextCapitalization.characters,
            validator: (String? arg) {
              if (arg!.isEmpty) {
                return 'Заполните поле!';
              }
            },
            cursorColor: HRMSColors.green,
            controller: controller,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.blueGrey.shade400),
              hintText: hintText,
              fillColor: Colors.white,

              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: HRMSColors.green, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}
