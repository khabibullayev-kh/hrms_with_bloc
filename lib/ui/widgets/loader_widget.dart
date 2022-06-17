import 'package:flutter/material.dart';
import 'package:hrms/data/resources/colors.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: HRMSColors.green,),
      ),
    );
  }
}