import 'package:flutter/material.dart';
import 'package:hrms/data/resources/colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final double? height;
  final bool isLoading;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width ?? MediaQuery.of(context).size.width * 0.4,
        height: height,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator.adaptive(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                  ),
          ),
          style: ElevatedButton.styleFrom(primary: color ?? HRMSColors.green),
        ),
      ),
    );
  }
}
