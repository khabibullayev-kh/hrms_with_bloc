import 'package:flutter/material.dart';
import 'package:hrms/data/resources/colors.dart';

class ReusableCircularIndicator extends StatelessWidget {
  const ReusableCircularIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 32.0),
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(
          HRMSColors.green,
        ),
      ),
    );
  }
}
