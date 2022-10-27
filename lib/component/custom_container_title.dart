import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomContainerTitle extends StatelessWidget {
  const CustomContainerTitle({
    Key? key,
    required this.title,
    required this.type,
    this.buttonIcon,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final CustomContainerTitleType type;
  final IconData? buttonIcon;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeight * 0.03,
      margin: EdgeInsets.only(
        bottom: appHeight * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: appWidth * 0.05,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).highlightColor,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          (type == CustomContainerTitleType.none)
              ? const SizedBox.shrink()
              : Container(
                  width: (type == CustomContainerTitleType.button)
                      ? appWidth * 0.11
                      : appWidth * 0.19,
                  alignment: Alignment.centerRight,
                  child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.only(
                      right: appWidth * 0.05,
                    ),
                    child: (type == CustomContainerTitleType.button)
                        ? Icon(
                            buttonIcon,
                            color: Theme.of(context).highlightColor,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '더 보기',
                                style: TextStyle(
                                  color: Theme.of(context).focusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Theme.of(context).focusColor,
                                size: 13,
                              ),
                            ],
                          ),
                    onPressed: () {
                      onPressed?.call();
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

enum CustomContainerTitleType { button, text, none }
