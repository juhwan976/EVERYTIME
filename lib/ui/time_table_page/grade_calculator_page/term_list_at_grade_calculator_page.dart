import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/bloc/grade_calculator_bloc.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class TermListAtGradeCalculatorPage extends StatelessWidget {
  const TermListAtGradeCalculatorPage({
    Key? key,
    required this.termScrollController,
    required this.gradeCalculatorBloc,
    required this.userBloc,
  }) : super(key: key);

  final ScrollController termScrollController;
  final GradeCalculatorBloc gradeCalculatorBloc;
  final EverytimeUserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.065,
      child: StreamBuilder(
        stream: gradeCalculatorBloc.currentTerm,
        builder: (streamContext, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              controller: termScrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                left: appWidth * 0.04,
                right: appWidth * 0.04,
              ),
              itemCount: userBloc.getTermsLength,
              itemBuilder: (listViewContext, index) => SizedBox(
                width: (userBloc.getTerm(index).term.length == 7)
                    ? appWidth * 0.205
                    : appWidth * 0.165,
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userBloc.getTerm(index).term,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: (snapshot.data! == index)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Container(
                        height: 2,
                        width: appWidth *
                                0.0215 *
                                userBloc.getTerm(index).term.length +
                            appWidth * 0.02,
                        margin: EdgeInsets.only(top: appHeight * 0.005),
                        color: (index == snapshot.data!)
                            ? Theme.of(context).highlightColor
                            : null,
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (FocusScope.of(context).hasFocus) {
                      FocusScope.of(context).unfocus();
                      _hideKeyboardAction();
                    }

                    userBloc.getTerm(snapshot.data!).removeEmptySubjects();
                    gradeCalculatorBloc.updateCurrentTerm(index);

                    //TODO: 나중에 글자 수가 다른 학기가 추가된다면 수정해야 할 수도 있다.
                    if (termScrollController.position.maxScrollExtent <
                        appWidth * 0.205 * index) {
                      termScrollController.jumpTo(
                          termScrollController.position.maxScrollExtent);
                    } else {
                      termScrollController.jumpTo(appWidth * 0.205 * index);
                    }
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _hideKeyboardAction() {
    userBloc.updateIsShowingKeyboard(false);
  }
}
