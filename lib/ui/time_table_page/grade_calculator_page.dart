import 'dart:developer';

import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/time_table_page/show_grade_large.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/bar_chart_data.dart';
import 'package:everytime/model/grade_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  final _gradeFocusNode = FocusNode();

  //TODO: 표에서 사용중임. 나중에 Theme의 적당한 곳에 넣자.
  // final _color = const Color.fromRGBO(245, 245, 245, 1);
  final _color = const Color.fromRGBO(26, 26, 26, 1);

  final List<Color> _colorData = [
    const Color.fromRGBO(220, 130, 105, 1),
    const Color.fromRGBO(224, 194, 94, 1),
    const Color.fromRGBO(158, 191, 97, 1),
    const Color.fromRGBO(140, 200, 186, 1),
    const Color.fromRGBO(120, 143, 216, 1),
  ];

  Widget _buildEditGradeRow(BuildContext context, int currentTermIndex,
      int currentSubjectsLength, int currentIndex) {
    if (currentIndex == 0) {
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
    } else if (currentIndex + 1 == (currentSubjectsLength + 2)) {
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
                onPressed: () {},
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
                  //TODO: 이거 나온상태에서 시스템 색 바꿔도 작동하도록 하자.
                  showCupertinoDialog(
                    context: context,
                    builder: (dialogContext) {
                      return Theme(
                        data: ThemeData(),
                        child: CupertinoAlertDialog(
                          title: Text(
                              '${widget.userBloc.getTerm(currentTermIndex).term} 정보를\n초기화하시겠습니까?'),
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
                                for (int i = 0;
                                    i <
                                        widget.userBloc
                                            .getTerm(currentTermIndex)
                                            .currentSubjectLength;
                                    i++) {
                                  widget.userBloc
                                      .getTerm(currentTermIndex)
                                      .setDefault(i);
                                }
                                widget.userBloc.updateData();
                                setState(() {});
                                Navigator.pop(dialogContext);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
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
              color: _color,
            ),
            child: Center(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: appWidth * 0.04,
                  right: appWidth * 0.04,
                ),
                child: CupertinoTextField(
                  controller: TextEditingController(
                      text: widget.userBloc
                          .getTerm(currentTermIndex)
                          .getSubject(currentIndex - 1)
                          .currentTitle),
                  padding: EdgeInsets.zero,
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
                ),
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
              color: _color,
            ),
            child: Center(
              child: CupertinoTextField(
                // focusNode: _gradeFocusNode,
                controller: TextEditingController(
                    text: widget.userBloc
                        .getTerm(currentTermIndex)
                        .getSubject(currentIndex - 1)
                        .currentCredit
                        .toString()),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                padding: EdgeInsets.zero,
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
              ),
            ),
          ),
          //성적
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
              child: StreamBuilder(
                  stream: widget.userBloc
                      .getTerm(currentTermIndex)
                      .getSubject(currentIndex - 1)
                      .gradeType,
                  builder: (gradeTypeContext, gradeTypeSnapshot) {
                    if (gradeTypeSnapshot.hasData) {
                      return MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Text(
                          gradeTypeSnapshot.data!.data,
                        ),
                        onPressed: () async {
                          if (FocusScope.of(context).hasFocus) {
                            //log('has Focus');
                            FocusScope.of(context).unfocus();
                            // await keyboard animation
                            await Future.delayed(
                                const Duration(milliseconds: 350));
                          }
                          showModalBottomSheet(
                            isDismissible: false,
                            context: context,
                            builder: (popupContext) {
                              int selected =
                                  GradeType.getIndex(gradeTypeSnapshot.data!);
                              return Container(
                                color: Theme.of(context).backgroundColor,
                                height: appHeight * 0.4,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CupertinoButton(
                                          child: const Text(
                                            '취소',
                                            style: TextStyle(
                                              fontSize: 17.5,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(popupContext);
                                          },
                                        ),
                                        const Text(
                                          '성적을 선택해주세요',
                                          style: TextStyle(
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
                                            widget.userBloc
                                                .getTerm(currentTermIndex)
                                                .updateSubject(
                                                  currentIndex - 1,
                                                  gradeType:
                                                      GradeType.getByIndex(
                                                          selected),
                                                  isPNP: (GradeType.getByIndex(
                                                              selected) ==
                                                          GradeType.p)
                                                      ? true
                                                      : null,
                                                );
                                            widget.userBloc.updateData();
                                            Navigator.pop(popupContext);
                                          },
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 1,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    Expanded(
                                      child: CupertinoPicker(
                                        itemExtent: appHeight * 0.05,
                                        scrollController:
                                            FixedExtentScrollController(
                                                initialItem: GradeType.getIndex(
                                                    gradeTypeSnapshot.data!)),
                                        children: List.generate(
                                          11,
                                          (index) {
                                            return Center(
                                              child: Text(
                                                  GradeType.getGradeElementAt(
                                                      index)),
                                            );
                                          },
                                        ),
                                        onSelectedItemChanged: (index) {
                                          selected = index;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  }),
            ),
          ),
          //전공
          Expanded(
            child: Center(
              child: StreamBuilder(
                stream: widget.userBloc
                    .getTerm(currentTermIndex)
                    .getSubject(currentIndex - 1)
                    .isMajor,
                builder: (isMajorContext, isMajorSnapshot) {
                  if (isMajorSnapshot.hasData) {
                    return Checkbox(
                      value: isMajorSnapshot.data!,
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
                            .updateSubject(currentIndex - 1, isMajor: newValue);

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
  }

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
    // for (int i = 0; i < textEditingControllers.length; i++) {
    //   textEditingControllers[i].dispose();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: Colors.white,
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
                              }
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
                physics: const ClampingScrollPhysics(),
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
                            height: appHeight * 0.05,
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  margin:
                                      EdgeInsets.only(left: appWidth * 0.025),
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
                              builder: (aveDataContext, aveDataSnapshot) {
                                if (aveDataSnapshot.hasData) {
                                  return SfCartesianChart(
                                    primaryXAxis: CategoryAxis(
                                      maximumLabelWidth: 30,
                                      majorGridLines:
                                          const MajorGridLines(width: 0),
                                      majorTickLines: const MajorTickLines(
                                        width: 0,
                                        size: 0,
                                      ),
                                      labelAlignment: LabelAlignment.center,
                                      axisLine: const AxisLine(width: 0),
                                      axisLabelFormatter:
                                          (axisLabelRenderArgs) =>
                                              ChartAxisLabel(
                                        '${aveDataSnapshot.data![axisLabelRenderArgs.value.round()].term?.split(' ')[0]}\n${aveDataSnapshot.data![axisLabelRenderArgs.value.round()].term?.split(' ')[1]}',
                                        TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      interval: 1,
                                      minimum: 0,
                                      maximum: 4.6,
                                      majorGridLines: MajorGridLines(
                                        width: 1,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      majorTickLines: const MajorTickLines(
                                        width: 0,
                                        size: 0,
                                      ),
                                      labelStyle: const TextStyle(
                                        fontSize: 10,
                                      ),
                                      axisLine: const AxisLine(width: 0),
                                      axisLabelFormatter:
                                          (axisLabelRenderArgs) =>
                                              ChartAxisLabel(
                                        '${axisLabelRenderArgs.text}.0',
                                        TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                    plotAreaBorderWidth: 0,
                                    trackballBehavior: TrackballBehavior(
                                      enable: true,
                                      lineColor: Theme.of(context).hintColor,
                                      activationMode: ActivationMode.singleTap,
                                    ),
                                    series: [
                                      StackedLineSeries(
                                        color: Theme.of(context).hintColor,
                                        markerSettings: const MarkerSettings(
                                          isVisible: true,
                                        ),
                                        groupName: '전공 학점',
                                        dataSource: aveDataSnapshot.data!,
                                        xValueMapper: ((datum, index) =>
                                            aveDataSnapshot.data![index].term),
                                        yValueMapper: ((datum, index) =>
                                            aveDataSnapshot
                                                .data![index].majorGrade),
                                      ),
                                      StackedLineSeries(
                                        color: Theme.of(context).focusColor,
                                        markerSettings: const MarkerSettings(
                                          isVisible: true,
                                        ),
                                        groupName: '평균 학점',
                                        dataSource: aveDataSnapshot.data!,
                                        xValueMapper: ((datum, index) =>
                                            aveDataSnapshot.data![index].term),
                                        yValueMapper: ((datum, index) =>
                                            aveDataSnapshot
                                                .data![index].totalGrade),
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
                                builder:
                                    (percentDataContext, percentDataSnapshot) {
                                  if (percentDataSnapshot.hasData) {
                                    return SfCartesianChart(
                                      plotAreaBorderWidth: 0,
                                      primaryXAxis: CategoryAxis(
                                        isInversed: true,
                                        maximumLabels: 4,
                                        borderWidth: 0,
                                        majorTickLines: const MajorTickLines(
                                          width: 0,
                                          size: 3,
                                        ),
                                        majorGridLines: const MajorGridLines(
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
                                          dataLabelSettings: DataLabelSettings(
                                            isVisible: true,
                                            builder: (data, point, series,
                                                    pointIndex, seriesIndex) =>
                                                Text(
                                              '${data.percent} %',
                                              style: TextStyle(
                                                color: _colorData[pointIndex],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          dataSource: percentDataSnapshot.data!,
                                          xValueMapper: (datum, index) =>
                                              percentDataSnapshot
                                                  .data![index].grade,
                                          yValueMapper: (datum, index) =>
                                              percentDataSnapshot
                                                  .data![index].percent,
                                          pointColorMapper: (datum, index) =>
                                              _colorData[index],
                                        ),
                                      ],
                                    );
                                  }

                                  return const SizedBox.shrink();
                                }),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                stream: _currentTermIndex.stream,
                                builder: (streamBuilderContext, snapshot) {
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    '평점',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: _currentTermIndex.stream,
                                    builder: (currentTermIndexContext,
                                        currentTermIndexSnapshot) {
                                      if (currentTermIndexSnapshot.hasData) {
                                        return StreamBuilder(
                                          stream: widget.userBloc
                                              .getTotalGradeAve(
                                                  currentTermIndexSnapshot
                                                      .data!),
                                          builder: (totalGradeAveContext,
                                              totalGradeAveSnapshot) {
                                            if (totalGradeAveSnapshot.hasData) {
                                              return Container(
                                                padding: const EdgeInsets.only(
                                                  bottom: 2,
                                                ),
                                                margin: EdgeInsets.only(
                                                  left: appWidth * 0.005,
                                                  right: appWidth * 0.02,
                                                ),
                                                child: Text(
                                                  '${totalGradeAveSnapshot.data!}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .focusColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
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
                                  const Text(
                                    '전공',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: _currentTermIndex.stream,
                                    builder: (currentTermIndexContext,
                                        currentTermIndexSnapshot) {
                                      if (currentTermIndexSnapshot.hasData) {
                                        return StreamBuilder(
                                          stream: widget.userBloc
                                              .getMajorGradeAve(
                                                  currentTermIndexSnapshot
                                                      .data!),
                                          builder: (majorGradeAveContext,
                                              majorGradeAveSnapshot) {
                                            if (majorGradeAveSnapshot.hasData) {
                                              return Container(
                                                padding: const EdgeInsets.only(
                                                  bottom: 2,
                                                ),
                                                margin: EdgeInsets.only(
                                                  left: appWidth * 0.005,
                                                  right: appWidth * 0.02,
                                                ),
                                                child: Text(
                                                  '${majorGradeAveSnapshot.data!}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .focusColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
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
                                  const Text(
                                    '취득',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: _currentTermIndex.stream,
                                    builder: (currentTermIndexContext,
                                        currentTermIndexSnapshot) {
                                      if (currentTermIndexSnapshot.hasData) {
                                        return StreamBuilder(
                                          stream: widget.userBloc
                                              .getCreditAmount(
                                                  currentTermIndexSnapshot
                                                      .data!),
                                          builder: (creditAmountContext,
                                              creditAmountSnapshot) {
                                            if (creditAmountSnapshot.hasData) {
                                              return Container(
                                                padding: const EdgeInsets.only(
                                                  bottom: 2,
                                                ),
                                                margin: EdgeInsets.only(
                                                  left: appWidth * 0.005,
                                                ),
                                                child: Text(
                                                  '${creditAmountSnapshot.data!}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .focusColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
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
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            right: appWidth * 0.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: _currentTermIndex.stream,
                    builder:
                        (currentTermIndexContext, currentTermIndexSnapshot) {
                      if (currentTermIndexSnapshot.hasData) {
                        return StreamBuilder(
                          stream: widget.userBloc
                              .getTerm(currentTermIndexSnapshot.data!)
                              .subjectsLength,
                          builder:
                              (subjectsLengthContext, subjectsLengthSnapshot) {
                            if (subjectsLengthSnapshot.hasData) {
                              //TODO: 더 입력하기 만들 때 같이 손보자.
                              // if (_textEditingControllers.length <
                              //     subjectsLengthSnapshot.data!) {
                              //   for (int i = 0;
                              //       i <
                              //           (subjectsLengthSnapshot.data! -
                              //               _textEditingControllers.length);
                              //       i++) {
                              //     _textEditingControllers
                              //         .add(TextEditingController());
                              //   }
                              // } else if (_textEditingControllers.length >
                              //     subjectsLengthSnapshot.data!) {
                              //   for (int i = 0;
                              //       i <
                              //           (_textEditingControllers.length -
                              //               subjectsLengthSnapshot.data!);
                              //       i++) {
                              //     _textEditingControllers.last.dispose();
                              //     _textEditingControllers.removeLast();
                              //   }
                              // }
                              return SizedBox(
                                height: (subjectsLengthSnapshot.data! + 2) *
                                    appHeight *
                                    0.05313,
                                child: CustomContainer(
                                  height: (subjectsLengthSnapshot.data! + 2) *
                                      appHeight *
                                      0.05313,
                                  usePadding: false,
                                  child: Column(
                                    children: List.generate(
                                      subjectsLengthSnapshot.data! + 2,
                                      (index) {
                                        return Container(
                                          height: appHeight * 0.0520625,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: (index + 1 ==
                                                      subjectsLengthSnapshot
                                                              .data! +
                                                          2)
                                                  ? BorderSide.none
                                                  : BorderSide(
                                                      color: Theme.of(context)
                                                          .dividerColor,
                                                    ),
                                            ),
                                          ),
                                          child: _buildEditGradeRow(
                                            context,
                                            currentTermIndexSnapshot.data!,
                                            subjectsLengthSnapshot.data!,
                                            index,
                                          ),
                                        );
                                      },
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}
