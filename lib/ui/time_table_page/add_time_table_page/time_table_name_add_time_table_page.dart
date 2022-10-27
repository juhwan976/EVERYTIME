import 'package:everytime/component/time_table_page/custom_text_field.dart';
import 'package:flutter/material.dart';

class TimeTableNameAddTimeTablePage extends StatelessWidget {
  const TimeTableNameAddTimeTablePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CustomTextField(),
        ),
      ],
    );
  }
}
