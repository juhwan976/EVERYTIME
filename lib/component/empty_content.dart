import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key? key,
    required this.icon,
    required this.title,
    required this.contentIsString,
    this.contentString,
    this.content,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final bool contentIsString;
  final String? contentString;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).hintColor,
            size: 50,
          ),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: appHeight * 0.005,
          ),
          (contentIsString)
              ? Text(
                  contentString ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 14.5,
                  ),
                )
              : content ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
