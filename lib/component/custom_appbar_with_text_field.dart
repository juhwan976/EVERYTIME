import 'package:everytime/bloc/custom_appbar_with_text_field_bloc.dart';
import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBarWithTextField extends StatefulWidget {
  const CustomAppBarWithTextField({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  State<CustomAppBarWithTextField> createState() =>
      _CustomAppBarWithTextFieldState();
}

class _CustomAppBarWithTextFieldState extends State<CustomAppBarWithTextField> {
  final TextEditingController textEditingController = TextEditingController();

  final bloc = CustomAppBarWithTextFieldBloc();

  @override
  void dispose() {
    super.dispose();

    textEditingController.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeight * 0.055,
      margin: EdgeInsets.only(
        left: appWidth * 0.04,
        right: appWidth * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: appHeight * 0.045,
            width: appWidth * 0.8,
            child: CupertinoTextField(
              controller: textEditingController,
              prefix: Padding(
                padding: EdgeInsets.only(
                  left: appWidth * 0.015,
                  right: appWidth * 0.015,
                ),
                child: Icon(
                  Icons.search_outlined,
                  color: Theme.of(context).hintColor,
                ),
              ),
              suffix: StreamBuilder(
                stream: bloc.visibleSuffix,
                builder: (_, visibleSuffixSnapshot) {
                  if (visibleSuffixSnapshot.hasData) {
                    if (visibleSuffixSnapshot.data!) {
                      return IconButton(
                        padding: EdgeInsets.zero,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(
                          Icons.highlight_off_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                        onPressed: () {
                          textEditingController.clear();
                          bloc.updateVisibleSuffix(false);
                        },
                      );
                    }
                  }

                  return const SizedBox.shrink();
                },
              ),
              maxLines: 1,
              padding: EdgeInsets.only(),
              placeholder: '글 제목, 내용, 해시태그',
              placeholderStyle: TextStyle(
                fontSize: 19,
                color: Theme.of(context).hintColor,
              ),
              autofocus: true,
              cursorColor: Theme.of(context).highlightColor,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              onSubmitted: (value) {
                _checkValidate(context, value);
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  bloc.updateVisibleSuffix(true);
                } else {
                  bloc.updateVisibleSuffix(false);
                }
              },
            ),
          ),
          SizedBox(
            width: appWidth * 0.1,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(
                '취소',
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _checkValidate(BuildContext context, String value) {
    if (value.length < 2) {
      _showValidateDialog(context);
    } else {
      // 추가 예정
    }
  }

  void _showValidateDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
          title: '두 글자 이상 입력해주세요.',
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('닫기'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}
