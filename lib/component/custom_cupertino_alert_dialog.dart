import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCupertinoAlertDialog extends StatelessWidget {
  const CustomCupertinoAlertDialog({
    Key? key,
    required this.isDarkStream,
    this.title = '',
    this.hasTextField = false,
    this.autoFocus = false,
    this.textEditingController,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.content,
    this.actions,
  }) : super(key: key);

  final Stream<bool> isDarkStream;
  final String title;
  final bool hasTextField;
  final bool autoFocus;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: isDarkStream,
      builder: (streamBuilderContext, snapshot) {
        if (snapshot.hasData) {
          return Theme(
            data: snapshot.data! ? ThemeData.dark() : ThemeData.light(),
            child: CupertinoAlertDialog(
              title: Text(
                title,
              ),
              content: hasTextField
                  ? Container(
                      margin: EdgeInsets.only(
                        top: appHeight * 0.025,
                      ),
                      child: CupertinoTextField(
                        controller: textEditingController,
                        autofocus: autoFocus,
                        keyboardType: keyboardType,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          color: snapshot.data! ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      ),
                    )
                  : (content ?? const SizedBox.shrink()),
              actions: actions ?? [],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
