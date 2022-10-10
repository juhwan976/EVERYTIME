import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomAppBarButton extends StatelessWidget {
  CustomAppBarButton({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final Function? onPressed;

  final double _appBarHeight = appHeight * 0.057;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: appWidth * 0.07,
      height: _appBarHeight,
      margin: EdgeInsets.only(
        left: appWidth * 0.055,
      ),
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.only(
          bottom: appHeight * 0.02,
        ),
        child: Icon(
          icon,
          color: Theme.of(context).highlightColor,
        ),
        onPressed: () {
          onPressed?.call();
        },
      ),
    );
  }
}
