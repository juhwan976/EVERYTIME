import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomTabBarButton extends StatelessWidget {
  const CustomTabBarButton({
    Key? key,
    required this.title,
    required this.index,
    required this.currentIndex,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final int index;
  final int currentIndex;
  final Function? onPressed;

  final inActiveIconColor = const Color.fromRGBO(208, 208, 208, 1);
  final activeIconColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: appWidth * 0.05 * title.length + appWidth * 0.035,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: appHeight * 0.015,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 27,
                  color: (index == currentIndex)
                      ? activeIconColor
                      : inActiveIconColor,
                  fontWeight: (index == currentIndex)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            Container(
              height: 1.5,
              width: appWidth * 0.05 * title.length,
              color: (index == currentIndex) ? activeIconColor : null,
            ),
          ],
        ),
        onPressed: () {
          onPressed?.call();
        },
      ),
    );
  }
}
