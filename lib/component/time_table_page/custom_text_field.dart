import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.controller,
    this.maxLines,
    this.autofocus = false,
    this.scrollPadding = const EdgeInsets.all(20),
    this.textInputAction = TextInputAction.done,
    this.hintText,
    this.isDense,
    this.isHintBold = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  final TextEditingController? controller;
  final int? maxLines;
  final bool autofocus;
  final EdgeInsets scrollPadding;
  final TextInputAction textInputAction;
  final String? hintText;
  final bool? isDense;
  final bool isHintBold;
  final Function? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      scrollPadding: scrollPadding,
      textInputAction: textInputAction,
      autofocus: autofocus,
      decoration: InputDecoration(
        isDense: isDense,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 21,
          fontWeight: isHintBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      style: const TextStyle(
        fontSize: 21,
      ),
      cursorColor: Theme.of(context).focusColor,
      onChanged: (value) {
        onChanged?.call(value);
      },
      onTap: () {
        onTap?.call();
      },
      onSubmitted: (value) {
        onSubmitted?.call(value);
      },
    );
  }
}
