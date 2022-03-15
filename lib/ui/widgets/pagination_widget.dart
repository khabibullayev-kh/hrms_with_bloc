import 'package:flutter/material.dart';
import 'package:hrms/data/resources/colors.dart';

class PaginationButtons extends StatelessWidget {
  final VoidCallback onTap;
  final String currentPage;
  final String pages;

  const PaginationButtons({
    Key? key,
    required this.onTap,
    required this.currentPage,
    required this.pages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
              color: currentPage == pages ? HRMSColors.green : Colors.white,
              border: currentPage != pages
                  ? Border.all(width: 1, color: HRMSColors.green)
                  : null),
          child: Center(
              child: Text(
            pages,
            style: currentPage != pages
                ? const TextStyle(color: Colors.black)
                : const TextStyle(color: Colors.white),
          ))),
    );
  }
}
