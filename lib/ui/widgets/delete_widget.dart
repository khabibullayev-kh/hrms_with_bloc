import 'package:flutter/material.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';

class DeleteWidget extends StatelessWidget {
  final String deleteText;
  final VoidCallback onTapDelete;
  final bool isLoading;

  const DeleteWidget({
    Key? key,
    required this.deleteText,
    required this.onTapDelete,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          deleteText,
          style: HRMSStyles.h1Style,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 52,
              child: ActionButton(
                text: 'Да',
                onPressed: onTapDelete,
                isLoading: isLoading,
              ),
            ),
            SizedBox(
              height: 52,
              child: ActionButton(
                text: 'Нет',
                onPressed: () => isLoading ? null : Navigator.pop(context),
                isLoading: false,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
