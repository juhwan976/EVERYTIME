import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    Key? key,
    required this.buttonList,
    required this.title,
  }) : super(key: key);

  final List<Widget> buttonList;
  final String title;

  final double _appBarHeight = appHeight * 0.057;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _appBarHeight,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        left: appWidth * 0.065,
        right: appWidth * 0.065,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttonList,
          ),
        ],
      ),
    );
  }
}
