import 'dart:async';

import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/bloc/grade_calculator_bloc.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page/appbar_at_grade_calculator_page.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page/information_at_grade_calculator_page.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page/keyboard_action_at_grade_calculator_page.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page/picker_bottom_padding_at_grade_calculator_page.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page/subjects_chart_at_grade_calculator_page.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page/summery_of_term_at_grade_calculator_page.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page/term_list_at_grade_calculator_page.dart';
import 'package:flutter/material.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

class GradeCalculatorPage extends StatefulWidget {
  const GradeCalculatorPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  State<GradeCalculatorPage> createState() => _GradeCalculatorPageState();
}

class _GradeCalculatorPageState extends State<GradeCalculatorPage> {
  final _listScrollController = ScrollController();
  final _termScrollController = ScrollController();

  final _targetCreditController = TextEditingController();

  final _gradeCalculatorBloc = GradeCalculatorBloc();

  @override
  initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      _gradeCalculatorBloc.updateDelay(true);
    });
  }

  @override
  dispose() {
    super.dispose();

    _listScrollController.dispose();
    _termScrollController.dispose();
    _targetCreditController.dispose();
    _gradeCalculatorBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollsToTop(
      onScrollsToTop: (event) async {
        /// 지금은 필요없는것 같아서 안씀.
        // if (!widget.isOnScreen) return;

        if (_listScrollController.hasClients) {
          _listScrollController.animateTo(
            event.to,
            duration: event.duration,
            curve: event.curve,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AappBarAtGradeCalculatorPage(
                pageContext: context,
              ),
              TermListAtGradeCalculatorPage(
                termScrollController: _termScrollController,
                gradeCalculatorBloc: _gradeCalculatorBloc,
                userBloc: widget.userBloc,
              ),
              StreamBuilder(
                stream: _gradeCalculatorBloc.delay,
                builder: (_, delaySnapshot) {
                  if (delaySnapshot.hasData) {
                    return Expanded(
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        controller: _listScrollController,
                        children: [
                          InformationAtGradeCalculatorPage(
                            userBloc: widget.userBloc,
                            targetCreditController: _targetCreditController,
                          ),
                          SummeryOfTermAtGradeCalculatorPage(
                            userBloc: widget.userBloc,
                            gradeCalculatorBloc: _gradeCalculatorBloc,
                          ),
                          SubjectsChartAtGradeCalculatorPage(
                            userBloc: widget.userBloc,
                            gradeCalculatorBloc: _gradeCalculatorBloc,
                            listScrollController: _listScrollController,
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              PickerBottomPaddingAtGradeCalculatorPage(
                gradeCalculatorBloc: _gradeCalculatorBloc,
              ),
              KeyboardActionAtGradeCalculatorPage(
                userBloc: widget.userBloc,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
