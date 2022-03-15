import 'package:flutter/material.dart';

class SelectDateWidget extends StatelessWidget {
  final Function() onTap;
  final Function() clearDate;
  final TextEditingController dateTimeController;

  const SelectDateWidget({
    Key? key,
    required this.onTap,
    required this.clearDate,
    required this.dateTimeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              enabled: false,
              validator: (String? arg) {
                if (arg!.isEmpty)
                  return 'Выберите дату';
                else
                  return null;
              },
              controller: dateTimeController,
              decoration: InputDecoration(
                hintText: 'Выберите дату',
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: dateTimeController.text == ''
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                      child: InkWell(
                          onTap: onTap,
                          child: const Icon(Icons.calendar_today_rounded)),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                      child: InkWell(
                          onTap: clearDate,
                          child: const Icon(Icons.close_rounded)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
