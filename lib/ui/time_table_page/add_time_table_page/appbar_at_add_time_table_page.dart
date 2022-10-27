import 'package:everytime/component/time_table_page/round_button.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class AppBarAtAddTimeTablePage extends StatelessWidget {
  const AppBarAtAddTimeTablePage({
    Key? key,
    required this.pageContext,
  }) : super(key: key);

  final BuildContext pageContext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.055,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: appWidth * 0.15,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(Icons.clear_outlined),
              onPressed: () {
                Navigator.pop(pageContext);
              },
            ),
          ),
          const Text(
            '새 시간표 만들기',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          RoundButton(
            title: '완료',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
