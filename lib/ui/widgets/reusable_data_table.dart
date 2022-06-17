import 'package:flutter/material.dart';

class ReusableDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? height;
  const ReusableDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: DataTable(
          dataRowHeight: height,
          showCheckboxColumn: false,
          dataTextStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          showBottomBorder: false,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.lightGreen,
                width: 4,
              ),
            ),
          ),
          // dataRowHeight: 100,
          columnSpacing: 12,
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}