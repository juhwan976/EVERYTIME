import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_button_modal_bottom_sheet.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/time_n_place_data.dart';
import 'package:everytime/model/time_table_page/time_table_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeTableChart extends StatelessWidget {
  const TimeTableChart({
    Key? key,
    required this.userBloc,
    this.isActivateButton = true,
    this.shadowDataList,
    required this.timeTableData,
    required this.startHour,
    required this.timeList,
    required this.dayOfWeekList,
    this.scrollController,
  }) : super(key: key);

  final List<int> timeList;
  final List<DayOfWeek> dayOfWeekList;
  final List<TimeTableData> timeTableData;
  final List<TimeNPlaceData>? shadowDataList;
  final EverytimeUserBloc userBloc;
  final bool isActivateButton;
  final ScrollController? scrollController;

  final int startHour;

  List<Widget> _buildShadows(BuildContext context) {
    List<Widget> result = [];

    for (TimeNPlaceData data in shadowDataList ?? []) {
      result.add(
        StreamBuilder(
          stream: userBloc.isDark,
          builder: (_, isDarkSnapshot) {
            if (isDarkSnapshot.hasData) {
              return Positioned(
                top: _getPositionTop(data),
                left: _getPositionLeft(data),
                child: Container(
                  height: _getContainerHeight(data),
                  width: _getContainerWidth(),
                  color: isDarkSnapshot.data!
                      ? Colors.white.withOpacity(0.2)
                      : Colors.black.withOpacity(0.2),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );
    }

    return result;
  }

  double _getContainerWidth() {
    return appWidth * 0.8995 / dayOfWeekList.length;
  }

  double _getContainerHeight(TimeNPlaceData data) {
    DateTime startTime = DateTime(1970, 1, 1, data.endHour, data.endMinute);
    DateTime endTime = DateTime(1970, 1, 1, data.startHour, data.startMinute);
    int diff = startTime.difference(endTime).inMinutes;

    return (appHeight * diff / 5 * 0.00483);
  }

  double _getPositionLeft(TimeNPlaceData data) {
    double pos = appWidth *
        (0.8995 / dayOfWeekList.length) *
        (DayOfWeek.getByDayOfWeek(data.dayOfWeek));
    return (appWidth * 0.055) + pos;
  }

  double _getPositionTop(TimeNPlaceData data) {
    DateTime startTime = DateTime(1970, 1, 1, data.startHour, data.startMinute);
    DateTime endTime = DateTime(1970, 1, 1, timeList[0], 0);
    int diff = startTime.difference(endTime).inMinutes;

    return ((appHeight * 0.022) + (appHeight * diff / 5 * 0.00483));
  }

  void _buildRemoveDialog(BuildContext context, int currentIndex) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title: '수업을 삭제하시겠습니까?',
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
              child: const Text('삭제'),
              onPressed: () {
                // TODO: 전체 시간표 목록 갱신해야함.

                for (int i = timeTableData[currentIndex].dates.length - 1;
                    i >= 0;
                    i--) {
                  DayOfWeek tempDayOfWeek =
                      timeTableData[currentIndex].dates[i].dayOfWeek;
                  int tempStartHour =
                      timeTableData[currentIndex].dates[i].startHour;
                  int tempEndHour =
                      timeTableData[currentIndex].dates[i].endHour;

                  timeTableData[currentIndex].dates.removeAt(i);
                  userBloc.removeDayOfWeek(
                    DayOfWeek.getByDayOfWeek(tempDayOfWeek),
                    timeTableData[currentIndex].dates,
                  );
                  userBloc.removeTimeList(
                    tempStartHour,
                    tempEndHour,
                    timeTableData[currentIndex].dates,
                  );
                }

                userBloc.currentSelectedTimeTable!
                    .removeTimeTableData(currentIndex);

                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    List<Widget> result = [];
    for (int i = 0; i < timeTableData.length; i++) {
      for (TimeNPlaceData data in timeTableData[i].dates) {
        result.add(
          Positioned(
            top: _getPositionTop(data),
            left: _getPositionLeft(data),
            child: Container(
              height: _getContainerHeight(data),
              width: _getContainerWidth(),
              color: Colors.green,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: isActivateButton
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          builder: (bottomSheetContext) {
                            return CustomButtonModalBottomSheet(
                              buttonList: [
                                CustomButtonModalBottomSheetButton(
                                  icon: Icons.chat_outlined,
                                  title: '강의평',
                                ),
                                CustomButtonModalBottomSheetButton(
                                  icon: Icons.note_add_outlined,
                                  title: '메모 추가',
                                ),
                                CustomButtonModalBottomSheetButton(
                                  icon: Icons.format_list_bulleted_outlined,
                                  title: '할일 보기',
                                ),
                                CustomButtonModalBottomSheetButton(
                                  icon: Icons.edit_outlined,
                                  title: '약칭 지정',
                                ),
                                CustomButtonModalBottomSheetButton(
                                  icon: Icons.delete_outline,
                                  title: '삭제',
                                  onPressed: () {
                                    Navigator.pop(bottomSheetContext);
                                    _buildRemoveDialog(context, i);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : null,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(2),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Text(
                        timeTableData[i].subjectName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data.place,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return result;
  }

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
            dayOfWeekList[currentRowIndex - 1].string,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        );
      } else {
        return const Center();
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: List.generate(
            dayOfWeekList.length + 1,
            (rowIndex) {
              return Container(
                width: (rowIndex == 0)
                    ? appWidth * 0.055
                    : appWidth * 0.8995 / dayOfWeekList.length,
                decoration: (rowIndex + 1 == dayOfWeekList.length + 1)
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
        ),
        ..._buildButtons(context),
        ..._buildShadows(context),
      ],
    );
  }
}
