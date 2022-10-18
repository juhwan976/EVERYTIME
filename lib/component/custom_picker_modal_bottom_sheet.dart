import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPickerModalBottomSheet extends StatelessWidget {
  CustomPickerModalBottomSheet({
    Key? key,
    required this.title,
    this.onPressedCancel,
    this.onPressedSave,
    required this.picker,
  }) : super(key: key);

  final String title;
  final Function? onPressedCancel;
  final Function? onPressedSave;
  final Widget picker;

  final _selectGradeSheetHeight = appHeight * 0.4;

  //TODO: 이거 좀 바꿔야할듯?
  static double get sheetHeight => 768 * 0.4;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: _selectGradeSheetHeight,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: const Text(
                  '취소',
                  style: TextStyle(
                    fontSize: 17.5,
                  ),
                ),
                onPressed: () {
                  onPressedCancel?.call();
                },
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              CupertinoButton(
                child: const Text(
                  '저장',
                  style: TextStyle(
                    fontSize: 17.5,
                  ),
                ),
                onPressed: () {
                  onPressedSave?.call();
                },
              ),
            ],
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          Expanded(
            child: picker,
          ),
        ],
      ),
    );
  }
}
