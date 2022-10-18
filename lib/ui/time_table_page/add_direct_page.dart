import 'dart:developer';

import 'package:everytime/bloc/add_direct_bloc.dart';
import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/custom_picker_modal_bottom_sheet.dart';
import 'package:everytime/component/time_table_page/time_table_chart.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddDirectPage extends StatefulWidget {
  const AddDirectPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  State<AddDirectPage> createState() => _AddDirectPageState();
}

class _AddDirectPageState extends State<AddDirectPage> {
  final _subjectNameController = TextEditingController();
  final _profNameController = TextEditingController();

  final _addDirectBloc = AddDirectBloc();

  void _buildSelectTimeBottomSheet(BuildContext context, int currentIndex) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        int weekOfDayIndex = WeekOfDay.getByWeekOfDay(
            _addDirectBloc.currentTimeNPlaceData[currentIndex - 1].weekOfDay);
        DateTime startTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _addDirectBloc.currentTimeNPlaceData[currentIndex - 1].startHour,
          _addDirectBloc.currentTimeNPlaceData[currentIndex - 1].startMinute,
        );
        DateTime endTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _addDirectBloc.currentTimeNPlaceData[currentIndex - 1].endHour,
          _addDirectBloc.currentTimeNPlaceData[currentIndex - 1].endMinute,
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
                    isDarkStream: widget.userBloc.isDark,
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

              widget.userBloc.addWeekOfDay(weekOfDayIndex);
              widget.userBloc.addTimeList(startTime.hour, endTime.hour);

              _addDirectBloc.updateTimeNPlaceData(
                currentIndex - 1,
                weekOfDay: WeekOfDay.getByIndex(weekOfDayIndex),
                startHour: startTime.hour,
                startMinute: startTime.minute,
                endHour: endTime.hour,
                endMinute: endTime.minute,
              );
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
                      initialItem: WeekOfDay.getByWeekOfDay(_addDirectBloc
                          .currentTimeNPlaceData[currentIndex - 1].weekOfDay),
                    ),
                    children: List.generate(
                      WeekOfDay.getWeekOfDays().length,
                      (index) {
                        return Center(
                          child: Text(
                            WeekOfDay.getWeekOfDays()[index].string,
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (value) {
                      weekOfDayIndex = value;
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
                      _addDirectBloc
                          .currentTimeNPlaceData[currentIndex - 1].startHour,
                      _addDirectBloc
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
                      _addDirectBloc
                          .currentTimeNPlaceData[currentIndex - 1].endHour,
                      _addDirectBloc
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

  void _buildRemoveDialog(BuildContext context, int currentIndex) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
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

                WeekOfDay tempWeekOfDay = _addDirectBloc
                    .currentTimeNPlaceData[currentIndex - 1].weekOfDay;
                int tempStartHour = _addDirectBloc
                    .currentTimeNPlaceData[currentIndex - 1].startHour;
                int tempEndHour = _addDirectBloc
                    .currentTimeNPlaceData[currentIndex - 1].endHour;

                _addDirectBloc.removeTimeNPlaceData(currentIndex - 1);
                widget.userBloc.removeWeekOfDay(
                  WeekOfDay.getByWeekOfDay(tempWeekOfDay),
                  _addDirectBloc.currentTimeNPlaceData,
                );
                widget.userBloc.removeTimeList(
                  tempStartHour,
                  tempEndHour,
                  _addDirectBloc.currentTimeNPlaceData,
                );
              },
            ),
          ],
        );
      },
    );
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

  List<Widget> _buildListViewChildren(BuildContext context, int currentLength) {
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
                TextField(
                  controller: _subjectNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '수업명',
                    hintStyle: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 21,
                  ),
                  cursorColor: Theme.of(context).focusColor,
                  onTap: () {
                    widget.userBloc.updateIsShowingKeyboard(true);
                  },
                  onSubmitted: (value) {
                    widget.userBloc.updateIsShowingKeyboard(false);
                  },
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(
                    bottom: appHeight * 0.0125,
                  ),
                  color: Theme.of(context).dividerColor,
                ),
                TextField(
                  controller: _profNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '교수명',
                    hintStyle: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 21,
                  ),
                  cursorColor: Theme.of(context).focusColor,
                  onTap: () {
                    widget.userBloc.updateIsShowingKeyboard(true);
                  },
                  onSubmitted: (value) {
                    widget.userBloc.updateIsShowingKeyboard(false);
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
                _addDirectBloc.addTimeNPlaceData();
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
                    stream: _addDirectBloc.timeNPlaceData,
                    builder: (_, timeNPlaceDataSnapshot) {
                      if (timeNPlaceDataSnapshot.hasData) {
                        return Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: timeNPlaceDataSnapshot
                                        .data![index - 1].weekOfDay.string,
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
                          widget.userBloc.updateIsShowingKeyboard(true);
                        },
                        onSubmitted: (value) {
                          widget.userBloc.updateIsShowingKeyboard(false);
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

  @override
  dispose() {
    super.dispose();

    _subjectNameController.dispose();
    _profNameController.dispose();

    _addDirectBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (primaryFocus?.hasFocus ?? false) {
          widget.userBloc.updateIsShowingKeyboard(false);
          primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(
                height: appHeight * 0.055,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: appWidth * 0.15,
                      margin: EdgeInsets.only(
                        right: appWidth * 0.025,
                      ),
                      child: MaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Icon(
                          Icons.clear,
                          color: Theme.of(context).highlightColor,
                        ),
                        onPressed: () {
                          widget.userBloc.updateIsShowingKeyboard(false);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Text(
                      '수업 추가',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    Container(
                      height: appHeight * 0.04,
                      width: appWidth * 0.125,
                      margin: EdgeInsets.only(
                        right: appWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(appHeight * 0.04 / 2),
                        color: Theme.of(context).focusColor,
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          '완료',
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        onPressed: () {
                          if (primaryFocus?.hasFocus ?? false) {
                            primaryFocus?.unfocus();
                          }
                          widget.userBloc.updateIsShowingKeyboard(false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: widget.userBloc.isShowingKeyboard,
                builder: (_, isShowingKeyboardSnapshot) {
                  if (isShowingKeyboardSnapshot.hasData) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: !isShowingKeyboardSnapshot.data!
                          ? appHeight * 0.3025
                          : 0,
                      child: Visibility(
                        visible: !isShowingKeyboardSnapshot.data!,
                        child: CustomContainer(
                          usePadding: false,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const ClampingScrollPhysics(),
                            children: [
                              Stack(
                                children: [
                                  StreamBuilder(
                                    stream: _addDirectBloc.timeNPlaceData,
                                    builder: (_, timeNPlaceDataSnapshot) {
                                      if (timeNPlaceDataSnapshot.hasData) {
                                        return StreamBuilder(
                                          stream: widget.userBloc.timeList,
                                          builder: (_, timeListSnapshot) {
                                            if (timeListSnapshot.hasData) {
                                              return StreamBuilder(
                                                stream:
                                                    widget.userBloc.weekOfDay,
                                                builder:
                                                    (_, weekOfDaySnapshot) {
                                                  if (weekOfDaySnapshot
                                                      .hasData) {
                                                    return TimeTableChart(
                                                      timeList: timeListSnapshot
                                                          .data!,
                                                      weekOfDayList:
                                                          weekOfDaySnapshot
                                                              .data!,
                                                      shadowDataList:
                                                          timeNPlaceDataSnapshot
                                                              .data,
                                                    );
                                                  }

                                                  return const SizedBox
                                                      .shrink();
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
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _addDirectBloc.timeNPlaceData,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
