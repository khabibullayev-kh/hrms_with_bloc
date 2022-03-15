import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';

class ActionsWidget extends StatelessWidget {
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final int id;

  const ActionsWidget({
    Key? key,
    required this.id,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (isCan('update-job-position'))
          IconButton(
            onPressed: onEditPressed,
            icon: SvgPicture.asset(
              HRMSIcons.editLogo,
              width: 18,
              height: 18,
            ),
          ),
        if (isCan('delete-job-position'))
          IconButton(
          onPressed: onDeletePressed,
          icon: SvgPicture.asset(
            HRMSIcons.deleteLogo,
            width: 18,
            height: 18,
          ),
        ),
      ],
    );
  }
}
