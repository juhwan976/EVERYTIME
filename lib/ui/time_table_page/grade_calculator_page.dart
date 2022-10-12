import 'dart:developer';

import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/time_table_page/show_grade_large.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:everytime/model/grade_of_terms.dart';

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

  final List<PointChartData> _totalData = [
    PointChartData(totalGrade: 4.5, majorGrade: null, term: '1학년 1학기'),
    PointChartData(totalGrade: 4.0, majorGrade: 4.2, term: '1학년 2학기'),
    PointChartData(totalGrade: 1.0, majorGrade: 2.0, term: '2학년 1학기'),
    PointChartData(totalGrade: 2.7, majorGrade: 2.5, term: '2학년 2학기'),
    PointChartData(totalGrade: 3.4, majorGrade: 3.4, term: '3학년 1학기'),
    PointChartData(totalGrade: 3.4, majorGrade: 2.5, term: '3학년 1학기'),
    PointChartData(totalGrade: 3.4, majorGrade: 3.2, term: '3학년 2학기'),
    PointChartData(totalGrade: 3.4, majorGrade: 3.5, term: '4학년 1학기'),
    PointChartData(totalGrade: 3.4, majorGrade: 3.9, term: '4학년 2학기'),
  ];
  //TODO: 전체들 중에서 상위 5개만 여기로 보내야한다. 퍼센트는 반욜림해서 보내자.
  final List<BarChartData> _gradeData = [
    BarChartData(grade: 'A+', percent: 53),
    BarChartData(grade: 'A0', percent: 20),
    BarChartData(grade: 'B+', percent: 17),
    BarChartData(grade: 'B0', percent: 5),
    BarChartData(grade: 'P', percent: 3),
  ];
  final List<Color> _colorData = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.lightBlue,
    Colors.indigo,
  ];

  Widget _buildEditGradeRow(BuildContext context, int currentTermIndex,
      int currentSubjectsLength, int currentIndex) {
    if (currentIndex == 0) {
      return Text('$currentIndex');
    } else if (currentIndex == (currentSubjectsLength + 2)) {
      return Text('$currentIndex');
    } else {
      return Text('$currentIndex');
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
                        itemCount: widget.userBloc.getTermsLength,
                        itemBuilder: (listViewContext, index) => SizedBox(
                          width: (widget.userBloc.getTerm(index).length == 7)
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
                                  widget.userBloc.getTerm(index),
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
                            //TODO: 실시간으로 수정내용 반영되도록 개선.
                            height: appHeight * 0.21,
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                interval: 1,
                                maximumLabelWidth: 30,
                                arrangeByIndex: true,
                                majorGridLines: const MajorGridLines(width: 0),
                                majorTickLines: const MajorTickLines(
                                  width: 0,
                                  size: 0,
                                ),
                                labelAlignment: LabelAlignment.center,
                                axisLine: const AxisLine(width: 0),
                                axisLabelFormatter: ((axisLabelRenderArgs) =>
                                    ChartAxisLabel(
                                      '${_totalData[axisLabelRenderArgs.value.round()].term.split(' ')[0]}\n${_totalData[axisLabelRenderArgs.value.round()].term.split(' ')[1]}',
                                      TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    )),
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
                                axisLabelFormatter: (axisLabelRenderArgs) =>
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
                                  dataSource: _totalData,
                                  xValueMapper: ((datum, index) =>
                                      _totalData[index].term),
                                  yValueMapper: ((datum, index) =>
                                      _totalData[index].majorGrade),
                                ),
                                StackedLineSeries(
                                  color: Theme.of(context).focusColor,
                                  markerSettings: const MarkerSettings(
                                    isVisible: true,
                                  ),
                                  groupName: '평균 학점',
                                  dataSource: _totalData,
                                  xValueMapper: ((datum, index) =>
                                      _totalData[index].term),
                                  yValueMapper: ((datum, index) =>
                                      _totalData[index].totalGrade),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            //TODO: 실시간으로 수정내용 반영되도록 개선.
                            child: SfCartesianChart(
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
                                    builder: (data, point, series, pointIndex,
                                            seriesIndex) =>
                                        Text(
                                      '${data.percent} %',
                                      style: TextStyle(
                                        color: _colorData[pointIndex],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  dataSource: _gradeData,
                                  xValueMapper: (datum, index) =>
                                      _gradeData[index].grade,
                                  yValueMapper: (datum, index) =>
                                      _gradeData[index].percent,
                                  pointColorMapper: (datum, index) =>
                                      _colorData[index],
                                ),
                              ],
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                stream: _currentTermIndex.stream,
                                builder: (streamBuilderContext, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      widget.userBloc.getTerm(snapshot.data!),
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ));
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
                          stream: widget.userBloc.getSubjectsLength(
                              currentTermIndexSnapshot.data!),
                          builder:
                              (subjectsLengthContext, subjectsLengthSnapshot) {
                            if (subjectsLengthSnapshot.hasData) {
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
                  // SizedBox(
                  //   height: appHeight * 0.65,
                  //   child: CustomContainer(
                  //     height: appHeight * 0.65,
                  //     usePadding: false,
                  //     child: StreamBuilder(
                  //       stream: _currentTermIndex.stream,
                  //       builder: (currentTermIndexContext,
                  //           currentTermIndexSnapshot) {
                  //         if (currentTermIndexSnapshot.hasData) {
                  //           return Column(
                  //             children: List.generate(
                  //               widget.userBloc.getSubjectsLength(
                  //                       currentTermIndexSnapshot.data!) +
                  //                   2,
                  //               (index) {},
                  //             ),
                  //           );
                  //         }

                  //         return SizedBox.shrink();
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PointChartData {
  final String term;
  final double? totalGrade;
  final double? majorGrade;

  PointChartData({
    required this.term,
    required this.majorGrade,
    required this.totalGrade,
  });
}

class BarChartData {
  final int? percent;
  final String grade;

  BarChartData({required this.percent, required this.grade});
}
