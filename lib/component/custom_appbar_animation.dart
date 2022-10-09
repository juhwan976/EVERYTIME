import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomAppBarAnimation extends StatelessWidget {
  const CustomAppBarAnimation({
    Key? key,
    required this.scrollOffsetStream,
    required this.title,
  }) : super(key: key);

  final Stream<double> scrollOffsetStream;
  final String title;

  double _calHeight(double scrollOffset) {
    if (scrollOffset >= appHeight * 0.02) {
      return appHeight * 0.033;
    } else if (scrollOffset <= 0) {
      return appHeight * 0.053;
    } else {
      return (appHeight * 0.02 - scrollOffset) + appHeight * 0.033;
    }
  }

  double _calOpacity(double scrollOffset) {
    if (scrollOffset >= appHeight * 0.02) {
      return 0;
    } else if (scrollOffset <= 0) {
      return 1;
    } else {
      return (appHeight * 0.02 - scrollOffset) / (appHeight * 0.02);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: scrollOffsetStream,
      builder: (context, AsyncSnapshot<double> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: _calHeight(snapshot.data as double),
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(
              left: appWidth * 0.065,
            ),
            color: Colors.white,
            child: Text(
              title,
              style: TextStyle(
                color: Color.fromRGBO(
                  160,
                  0,
                  0,
                  _calOpacity(snapshot.data as double),
                ),
                fontSize: 14.5,
              ),
            ),
          );
        }

        return Container(
          height: appHeight * 0.053,
          color: Colors.white,
        );
      },
    );
  }
}
