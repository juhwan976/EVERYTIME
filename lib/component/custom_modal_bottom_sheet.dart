import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet({
    Key? key,
    required this.buttonList,
  }) : super(key: key);

  final List<CustomModalBottomSheetButton> buttonList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeight * 0.085 + (appHeight * 0.06 * buttonList.length),
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Column(
          children: List.generate(
            buttonList.length,
            (index) {
              return Container(
                height: appHeight * 0.04,
                margin: EdgeInsets.only(
                  top: appHeight * 0.02,
                ),
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: appWidth * 0.065,
                          right: appWidth * 0.065,
                        ),
                        child: Icon(
                          buttonList.elementAt(index).icon,
                          color: Theme.of(context).highlightColor,
                          size: 24,
                        ),
                      ),
                      Text(
                        buttonList.elementAt(index).title,
                        style: TextStyle(
                          color: Theme.of(context).highlightColor,
                          fontSize: 20.5,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    buttonList.elementAt(index).onPressed?.call();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomModalBottomSheetButton {
  final IconData icon;
  final String title;
  final Function? onPressed;

  CustomModalBottomSheetButton({
    required this.icon,
    required this.title,
    this.onPressed,
  });
}
