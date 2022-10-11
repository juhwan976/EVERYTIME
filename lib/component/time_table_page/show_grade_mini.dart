import 'package:flutter/material.dart';

class ShowGradeMini extends StatelessWidget {
  const ShowGradeMini({
    Key? key,
    required this.title,
    required this.current,
    required this.max,
  }) : super(key: key);

  final String title;
  final String current;
  final String max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title ',
          style: TextStyle(
            fontSize: 19,
            color: Theme.of(context).highlightColor,
          ),
        ),
        Text(
          current,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).focusColor,
          ),
        ),
        Text(
          '/ $max',
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }
}
