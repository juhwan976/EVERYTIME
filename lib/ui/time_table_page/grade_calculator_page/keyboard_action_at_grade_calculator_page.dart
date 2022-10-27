import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeyboardActionAtGradeCalculatorPage extends StatelessWidget {
  const KeyboardActionAtGradeCalculatorPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userBloc.isShowingKeyboard,
      builder: (_, isShowingKeyboardSnapshot) {
        if (isShowingKeyboardSnapshot.hasData) {
          return Visibility(
            visible: isShowingKeyboardSnapshot.data!,
            child: Container(
              color: Theme.of(context).backgroundColor,
              alignment: Alignment.centerRight,
              height: isShowingKeyboardSnapshot.data!
                  ? paddingBottom + appHeight * 0.015
                  : 0,
              child: CupertinoButton(
                child: const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                onPressed: () {
                  _hideKeyboardAction();
                  if (primaryFocus?.hasFocus ?? false) {
                    primaryFocus?.unfocus();
                  }
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _hideKeyboardAction() {
    userBloc.updateIsShowingKeyboard(false);
  }
}
