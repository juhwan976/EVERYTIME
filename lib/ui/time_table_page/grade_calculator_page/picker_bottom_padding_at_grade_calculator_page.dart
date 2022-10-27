import 'package:everytime/bloc/grade_calculator_bloc.dart';
import 'package:everytime/component/custom_picker_modal_bottom_sheet.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class PickerBottomPaddingAtGradeCalculatorPage extends StatelessWidget {
  const PickerBottomPaddingAtGradeCalculatorPage({
    Key? key,
    required this.gradeCalculatorBloc,
  }) : super(key: key);

  final GradeCalculatorBloc gradeCalculatorBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: gradeCalculatorBloc.isShowingSelectGrade,
      builder: (isShowingSelecteGradeContext, isShowingSelectGradeSnapshot) {
        if (isShowingSelectGradeSnapshot.hasData) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isShowingSelectGradeSnapshot.data!
                ? CustomPickerModalBottomSheet.sheetHeight - paddingBottom
                : 0,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
