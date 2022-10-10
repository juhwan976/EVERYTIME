import 'package:flutter/material.dart';

class BoardPRPage extends StatelessWidget {
  const BoardPRPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'board pr page',
        style: TextStyle(
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}
