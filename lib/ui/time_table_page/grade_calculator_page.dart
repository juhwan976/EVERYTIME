import 'dart:developer';

import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/time_table_page/show_grade_large.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

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
  final _currentTermIndex = BehaviorSubject.seeded(0);
  final _termController = ScrollController();
  final _targetCreditController = TextEditingController();

  final List<String> _termList = [
    '1학년 1학기',
    '1학년 2학기',
    '2학년 1학기',
    '2학년 2학기',
    '3학년 1학기',
    '3학년 2학기',
    '4학년 1학기',
    '4학년 2학기',
    '5학년 1학기',
    '5학년 2학기',
    '6학년 1학기',
    '6학년 2학기',
    '기타 학기',
  ];

  void _buildEditTargetGrade(BuildContext context, int currentTargetCredit) {
    //TODO: 이거 나온 상태에서 시스템 색 바꿀 경우 적용되도록 하기.
    _targetCreditController.text = currentTargetCredit.toString();
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return Theme(
          data: ThemeData.light(),
          child: CupertinoAlertDialog(
            title: const Text('졸업 학점 설정'),
            content: Container(
              margin: EdgeInsets.only(
                top: appHeight * 0.025,
              ),
              child: CupertinoTextField(
                controller: _targetCreditController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ),
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
          ),
        );
      },
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();

    _currentTermIndex.close();
    _termController.dispose();
    _targetCreditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  stream: _currentTermIndex.stream,
                  builder: (streamContext, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        controller: _termController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(
                          left: appWidth * 0.04,
                          right: appWidth * 0.04,
                        ),
                        itemCount: _termList.length,
                        itemBuilder: (listViewContext, index) => SizedBox(
                          width: (_termList.elementAt(index).length == 7)
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
                                  _termList.elementAt(index),
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
                                          _termList.elementAt(index).length +
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
                              _currentTermIndex.sink.add(index);

                              //TODO: 나중에 글자 수가 다른 학기가 추가된다면 수정해야 할 수도 있다.
                              if (_termController.position.maxScrollExtent <
                                  appWidth * 0.205 * index) {
                                _termController.jumpTo(
                                    _termController.position.maxScrollExtent);
                              } else {
                                _termController
                                    .jumpTo(appWidth * 0.205 * index);
                              }
                            },
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  }),
            ),
            Expanded(
              child: ListView(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder(
                                stream: widget.userBloc.totalGradeAve,
                                builder: (totalGradeAveContext,
                                    totalGradeAveSnapshot) {
                                  if (totalGradeAveSnapshot.hasData) {
                                    return StreamBuilder(
                                      stream: widget.userBloc.maxGrade,
                                      builder:
                                          (maxGradeContext, maxGradeSnapshot) {
                                        if (maxGradeSnapshot.hasData) {
                                          return ShowGradeLarge(
                                            title: '전체 평점',
                                            currentValue: totalGradeAveSnapshot
                                                .data
                                                .toString(),
                                            totalValue: maxGradeSnapshot.data
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
                                      stream: widget.userBloc.maxGrade,
                                      builder:
                                          (maxGradeContext, maxGradeSnapshot) {
                                        if (maxGradeSnapshot.hasData) {
                                          return ShowGradeLarge(
                                            title: '전체 평점',
                                            currentValue: majorGradeAveSnapshot
                                                .data
                                                .toString(),
                                            totalValue: maxGradeSnapshot.data
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
                                      stream: widget.userBloc.targetCredit,
                                      builder: (targetCreditContext,
                                          targetCreditSnapshot) {
                                        if (targetCreditSnapshot.hasData) {
                                          return ShowGradeLarge(
                                            title: '취득 학점',
                                            currentValue: currentCreditSnapshot
                                                .data
                                                .toString(),
                                            totalValue: targetCreditSnapshot
                                                .data
                                                .toString(),
                                            isShowButton: true,
                                            icon: Icons.settings,
                                            onPressed: () {
                                              _buildEditTargetGrade(context,
                                                  targetCreditSnapshot.data!);
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
                            height: appHeight * 0.26,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
