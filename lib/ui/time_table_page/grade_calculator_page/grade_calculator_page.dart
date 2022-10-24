import 'dart:async';

import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/bloc/grade_calculator_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/custom_picker_modal_bottom_sheet.dart';
import 'package:everytime/component/time_table_page/show_grade_large.dart';
import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/bar_chart_data.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// ### 문제점
/// GradeType은 수정하는 과정에서 똑같이 일반 변수를 수정해도 바로 값 갱신이 된다.
///
/// 반면 isMajor은 수정하더라도 바로 값 갱신이 안된다.
///
/// GradeType의 경우 이 항목을 선택했는지를 판별하는 BehvaiorSubject를 구독중이라서
/// 그 값의 갱신으로 인해서 항목이 갱신이 된다.
///
/// IsMajor의 경우 다른 것을 구독하지 않기 때문에 값 갱신이 안된다.
///
/// ### 해결방안
/// 1. isMajor를 bool?에서 BehaviorSubject<bool>로 변경
/// 2. isMajor를 보여주는 Checkbox의 onChange안에 setState 를 넣는다.
///
/// ### 현재 사용중인 방법
/// 2번의 setState를 사용중.
///
/// 아직 어떤 방법이 더 좋은지 잘 모르겠다.
///
/// 하지만 bloc 패턴을 적용중이므로, 만약 statelessWidget을 선언했다면 강제적으로
/// 1번방법을 사용했을 것 같지만, 현재는 다크모드 때문에 StatefulsWidget을 사용중이다.
///
/// BehaviorSubject에 들어가는 값이 배열이고, 그 안에 일반 변수가 있다면,
/// 그 값을 갱신해도 다른 구독중인 아이들에게는 알림이 가지 않는다
///
/// 강제로 현재값을 새로 갱신해주면 사용가능.
///
/// ### 개인적인 생각
/// 얼마전에 BehaviorSubject 안에 BehaviorSubject가 있는게 이상하다고
/// 생각해서 SubjectInfo의 구조를 변경했는데 이런 경우가 있을 줄은 알았지만,
/// 막상 진짜로 당해보니 BehaviorSubject 안에 다른 BehaviorSubject가 있다는게
/// 이상한 일이 아닐수도 있다는 생각이 들었다.
///
/// 어쩌면 당연한 일이 아닐까?
///
/// 다음번에 비슷한 경우가 있다면, 그때는 망설이지말자.
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
  final _delay = BehaviorSubject<bool>();

  final _pageScrollController = ScrollController();
  final _termScrollController = ScrollController();
  final _targetCreditController = TextEditingController();

  final _gradeCalculatorBloc = GradeCalculatorBloc();

  final List<Color> _barChartColorData = [
    const Color.fromRGBO(220, 130, 105, 1),
    const Color.fromRGBO(224, 194, 94, 1),
    const Color.fromRGBO(158, 191, 97, 1),
    const Color.fromRGBO(140, 200, 186, 1),
    const Color.fromRGBO(120, 143, 216, 1),
  ];

  void _showKeyboardAction() {
    widget.userBloc.updateIsShowingKeyboard(true);
  }

  void _hideKeyboardAction() {
    widget.userBloc.updateIsShowingKeyboard(false);
  }

  void _buildResetDataDialog(int currentTermIndex) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
          title:
              '${widget.userBloc.getTerm(currentTermIndex).term} 정보를\n초기화하시겠습니까?',
          actions: [
            CupertinoButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            CupertinoButton(
              child: const Text('예'),
              onPressed: () {
                widget.userBloc
                    .getTerm(currentTermIndex)
                    .removeAdditionalSubjects();
                for (int i = 0;
                    i <
                        widget.userBloc
                            .getTerm(currentTermIndex)
                            .currentSubjects
                            .length;
                    i++) {
                  widget.userBloc.getTerm(currentTermIndex).setDefault(i);
                }
                widget.userBloc.updateData();
                // TextField 때문에 여기서만 setState 사용
                setState(() {});
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  void _buildSelectGradeSheet(int currentTermIndex, int currentIndex,
      GradeType currentGradeType, TapPosition position) {
    _gradeCalculatorBloc.updateIsShowingSelectGrade(true);
    widget.userBloc.updateIsShowingKeyboard(false);

    if (position.global.dy >=
        (appHeight - CustomPickerModalBottomSheet.sheetHeight)) {
      Future.delayed(
        const Duration(milliseconds: 350),
        () {
          _pageScrollController.animateTo(
              (position.global.dy -
                  (appHeight - CustomPickerModalBottomSheet.sheetHeight) +
                  _pageScrollController.offset),
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        },
      );
    }

    showModalBottomSheet(
      elevation: 0,
      barrierColor: Colors.transparent,
      isDismissible: true,
      enableDrag: false,
      context: context,
      builder: (popupContext) {
        int selected = GradeType.getIndex(currentGradeType);
        return CustomPickerModalBottomSheet(
          title: '성적을 선택해주세요',
          onPressedCancel: () {
            Navigator.pop(popupContext);
          },
          onPressedSave: () {
            widget.userBloc.getTerm(currentTermIndex).updateSubject(
                  currentIndex - 1,
                  gradeType: GradeType.getByIndex(selected),
                  isPNP: (GradeType.getByIndex(selected) == GradeType.p)
                      ? true
                      : null,
                );
            widget.userBloc.updateData();

            Navigator.pop(popupContext);
          },
          picker: CupertinoPicker(
            itemExtent: appHeight * 0.05,
            scrollController: FixedExtentScrollController(
              initialItem: GradeType.getIndex(currentGradeType),
            ),
            children: List.generate(
              11,
              (index) {
                return Center(
                  child: Text(GradeType.getGradeElementAt(index)),
                );
              },
            ),
            onSelectedItemChanged: (index) {
              selected = index;
            },
          ),
        );
      },
    ).whenComplete(() {
      _gradeCalculatorBloc.updateIsShowingSelectGrade(false);
      _gradeCalculatorBloc.updateCurrentSelectingIndex(null);
    });
  }

  Widget _buildEditSubjectsIndexRemain(BuildContext context,
      int currentTermIndex, int currentSubjectsLength, int currentIndex) {
    return Row(
      children: [
        //과목명
        Container(
          width: appWidth * 0.47,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            color: Theme.of(context).cardColor,
          ),
          child: Center(
            child: StreamBuilder(
              stream: widget.userBloc.getTerm(currentTermIndex).subjects,
              builder: (_, subjectsSnapshot) {
                if (subjectsSnapshot.hasData) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      left: appWidth * 0.04,
                      right: appWidth * 0.04,
                    ),
                    child: CupertinoTextField(
                      controller: TextEditingController(
                        text: subjectsSnapshot.data![currentIndex - 1].title,
                      ),
                      padding: EdgeInsets.zero,
                      cursorColor: Theme.of(context).highlightColor,
                      decoration: const BoxDecoration(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).highlightColor,
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        widget.userBloc
                            .getTerm(currentTermIndex)
                            .updateSubject(currentIndex - 1, title: value);
                      },
                      onSubmitted: (value) {
                        widget.userBloc
                            .getTerm(currentTermIndex)
                            .updateSubject(currentIndex - 1, title: value);
                        widget.userBloc.updateData();
                      },
                      onTap: _showKeyboardAction,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        //학점
        Container(
          width: appWidth * 0.16,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            color: Theme.of(context).cardColor,
          ),
          child: Center(
            child: StreamBuilder(
              stream: widget.userBloc.getTerm(currentTermIndex).subjects,
              builder: (_, subjectsSnapshot) {
                if (subjectsSnapshot.hasData) {
                  return CupertinoTextField(
                    controller: TextEditingController(
                      text: subjectsSnapshot.data![currentIndex - 1].credit
                          .toString(),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    padding: EdgeInsets.zero,
                    cursorColor: Theme.of(context).highlightColor,
                    decoration: const BoxDecoration(),
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).highlightColor,
                    ),
                    onChanged: (value) {
                      widget.userBloc.getTerm(currentTermIndex).updateSubject(
                          currentIndex - 1,
                          credit: int.parse(value.isEmpty ? '0' : value));
                      widget.userBloc.updateData();
                    },
                    onSubmitted: (value) {
                      widget.userBloc.getTerm(currentTermIndex).updateSubject(
                          currentIndex - 1,
                          credit: int.parse(value.isEmpty ? '0' : value));
                      widget.userBloc.updateData();
                    },
                    onTap: _showKeyboardAction,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        //성적
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: StreamBuilder(
            stream: widget.userBloc.getTerm(currentTermIndex).subjects,
            builder: (_, subjectsSnapshot) {
              if (subjectsSnapshot.hasData) {
                return PositionedTapDetector2(
                  child: Container(
                    width: appWidth * 0.16,
                    height: appHeight * 0.0520625,
                    alignment: Alignment.center,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: StreamBuilder(
                      stream: _gradeCalculatorBloc.currentSelectingIndex,
                      builder: (currentSelectingIndexContext,
                          currentSelectingIndexSnapshot) {
                        return Text(
                          subjectsSnapshot
                              .data![currentIndex - 1].gradeType.data,
                          style: (currentSelectingIndexSnapshot.data != null)
                              ? (currentSelectingIndexSnapshot.data! ==
                                      currentIndex
                                  ? TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).focusColor,
                                    )
                                  : const TextStyle(
                                      fontSize: 17,
                                    ))
                              : const TextStyle(
                                  fontSize: 17,
                                ),
                        );
                      },
                    ),
                  ),
                  onTap: (position) async {
                    if (FocusScope.of(context).hasFocus) {
                      //log('has Focus');
                      FocusScope.of(context).unfocus();
                      // await keyboard animation
                      await Future.delayed(const Duration(milliseconds: 350));
                    }
                    _buildSelectGradeSheet(
                        currentTermIndex,
                        currentIndex,
                        subjectsSnapshot.data![currentIndex - 1].gradeType,
                        position);
                    _gradeCalculatorBloc
                        .updateCurrentSelectingIndex(currentIndex);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        //전공
        Expanded(
          child: Center(
            child: StreamBuilder(
              stream: widget.userBloc.getTerm(currentTermIndex).subjects,
              builder: (_, subjectsSnapshot) {
                if (subjectsSnapshot.hasData) {
                  return Checkbox(
                    value: subjectsSnapshot.data![currentIndex - 1].isMajor,
                    activeColor: Theme.of(context).focusColor,
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.5,
                        color: Theme.of(context).dividerColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged: (newValue) {
                      widget.userBloc
                          .getTerm(currentTermIndex)
                          .updateSubject(currentIndex - 1, isMajor: newValue!);

                      setState(() {});

                      widget.userBloc.updateData();
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditSubjectsIndexLast(
      BuildContext context, int currentTermIndex, int currentSubjectsLength) {
    return Container(
      padding: EdgeInsets.only(
        right: appWidth * 0.04,
        left: appWidth * 0.04,
      ),
      child: Row(
        children: [
          SizedBox(
            width: appWidth * 0.15,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Text(
                '더 입력하기',
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                widget.userBloc.getTerm(currentTermIndex).addSubject();
              },
            ),
          ),
          SizedBox(width: appWidth * 0.04),
          SizedBox(
            width: appWidth * 0.1,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Text(
                '초기화',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _buildResetDataDialog(currentTermIndex);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditSubjectsIndexFirst(
      BuildContext context, int currentTermIndex, int currentSubjectsLength) {
    return Row(
      children: [
        Container(
          width: appWidth * 0.47,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Center(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                left: appWidth * 0.04,
              ),
              child: Text(
                '과목명',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 17.5,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: appWidth * 0.16,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Center(
            child: Text(
              '학점',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 17.5,
              ),
            ),
          ),
        ),
        Container(
          width: appWidth * 0.16,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Center(
            child: Text(
              '성적',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 17.5,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '전공',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 17.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditSubjects(
      BuildContext context, int currentTermIndex, int currentSubjectsLength) {
    return Column(
      children: List.generate(
        currentSubjectsLength + 2,
        (index) {
          return Container(
            height: appHeight * 0.0520625,
            decoration: BoxDecoration(
              border: Border(
                bottom: (index + 1 == currentSubjectsLength + 2)
                    ? BorderSide.none
                    : BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
              ),
            ),
            child: (index == 0)
                ? (_buildEditSubjectsIndexFirst(
                    context, currentTermIndex, currentSubjectsLength))
                : ((index + 1 == currentSubjectsLength + 2)
                    ? (_buildEditSubjectsIndexLast(
                        context, currentTermIndex, currentSubjectsLength))
                    : (_buildEditSubjectsIndexRemain(context, currentTermIndex,
                        currentSubjectsLength, index))),
          );
        },
      ),
    );
  }

  void _buildEditTargetCreditDialog(
      BuildContext context, int currentTargetCredit) {
    _targetCreditController.text = currentTargetCredit.toString();
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
          title: '졸업 학점 설정',
          hasTextField: true,
          keyboardType: TextInputType.number,
          textEditingController: _targetCreditController,
          cursorColorType: CursorColorType.blackNWhite,
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('저장'),
              onPressed: () {
                widget.userBloc.updateTargetCredit(
                    int.parse(_targetCreditController.text));
                _targetCreditController.clear();
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      _delay.sink.add(true);
    });
  }

  @override
  dispose() {
    super.dispose();

    _pageScrollController.dispose();
    _termScrollController.dispose();
    _targetCreditController.dispose();
    _gradeCalculatorBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollsToTop(
      onScrollsToTop: (event) async {
        // if (!widget.isOnScreen) return;

        if (_pageScrollController.hasClients) {
          _pageScrollController.animateTo(
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
              SizedBox(
                height: appHeight * 0.055,
                width: appWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: appWidth * 0.15,
                    ),
                    const Text(
                      '학점계산기',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      width: appWidth * 0.15,
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Icon(
                          Icons.clear,
                          color: Theme.of(context).highlightColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: appHeight * 0.065,
                child: StreamBuilder(
                  stream: _gradeCalculatorBloc.currentTerm,
                  builder: (streamContext, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        controller: _termScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(
                          left: appWidth * 0.04,
                          right: appWidth * 0.04,
                        ),
                        itemCount: widget.userBloc.getTermsLength,
                        itemBuilder: (listViewContext, index) => SizedBox(
                          width:
                              (widget.userBloc.getTerm(index).term.length == 7)
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
                                  widget.userBloc.getTerm(index).term,
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
                                          widget.userBloc
                                              .getTerm(index)
                                              .term
                                              .length +
                                      appWidth * 0.02,
                                  margin:
                                      EdgeInsets.only(top: appHeight * 0.005),
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

                              widget.userBloc
                                  .getTerm(snapshot.data!)
                                  .removeEmptySubjects();
                              _gradeCalculatorBloc.updateCurrentTerm(index);

                              //TODO: 나중에 글자 수가 다른 학기가 추가된다면 수정해야 할 수도 있다.
                              if (_termScrollController
                                      .position.maxScrollExtent <
                                  appWidth * 0.205 * index) {
                                _termScrollController.jumpTo(
                                    _termScrollController
                                        .position.maxScrollExtent);
                              } else {
                                _termScrollController
                                    .jumpTo(appWidth * 0.205 * index);
                              }
                            },
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              StreamBuilder(
                stream: _delay.stream,
                builder: (_, delaySnapshot) {
                  if (delaySnapshot.hasData) {
                    return Expanded(
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        controller: _pageScrollController,
                        children: [
                          CustomContainer(
                            height: appHeight * 0.538,
                            child: Container(
                              padding: EdgeInsets.only(
                                left: appWidth * 0.05,
                                right: appWidth * 0.05,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      StreamBuilder(
                                        stream: widget.userBloc.totalGradeAve,
                                        builder: (totalGradeAveContext,
                                            totalGradeAveSnapshot) {
                                          if (totalGradeAveSnapshot.hasData) {
                                            return StreamBuilder(
                                              stream: widget.userBloc.maxAve,
                                              builder: (maxAveContext,
                                                  maxAveSnapshot) {
                                                if (maxAveSnapshot.hasData) {
                                                  return ShowGradeLarge(
                                                    title: '전체 평점',
                                                    currentValue:
                                                        totalGradeAveSnapshot
                                                            .data
                                                            .toString(),
                                                    totalValue: maxAveSnapshot
                                                        .data
                                                        .toString(),
                                                  );
                                                }

                                                return const SizedBox.shrink();
                                              },
                                            );
                                          }

                                          return const SizedBox.shrink();
                                        },
                                      ),
                                      StreamBuilder(
                                        stream: widget.userBloc.majorGradeAve,
                                        builder: (majorGradeAveContext,
                                            majorGradeAveSnapshot) {
                                          if (majorGradeAveSnapshot.hasData) {
                                            return StreamBuilder(
                                              stream: widget.userBloc.maxAve,
                                              builder: (maxAveContext,
                                                  maxAveSnapshot) {
                                                if (maxAveSnapshot.hasData) {
                                                  return ShowGradeLarge(
                                                    title: '전공 평점',
                                                    currentValue:
                                                        majorGradeAveSnapshot
                                                            .data
                                                            .toString(),
                                                    totalValue: maxAveSnapshot
                                                        .data
                                                        .toString(),
                                                  );
                                                }

                                                return const SizedBox.shrink();
                                              },
                                            );
                                          }

                                          return const SizedBox.shrink();
                                        },
                                      ),
                                      StreamBuilder(
                                        stream: widget.userBloc.currentCredit,
                                        builder: (currentCreditContext,
                                            currentCreditSnapshot) {
                                          if (currentCreditSnapshot.hasData) {
                                            return StreamBuilder(
                                              stream:
                                                  widget.userBloc.targetCredit,
                                              builder: (targetCreditContext,
                                                  targetCreditSnapshot) {
                                                if (targetCreditSnapshot
                                                    .hasData) {
                                                  return ShowGradeLarge(
                                                    title: '취득 학점',
                                                    currentValue:
                                                        currentCreditSnapshot
                                                            .data
                                                            .toString(),
                                                    totalValue:
                                                        targetCreditSnapshot
                                                            .data
                                                            .toString(),
                                                    isShowButton: true,
                                                    icon: Icons.settings,
                                                    onPressed: () {
                                                      _buildEditTargetCreditDialog(
                                                          context,
                                                          targetCreditSnapshot
                                                              .data!);
                                                    },
                                                  );
                                                }

                                                return const SizedBox.shrink();
                                              },
                                            );
                                          }

                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: appHeight * 0.05,
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 6,
                                          width: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).focusColor,
                                          ),
                                        ),
                                        Text(
                                          ' 전체',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).focusColor,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: appWidth * 0.025),
                                          height: 6,
                                          width: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        Text(
                                          ' 전공',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: appHeight * 0.21,
                                    child: StreamBuilder(
                                      stream: widget.userBloc.aveData,
                                      builder:
                                          (aveDataContext, aveDataSnapshot) {
                                        if (aveDataSnapshot.hasData) {
                                          return SfCartesianChart(
                                            primaryXAxis: CategoryAxis(
                                              maximumLabelWidth: 30,
                                              majorGridLines:
                                                  const MajorGridLines(
                                                      width: 0),
                                              majorTickLines:
                                                  const MajorTickLines(
                                                width: 0,
                                                size: 0,
                                              ),
                                              labelAlignment:
                                                  LabelAlignment.center,
                                              axisLine:
                                                  const AxisLine(width: 0),
                                              axisLabelFormatter:
                                                  (axisLabelRenderArgs) =>
                                                      ChartAxisLabel(
                                                '${aveDataSnapshot.data![axisLabelRenderArgs.value.round()].term?.split(' ')[0]}\n${aveDataSnapshot.data![axisLabelRenderArgs.value.round()].term?.split(' ')[1]}',
                                                TextStyle(
                                                  fontSize: 10,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              interval: 1,
                                              minimum: 0,
                                              maximum: 4.6,
                                              majorGridLines: MajorGridLines(
                                                width: 1,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                              majorTickLines:
                                                  const MajorTickLines(
                                                width: 0,
                                                size: 0,
                                              ),
                                              labelStyle: const TextStyle(
                                                fontSize: 10,
                                              ),
                                              axisLine:
                                                  const AxisLine(width: 0),
                                              axisLabelFormatter:
                                                  (axisLabelRenderArgs) =>
                                                      ChartAxisLabel(
                                                '${axisLabelRenderArgs.text}.0',
                                                TextStyle(
                                                  fontSize: 10,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                            plotAreaBorderWidth: 0,
                                            trackballBehavior:
                                                TrackballBehavior(
                                              enable: true,
                                              lineColor:
                                                  Theme.of(context).hintColor,
                                              activationMode:
                                                  ActivationMode.singleTap,
                                            ),
                                            series: [
                                              StackedLineSeries(
                                                color:
                                                    Theme.of(context).hintColor,
                                                markerSettings:
                                                    const MarkerSettings(
                                                  isVisible: true,
                                                ),
                                                groupName: '전공 학점',
                                                dataSource:
                                                    aveDataSnapshot.data!,
                                                xValueMapper: ((datum, index) =>
                                                    aveDataSnapshot
                                                        .data![index].term),
                                                yValueMapper: ((datum, index) =>
                                                    aveDataSnapshot.data![index]
                                                        .majorGrade),
                                              ),
                                              StackedLineSeries(
                                                color: Theme.of(context)
                                                    .focusColor,
                                                markerSettings:
                                                    const MarkerSettings(
                                                  isVisible: true,
                                                ),
                                                groupName: '평균 학점',
                                                dataSource:
                                                    aveDataSnapshot.data!,
                                                xValueMapper: ((datum, index) =>
                                                    aveDataSnapshot
                                                        .data![index].term),
                                                yValueMapper: ((datum, index) =>
                                                    aveDataSnapshot.data![index]
                                                        .totalGrade),
                                              ),
                                            ],
                                          );
                                        }

                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: StreamBuilder(
                                      stream: widget.userBloc.percentData,
                                      builder: (percentDataContext,
                                          percentDataSnapshot) {
                                        if (percentDataSnapshot.hasData) {
                                          return SfCartesianChart(
                                            plotAreaBorderWidth: 0,
                                            primaryXAxis: CategoryAxis(
                                              isInversed: true,
                                              maximumLabels: 4,
                                              borderWidth: 0,
                                              majorTickLines:
                                                  const MajorTickLines(
                                                width: 0,
                                                size: 3,
                                              ),
                                              majorGridLines:
                                                  const MajorGridLines(
                                                width: 0,
                                              ),
                                              axisLine: const AxisLine(
                                                width: 0,
                                              ),
                                              labelStyle: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              isVisible: false,
                                            ),
                                            series: [
                                              BarSeries<BarChartData, String>(
                                                width: 0.2,
                                                dataLabelSettings:
                                                    DataLabelSettings(
                                                  isVisible: true,
                                                  builder: (data,
                                                          point,
                                                          series,
                                                          pointIndex,
                                                          seriesIndex) =>
                                                      Text(
                                                    '${data.percent} %',
                                                    style: TextStyle(
                                                      color: _barChartColorData[
                                                          pointIndex],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                dataSource:
                                                    percentDataSnapshot.data!,
                                                xValueMapper: (datum, index) =>
                                                    percentDataSnapshot
                                                        .data![index].grade,
                                                yValueMapper: (datum, index) =>
                                                    percentDataSnapshot
                                                        .data![index].percent,
                                                pointColorMapper: (datum,
                                                        index) =>
                                                    _barChartColorData[index],
                                              ),
                                            ],
                                          );
                                        }

                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: appHeight * 0.11,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: appHeight * 0.025,
                                    left: appWidth * 0.05,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StreamBuilder(
                                        stream:
                                            _gradeCalculatorBloc.currentTerm,
                                        builder:
                                            (streamBuilderContext, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              widget.userBloc
                                                  .getTerm(snapshot.data!)
                                                  .term,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 26,
                                              ),
                                            );
                                          }

                                          return const SizedBox.shrink();
                                        },
                                      ),
                                      SizedBox(
                                        height: appHeight * 0.0075,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            '평점',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          StreamBuilder(
                                            stream: _gradeCalculatorBloc
                                                .currentTerm,
                                            builder: (currentTermIndexContext,
                                                currentTermIndexSnapshot) {
                                              if (currentTermIndexSnapshot
                                                  .hasData) {
                                                return StreamBuilder(
                                                  stream: widget.userBloc
                                                      .getTotalGradeAve(
                                                          currentTermIndexSnapshot
                                                              .data!),
                                                  builder: (totalGradeAveContext,
                                                      totalGradeAveSnapshot) {
                                                    if (totalGradeAveSnapshot
                                                        .hasData) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: 2,
                                                        ),
                                                        margin: EdgeInsets.only(
                                                          left:
                                                              appWidth * 0.005,
                                                          right:
                                                              appWidth * 0.02,
                                                        ),
                                                        child: Text(
                                                          '${totalGradeAveSnapshot.data!}',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .focusColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    return const SizedBox
                                                        .shrink();
                                                  },
                                                );
                                              }

                                              return const SizedBox.shrink();
                                            },
                                          ),
                                          const Text(
                                            '전공',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          StreamBuilder(
                                            stream: _gradeCalculatorBloc
                                                .currentTerm,
                                            builder: (currentTermIndexContext,
                                                currentTermIndexSnapshot) {
                                              if (currentTermIndexSnapshot
                                                  .hasData) {
                                                return StreamBuilder(
                                                  stream: widget.userBloc
                                                      .getMajorGradeAve(
                                                          currentTermIndexSnapshot
                                                              .data!),
                                                  builder: (majorGradeAveContext,
                                                      majorGradeAveSnapshot) {
                                                    if (majorGradeAveSnapshot
                                                        .hasData) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: 2,
                                                        ),
                                                        margin: EdgeInsets.only(
                                                          left:
                                                              appWidth * 0.005,
                                                          right:
                                                              appWidth * 0.02,
                                                        ),
                                                        child: Text(
                                                          '${majorGradeAveSnapshot.data!}',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .focusColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    return const SizedBox
                                                        .shrink();
                                                  },
                                                );
                                              }

                                              return const SizedBox.shrink();
                                            },
                                          ),
                                          const Text(
                                            '취득',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          StreamBuilder(
                                            stream: _gradeCalculatorBloc
                                                .currentTerm,
                                            builder: (currentTermIndexContext,
                                                currentTermIndexSnapshot) {
                                              if (currentTermIndexSnapshot
                                                  .hasData) {
                                                return StreamBuilder(
                                                  stream: widget.userBloc
                                                      .getCreditAmount(
                                                          currentTermIndexSnapshot
                                                              .data!),
                                                  builder: (creditAmountContext,
                                                      creditAmountSnapshot) {
                                                    if (creditAmountSnapshot
                                                        .hasData) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: 2,
                                                        ),
                                                        margin: EdgeInsets.only(
                                                          left:
                                                              appWidth * 0.005,
                                                        ),
                                                        child: Text(
                                                          '${creditAmountSnapshot.data!}',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .focusColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    return const SizedBox
                                                        .shrink();
                                                  },
                                                );
                                              }

                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //TODO: 시간표 불러오기 기능 만들기
                                Container(
                                  margin: EdgeInsets.only(
                                    right: appWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                            stream: _gradeCalculatorBloc.currentTerm,
                            builder: (_, currentTermIndexSnapshot) {
                              if (currentTermIndexSnapshot.hasData) {
                                return StreamBuilder(
                                  stream: widget.userBloc
                                      .getTerm(currentTermIndexSnapshot.data!)
                                      .subjects,
                                  builder: (_, subjectsSnapshot) {
                                    if (subjectsSnapshot.hasData) {
                                      return SizedBox(
                                        height: (subjectsSnapshot.data!.length +
                                                2) *
                                            appHeight *
                                            0.05313,
                                        child: CustomContainer(
                                          height:
                                              (subjectsSnapshot.data!.length +
                                                      2) *
                                                  appHeight *
                                                  0.05313,
                                          usePadding: false,
                                          child: _buildEditSubjects(
                                            context,
                                            currentTermIndexSnapshot.data!,
                                            subjectsSnapshot.data!.length,
                                          ),
                                        ),
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              StreamBuilder(
                stream: _gradeCalculatorBloc.isShowingSelectGrade,
                builder: (isShowingSelecteGradeContext,
                    isShowingSelectGradeSnapshot) {
                  if (isShowingSelectGradeSnapshot.hasData) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isShowingSelectGradeSnapshot.data!
                          ? CustomPickerModalBottomSheet.sheetHeight -
                              paddingBottom
                          : 0,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              StreamBuilder(
                stream: widget.userBloc.isShowingKeyboard,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
