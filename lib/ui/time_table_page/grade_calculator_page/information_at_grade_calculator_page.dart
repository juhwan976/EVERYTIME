import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/time_table_page/show_grade_large.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/bar_chart_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InformationAtGradeCalculatorPage extends StatelessWidget {
  InformationAtGradeCalculatorPage({
    Key? key,
    required this.userBloc,
    required this.targetCreditController,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final TextEditingController targetCreditController;

  final List<Color> _barChartColorData = [
    const Color.fromRGBO(220, 130, 105, 1),
    const Color.fromRGBO(224, 194, 94, 1),
    const Color.fromRGBO(158, 191, 97, 1),
    const Color.fromRGBO(140, 200, 186, 1),
    const Color.fromRGBO(120, 143, 216, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
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
                  stream: userBloc.totalGradeAve,
                  builder: (totalGradeAveContext, totalGradeAveSnapshot) {
                    if (totalGradeAveSnapshot.hasData) {
                      return StreamBuilder(
                        stream: userBloc.maxAve,
                        builder: (maxAveContext, maxAveSnapshot) {
                          if (maxAveSnapshot.hasData) {
                            return ShowGradeLarge(
                              title: '전체 평점',
                              currentValue:
                                  totalGradeAveSnapshot.data.toString(),
                              totalValue: maxAveSnapshot.data.toString(),
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
                  stream: userBloc.majorGradeAve,
                  builder: (majorGradeAveContext, majorGradeAveSnapshot) {
                    if (majorGradeAveSnapshot.hasData) {
                      return StreamBuilder(
                        stream: userBloc.maxAve,
                        builder: (maxAveContext, maxAveSnapshot) {
                          if (maxAveSnapshot.hasData) {
                            return ShowGradeLarge(
                              title: '전공 평점',
                              currentValue:
                                  majorGradeAveSnapshot.data.toString(),
                              totalValue: maxAveSnapshot.data.toString(),
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
                  stream: userBloc.currentCredit,
                  builder: (currentCreditContext, currentCreditSnapshot) {
                    if (currentCreditSnapshot.hasData) {
                      return StreamBuilder(
                        stream: userBloc.targetCredit,
                        builder: (targetCreditContext, targetCreditSnapshot) {
                          if (targetCreditSnapshot.hasData) {
                            return ShowGradeLarge(
                              title: '취득 학점',
                              currentValue:
                                  currentCreditSnapshot.data.toString(),
                              totalValue: targetCreditSnapshot.data.toString(),
                              isShowButton: true,
                              icon: Icons.settings,
                              onPressed: () {
                                _buildEditTargetCreditDialog(
                                    context, targetCreditSnapshot.data!);
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
                    margin: EdgeInsets.only(left: appWidth * 0.025),
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
                stream: userBloc.aveData,
                builder: (aveDataContext, aveDataSnapshot) {
                  if (aveDataSnapshot.hasData) {
                    return SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        maximumLabelWidth: 30,
                        majorGridLines: const MajorGridLines(width: 0),
                        majorTickLines: const MajorTickLines(
                          width: 0,
                          size: 0,
                        ),
                        labelAlignment: LabelAlignment.center,
                        axisLine: const AxisLine(width: 0),
                        axisLabelFormatter: (axisLabelRenderArgs) =>
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
                          dataSource: aveDataSnapshot.data!,
                          xValueMapper: ((datum, index) =>
                              aveDataSnapshot.data![index].term),
                          yValueMapper: ((datum, index) =>
                              aveDataSnapshot.data![index].majorGrade),
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
                              aveDataSnapshot.data![index].totalGrade),
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
                stream: userBloc.percentData,
                builder: (percentDataContext, percentDataSnapshot) {
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
                            builder: (data, point, series, pointIndex,
                                    seriesIndex) =>
                                Text(
                              '${data.percent} %',
                              style: TextStyle(
                                color: _barChartColorData[pointIndex],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          dataSource: percentDataSnapshot.data!,
                          xValueMapper: (datum, index) =>
                              percentDataSnapshot.data![index].grade,
                          yValueMapper: (datum, index) =>
                              percentDataSnapshot.data![index].percent,
                          pointColorMapper: (datum, index) =>
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
    );
  }

  void _buildEditTargetCreditDialog(
      BuildContext context, int currentTargetCredit) {
    targetCreditController.text = currentTargetCredit.toString();
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title: '졸업 학점 설정',
          hasTextField: true,
          keyboardType: TextInputType.number,
          textEditingController: targetCreditController,
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
                userBloc
                    .updateTargetCredit(int.parse(targetCreditController.text));
                targetCreditController.clear();
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}
