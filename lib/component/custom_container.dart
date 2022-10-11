import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    required this.height,
    required this.child,
    this.usePadding = true,
  }) : super(key: key);

  final double height;
  final Widget child;
  final bool usePadding;

  //* right, left padding : appWidth * 0.05

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(
        right: appWidth * 0.02,
        left: appWidth * 0.02,
        bottom: appWidth * 0.02,
      ),
      padding: usePadding
          ? EdgeInsets.only(
              top: appHeight * 0.03,
              bottom: appHeight * 0.03,
            )
          : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: child,
    );
  }
}
