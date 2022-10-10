import 'package:flutter/material.dart';

class AlarmAlarmPage extends StatelessWidget {
  const AlarmAlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'alarm alarm page',
          style: TextStyle(
            color: Theme.of(context).highlightColor,
          ),
        ),
      ),
    );
  }
}
