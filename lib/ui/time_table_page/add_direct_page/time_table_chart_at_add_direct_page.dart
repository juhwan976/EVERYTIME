import 'package:everytime/bloc/time_table_page/add_direct_bloc.dart';
import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/time_table_page/time_table_chart.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class TimeTableChartAtAddDirectPage extends StatelessWidget {
  const TimeTableChartAtAddDirectPage({
    Key? key,
    required this.userBloc,
    required this.addDirectBloc,
    required this.timeTableScrollController,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final AddDirectBloc addDirectBloc;
  final ScrollController timeTableScrollController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userBloc.isShowingKeyboard,
      builder: (_, isShowingKeyboardSnapshot) {
        if (isShowingKeyboardSnapshot.hasData) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: !isShowingKeyboardSnapshot.data! ? appHeight * 0.3025 : 0,
            child: Visibility(
              visible: !isShowingKeyboardSnapshot.data!,
              child: CustomContainer(
                usePadding: false,
                child: _buildTimeTableChart(context),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTimeTableChart(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      controller: timeTableScrollController,
      physics: const ClampingScrollPhysics(),
      children: [
        StreamBuilder(
          stream: addDirectBloc.timeNPlaceData,
          builder: (_, timeNPlaceDataSnapshot) {
            if (timeNPlaceDataSnapshot.hasData) {
              return StreamBuilder(
                stream: userBloc.timeList,
                builder: (_, timeListSnapshot) {
                  if (timeListSnapshot.hasData) {
                    return StreamBuilder(
                      stream: userBloc.dayOfWeek,
                      builder: (_, dayOfWeekSnapshot) {
                        if (dayOfWeekSnapshot.hasData) {
                          return TimeTableChart(
                            userBloc: userBloc,
                            timeTableData: userBloc
                                .currentSelectedTimeTable!.currentTimeTableData,
                            timeList: timeListSnapshot.data!,
                            dayOfWeekList: dayOfWeekSnapshot.data!,
                            shadowDataList: timeNPlaceDataSnapshot.data,
                            startHour: timeListSnapshot.data![0],
                            isActivateButton: false,
                          );
                        }

                        return const SizedBox.shrink();
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
    );
  }
}
