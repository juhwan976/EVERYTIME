import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class AappBarAtGradeCalculatorPage extends StatelessWidget {
  const AappBarAtGradeCalculatorPage({
    Key? key,
    required this.pageContext,
  }) : super(key: key);

  final BuildContext pageContext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.055,
      width: appWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: appWidth * 0.15,
          ),
          const Text(
            '학점계산기',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          SizedBox(
            width: appWidth * 0.15,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.clear,
                color: Theme.of(context).highlightColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
