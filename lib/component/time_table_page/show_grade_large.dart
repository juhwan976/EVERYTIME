import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class ShowGradeLarge extends StatelessWidget {
  const ShowGradeLarge({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.totalValue,
    this.isShowButton = false,
    this.icon = Icons.settings,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final String currentValue;
  final String totalValue;
  final bool isShowButton;
  final IconData icon;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: appWidth * 0.225,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: appHeight * 0.01,
          ),
          (!isShowButton)
              ? Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: currentValue,
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        children: [
                          TextSpan(
                            text: ' / $totalValue',
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  height: appHeight * 0.03,
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    minWidth: appWidth * 0.022,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: currentValue,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            children: [
                              TextSpan(
                                text: ' / $totalValue',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            icon,
                            size: 10,
                            color: Theme.of(context).hintColor,
                          ),
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
