import 'dart:developer';

import 'package:everytime/global_variable.dart';
import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/time_n_place_data.dart';
import 'package:flutter/material.dart';

class TimeTableChart extends StatelessWidget {
  TimeTableChart({
    Key? key,
    this.shadowDataList,
    required this.timeList,
    required this.weekOfDayList,
  }) : super(key: key);

  final List<TimeNPlaceData>? shadowDataList;
  final List<int> timeList;
  final List<WeekOfDay> weekOfDayList;

  final int _timeTableStartHour = 9;
  List<List<int>> shadowBoard = [];

  Widget _buildTimeTableElement(
      BuildContext context, int currentRowIndex, int currentColIndex) {
    if (currentRowIndex == 0) {
      if (currentColIndex == 0) {
        return const Center(
          child: SizedBox.shrink(),
        );
      } else {
        return Center(
          child: Container(
            alignment: Alignment.topRight,
            child: Text(
              timeList[currentColIndex - 1].toString(),
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
        );
      }
    } else {
      if (currentColIndex == 0) {
        return Center(
          child: Text(
            weekOfDayList[currentRowIndex - 1].string,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        );
      } else {
        if (shadowDataList != null) {
          if (shadowBoard[currentRowIndex - 1][currentColIndex - 1] != 0) {
            return Center(
              child: Container(
                color: Color.fromRGBO(
                    0,
                    0,
                    0,
                    (shadowBoard[currentRowIndex - 1][currentColIndex - 1] > 5)
                        ? 1
                        : shadowBoard[currentRowIndex - 1]
                                [currentColIndex - 1] *
                            0.2),
              ),
            );
          } else {
            return Center();
          }
        } else {
          return Center(
              // child: Text('${currentRowIndex}, ${currentColIndex}'),
              );
        }
      }
    }
  }

  Widget _buildTimeTableCol(BuildContext context, int currentRowIndex) {
    return Column(
      children: List.generate(
        timeList.length + 1,
        (currentColIndex) {
          return Container(
            height: (currentColIndex == 0)
                ? appHeight * 0.022
                : appHeight * 0.0579125,
            decoration: (currentColIndex + 1 == timeList.length + 1)
                ? null
                : BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
            child: _buildTimeTableElement(
              context,
              currentRowIndex,
              currentColIndex,
            ),
          );
        },
      ),
    );
  }

  void _setShadowBoard(BuildContext context) {
    for (int row = 0; row < weekOfDayList.length; row++) {
      List<int> tempRow = [];
      for (int col = 0; col < timeList.length; col++) {
        tempRow.add(0);
      }
      shadowBoard.add(tempRow);
    }

    for (int i = 0; i < shadowDataList!.length; i++) {
      for (int time = 0;
          time < shadowDataList![i].endHour - shadowDataList![i].startHour;
          time++) {
        shadowBoard[WeekOfDay.getByWeekOfDay(shadowDataList![i].weekOfDay)]
            [shadowDataList![i].startHour + time - _timeTableStartHour] += 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shadowDataList != null) {
      _setShadowBoard(context);
    }

    return Row(
      children: List.generate(
        weekOfDayList.length + 1,
        (rowIndex) {
          return Container(
            width: (rowIndex == 0)
                ? appWidth * 0.055
                : appWidth * 0.8995 / weekOfDayList.length,
            decoration: (rowIndex + 1 == weekOfDayList.length + 1)
                ? null
                : BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
            child: _buildTimeTableCol(context, rowIndex),
          );
        },
      ),
    );
  }
}
