import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/empty_content.dart';
import 'package:everytime/component/time_table_page/time_table_chart.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/time_table_page/time_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeTableAtTimeTablePage extends StatelessWidget {
  const TimeTableAtTimeTablePage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userBloc.selectedTimeTable,
      builder: (_, selectedTimeTableSnapshot) {
        if (selectedTimeTableSnapshot.data == null) {
          return _buildTimeTableEmpty(context);
        } else {
          return _buildTimeTable(context);
        }
      },
    );
  }

  Widget _buildTimeTableEmpty(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.485,
      child: EmptyContent(
        icon: Icons.table_chart_outlined,
        title: '이번 학기 시간표를 만들어주세요',
        contentIsString: false,
        content: Container(
          height: appHeight * 0.045,
          width: appWidth * 0.325,
          margin: EdgeInsets.only(
            top: appHeight * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(appHeight * 0.02775),
            color: Theme.of(context).focusColor,
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _addNewTimeTable(),
            child: Text(
              '새 시간표 만들기',
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.5,
                letterSpacing: 0.25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addNewTimeTable() {
    TimeTable newTimeTable = TimeTable(
      termString: userBloc.currentTermString,
    );

    userBloc.addTimeTableList(newTimeTable);
    userBloc.updateSelectedTimeTable(newTimeTable);
  }

  Widget _buildTimeTable(BuildContext context) {
    return StreamBuilder(
      stream: userBloc.timeList,
      builder: (_, timeListSnapshot) {
        if (timeListSnapshot.hasData) {
          return CustomContainer(
            height:
                appHeight * (0.0579 * timeListSnapshot.data!.length + 0.025),
            usePadding: false,
            child: StreamBuilder(
              stream: userBloc.dayOfWeek,
              builder: (_, dayOfWeekSnapshot) {
                if (dayOfWeekSnapshot.hasData) {
                  return StreamBuilder(
                    stream: userBloc.currentSelectedTimeTable!.timeTableData,
                    builder: (_, timeTableDataSnapshot) {
                      if (timeTableDataSnapshot.hasData) {
                        return TimeTableChart(
                          userBloc: userBloc,
                          timeTableData: timeTableDataSnapshot.data!,
                          startHour: timeListSnapshot.data![0],
                          timeList: timeListSnapshot.data!,
                          dayOfWeekList: dayOfWeekSnapshot.data!,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
