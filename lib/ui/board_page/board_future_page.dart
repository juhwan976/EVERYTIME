import 'package:flutter/material.dart';

class BoardFuturePage extends StatelessWidget {
  const BoardFuturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'board future page',
        style: TextStyle(
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}
