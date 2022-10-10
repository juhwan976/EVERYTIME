import 'package:flutter/material.dart';

class BoardBoardPage extends StatelessWidget {
  const BoardBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'board board page',
        style: TextStyle(
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}
