import 'package:flutter/material.dart';

class BoardPartyPage extends StatelessWidget {
  const BoardPartyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'board party page',
        style: TextStyle(
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}
