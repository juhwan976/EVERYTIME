import 'package:everytime/bloc/add_direct_bloc.dart';
import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/custom_picker_modal_bottom_sheet.dart';
import 'package:everytime/component/time_table_page/custom_text_field.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/time_n_place_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataInputAtAddDirectPage extends StatelessWidget {
  const DataInputAtAddDirectPage({
    Key? key,
    required this.userBloc,
    required this.addDirectBloc,
    required this.subjectNameController,
    required this.profNameController,
    required this.timeTableScrollController,
    required this.lastDayOfWeekIndex,
    required this.lastStartHour,
    required this.lastEndHour,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final AddDirectBloc addDirectBloc;
  final TextEditingController subjectNameController;
  final TextEditingController profNameController;
  final ScrollController timeTableScrollController;

  final int lastDayOfWeekIndex;
  final int lastStartHour;
  final int lastEndHour;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: addDirectBloc.timeNPlaceData,
        builder: (_, timeNPlaceDataSnapshot) {
          if (timeNPlaceDataSnapshot.hasData) {
            return ListView(
              children: _buildListViewChildren(
                  context, timeNPlaceDataSnapshot.data!.length),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<Widget> _buildListViewChildren(
    BuildContext context,
    int currentLength,
  ) {
    return List.generate(
      currentLength + 2,
      (index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.only(
              left: appWidth * 0.05,
              right: appWidth * 0.05,
            ),
            child: Column(
              children: [
                CustomTextField(
                  controller: subjectNameController,
                  hintText: '수업명',
                  isHintBold: true,
                  onTap: () {
                    userBloc.updateIsShowingKeyboard(true);
                  },
                  onSubmitted: (value) {
                    userBloc.updateIsShowingKeyboard(false);
                  },
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(
                    bottom: appHeight * 0.0125,
                  ),
                  color: Theme.of(context).dividerColor,
                ),
                CustomTextField(
                  controller: profNameController,
                  hintText: '교수명',
                  onTap: () {
                    userBloc.updateIsShowingKeyboard(true);
                  },
                  onSubmitted: (value) {
                    userBloc.updateIsShowingKeyboard(false);
                  },
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(
                    bottom: appHeight * 0.0125,
                  ),
                  color: Theme.of(context).dividerColor,
                ),
              ],
            ),
          );
        } else if (index + 1 == currentLength + 2) {
          return Container(
            alignment: Alignment.centerLeft,
            width: appWidth,
            margin: EdgeInsets.only(
              left: appWidth * 0.05,
              right: appWidth * 0.05,
            ),
            child: MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Text(
                '시간 및 장소 추가',
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 21,
                ),
              ),
              onPressed: () {
                if (timeTableScrollController.hasClients) {
                  timeTableScrollController.animateTo(
                    _getScrollOffsetY(
                      TimeNPlaceData(),
                    ),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                }
                addDirectBloc.addTimeNPlaceData();
              },
            ),
          );
        } else {
          return Container(
            margin: EdgeInsets.only(
              left: appWidth * 0.05,
              right: appWidth * 0.05,
              bottom: appHeight * 0.0125,
            ),
            child: Column(
              children: [
                MaterialButton(
                  padding: EdgeInsets.zero,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: StreamBuilder(
                    stream: addDirectBloc.timeNPlaceData,
                    builder: (_, timeNPlaceDataSnapshot) {
                      if (timeNPlaceDataSnapshot.hasData) {
                        return Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: timeNPlaceDataSnapshot
                                        .data![index - 1].dayOfWeek.string,
                                  ),
                                  TextSpan(
                                    text: _buildTimeString(
                                      timeNPlaceDataSnapshot
                                          .data![index - 1].startHour,
                                      timeNPlaceDataSnapshot
                                          .data![index - 1].startMinute,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '-',
                                  ),
                                  TextSpan(
                                    text: _buildTimeString(
                                      timeNPlaceDataSnapshot
                                          .data![index - 1].endHour,
                                      timeNPlaceDataSnapshot
                                          .data![index - 1].endMinute,
                                    ),
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: Theme.of(context).focusColor,
                              size: 15,
                            ),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  onPressed: () {
                    _buildSelectTimeBottomSheet(context, index);
                  },
                ),
                Row(
                  children: [
                    Container(
                      height: appHeight * 0.05,
                      width: appWidth * 0.8,
                      padding: EdgeInsets.only(
                        right: appWidth * 0.02,
                      ),
                      child: TextField(
                        maxLines: 1,
                        scrollPadding: EdgeInsets.zero,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '장소',
                          hintStyle: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 21,
                        ),
                        cursorColor: Theme.of(context).focusColor,
                        onTap: () {
                          userBloc.updateIsShowingKeyboard(true);
                        },
                        onChanged: (value) {
                          addDirectBloc.updateTimeNPlaceData(
                            index - 1,
                            place: value,
                          );
                        },
                        onSubmitted: (value) {
                          userBloc.updateIsShowingKeyboard(false);
                        },
                      ),
                    ),
                    SizedBox(
                      width: appWidth * 0.1,
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: const Center(
                          child: Icon(
                            Icons.delete_outlined,
                          ),
                        ),
                        onPressed: () {
                          _buildRemoveDialog(context, index);
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(
                    bottom: appHeight * 0.0125,
                  ),
                  color: Theme.of(context).dividerColor,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  double _getScrollOffsetY(TimeNPlaceData data) {
    DateTime startTime = DateTime(1970, 1, 1, data.endHour, data.endMinute);
    DateTime endTime = DateTime(1970, 1, 1, userBloc.currentTimeList[0], 0);
    int diff = startTime.difference(endTime).inMinutes;

    double tempOffset = (appHeight * diff / 5 * 0.00483);

    return (tempOffset - appHeight * 0.28) + appHeight * 0.072;
  }

  String _buildTimeString(int hour, int minute) {
    String tempHour = '';
    String tempMinute = '';
    if (hour < 10) {
      tempHour = '0$hour';
    } else {
      tempHour = '$hour';
    }

    if (minute < 10) {
      tempMinute = '0$minute';
    } else {
      tempMinute = '$minute';
    }

    return ' $tempHour:$tempMinute ';
  }

  void _buildSelectTimeBottomSheet(BuildContext context, int currentIndex) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        int dayOfWeekIndex = DayOfWeek.getByDayOfWeek(
            addDirectBloc.currentTimeNPlaceData[currentIndex - 1].dayOfWeek);
        DateTime startTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          addDirectBloc.currentTimeNPlaceData[currentIndex - 1].startHour,
          addDirectBloc.currentTimeNPlaceData[currentIndex - 1].startMinute,
        );
        DateTime endTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          addDirectBloc.currentTimeNPlaceData[currentIndex - 1].endHour,
          addDirectBloc.currentTimeNPlaceData[currentIndex - 1].endMinute,
        );

        return CustomPickerModalBottomSheet(
          title: '시간 선택',
          onPressedCancel: () {
            Navigator.pop(bottomSheetContext);
          },
          onPressedSave: () {
            if (startTime.hour > endTime.hour ||
                (startTime.hour == endTime.hour &&
                    startTime.minute >= endTime.minute)) {
              showCupertinoDialog(
                context: context,
                builder: (dialogContext) {
                  return CustomCupertinoAlertDialog(
                    isDarkStream: userBloc.isDark,
                    title: '종료시간을 시작시간\n이후로 설정해주세요.',
                    actions: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('확인'),
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.pop(bottomSheetContext);

              userBloc.addDayOfWeek(dayOfWeekIndex);
              userBloc.addTimeList(startTime.hour, endTime.hour);

              addDirectBloc.updateTimeNPlaceData(
                currentIndex - 1,
                dayOfWeek: DayOfWeek.getByIndex(dayOfWeekIndex),
                startHour: startTime.hour,
                startMinute: startTime.minute,
                endHour: endTime.hour,
                endMinute: endTime.minute,
              );

              if (timeTableScrollController.hasClients) {
                timeTableScrollController.animateTo(
                  _getScrollOffsetY(
                    TimeNPlaceData(
                      startHour: startTime.hour,
                      startMinute: startTime.minute,
                      endHour: endTime.hour,
                      endMinute: endTime.minute,
                    ),
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear,
                );
              }
            }
          },
          picker: Container(
            padding: EdgeInsets.only(
              right: appWidth * 0.05,
              left: appWidth * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: appWidth * 0.2,
                  child: CupertinoPicker(
                    itemExtent: 32,
                    scrollController: FixedExtentScrollController(
                      initialItem: DayOfWeek.getByDayOfWeek(addDirectBloc
                          .currentTimeNPlaceData[currentIndex - 1].dayOfWeek),
                    ),
                    children: List.generate(
                      DayOfWeek.getDayOfWeeks().length,
                      (index) {
                        return Center(
                          child: Text(
                            DayOfWeek.getDayOfWeeks()[index].string,
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (value) {
                      dayOfWeekIndex = value;
                    },
                  ),
                ),
                SizedBox(
                  width: appWidth * 0.3,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      addDirectBloc
                          .currentTimeNPlaceData[currentIndex - 1].startHour,
                      addDirectBloc
                          .currentTimeNPlaceData[currentIndex - 1].startMinute,
                    ),
                    minuteInterval: 5,
                    use24hFormat: true,
                    onDateTimeChanged: (value) {
                      startTime = value;
                    },
                  ),
                ),
                SizedBox(
                  width: appWidth * 0.3,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      addDirectBloc
                          .currentTimeNPlaceData[currentIndex - 1].endHour,
                      addDirectBloc
                          .currentTimeNPlaceData[currentIndex - 1].endMinute,
                    ),
                    minuteInterval: 5,
                    use24hFormat: true,
                    onDateTimeChanged: (value) {
                      endTime = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _buildRemoveDialog(
    BuildContext context,
    int currentIndex,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title: '삭제하시겠습니까?',
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
              child: const Text('확인'),
              onPressed: () {
                Navigator.pop(dialogContext);

                int tempDayOfWeek = DayOfWeek.getByDayOfWeek(addDirectBloc
                    .currentTimeNPlaceData[currentIndex - 1].dayOfWeek);
                int tempStartHour = addDirectBloc
                    .currentTimeNPlaceData[currentIndex - 1].startHour;
                int tempEndHour = addDirectBloc
                    .currentTimeNPlaceData[currentIndex - 1].endHour;

                addDirectBloc.removeTimeNPlaceData(currentIndex - 1);
                userBloc.removeDayOfWeek(
                  tempDayOfWeek,
                  [
                    ...addDirectBloc.currentTimeNPlaceData,
                    TimeNPlaceData(
                      startHour: lastStartHour,
                      endHour: lastEndHour,
                      dayOfWeek: DayOfWeek.getByIndex(lastDayOfWeekIndex),
                    ),
                  ],
                );
                userBloc.removeTimeList(
                  tempStartHour,
                  tempEndHour,
                  [
                    ...addDirectBloc.currentTimeNPlaceData,
                    TimeNPlaceData(
                      startHour: lastStartHour,
                      endHour: lastEndHour,
                      dayOfWeek: DayOfWeek.getByIndex(lastDayOfWeekIndex),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
