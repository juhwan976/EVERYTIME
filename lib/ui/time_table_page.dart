import 'dart:developer';

import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_appbar.dart';
import 'package:everytime/component/custom_appbar_animation.dart';
import 'package:everytime/component/custom_appbar_button.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_title.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/custom_button_modal_bottom_sheet.dart';
import 'package:everytime/component/empty_content.dart';
import 'package:everytime/component/time_table_page/show_grade_mini.dart';
import 'package:everytime/component/time_table_page/time_table_chart.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/time_table.dart';
import 'package:everytime/ui/time_table_page/add_time_table_page.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({
    Key? key,
    required this.scrollController,
    required this.userBloc,
    required this.isOnScreen,
  }) : super(key: key);

  final ScrollController scrollController;
  final EverytimeUserBloc userBloc;
  final bool isOnScreen;

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage>
    with AutomaticKeepAliveClientMixin {
  final _scrollOffset = BehaviorSubject<double>.seeded(0);
  final _timeTableNameController = TextEditingController();

  void _buildRemoveTimeTableDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
          title: '시간표를 삭제하시겠습니까?',
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
                //TODO: 현재 학기 내의 다른 시간표가 있으면 그 시간표를 선택.
                widget.userBloc.removeTimeTableList(
                  widget.userBloc.currentSelectedTimeTable!.termString,
                  widget.userBloc.currentSelectedTimeTable!.currentName,
                );
                widget.userBloc.updateSelectedTimeTable(null);
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  void _buildEditPrivacyBounds(
    BuildContext context,
    PrivacyBounds privacyBounds,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (popupContext) {
        return CupertinoActionSheet(
          message: const Text(
            '공개 범위 변경',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: appWidth * 0.06,
                  ),
                  const Text(
                    '전체 공개',
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  SizedBox(
                    width: appWidth * 0.06,
                    child: Visibility(
                      visible: privacyBounds == PrivacyBounds.everyone,
                      child: Icon(
                        Icons.check,
                        color: CupertinoTheme.of(popupContext).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                widget.userBloc.updateTimeTableList(
                  widget.userBloc.currentSelectedTimeTable!.termString,
                  widget.userBloc.currentSelectedTimeTable!.currentName,
                  privacyBounds: PrivacyBounds.everyone,
                );

                Navigator.pop(popupContext);
              },
            ),
            CupertinoActionSheetAction(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: appWidth * 0.06,
                  ),
                  const Text(
                    '친구 공개',
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  SizedBox(
                    width: appWidth * 0.06,
                    child: Visibility(
                      visible: privacyBounds == PrivacyBounds.onlyFriend,
                      child: Icon(
                        Icons.check,
                        color: CupertinoTheme.of(popupContext).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                widget.userBloc.updateTimeTableList(
                  widget.userBloc.currentSelectedTimeTable!.termString,
                  widget.userBloc.currentSelectedTimeTable!.currentName,
                  privacyBounds: PrivacyBounds.onlyFriend,
                );

                Navigator.pop(popupContext);
              },
            ),
            CupertinoActionSheetAction(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: appWidth * 0.06,
                  ),
                  const Text(
                    '비공개',
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  SizedBox(
                    width: appWidth * 0.06,
                    child: Visibility(
                      visible: privacyBounds == PrivacyBounds.private,
                      child: Icon(
                        Icons.check,
                        color: CupertinoTheme.of(popupContext).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                widget.userBloc.updateTimeTableList(
                  widget.userBloc.currentSelectedTimeTable!.termString,
                  widget.userBloc.currentSelectedTimeTable!.currentName,
                  privacyBounds: PrivacyBounds.private,
                );

                Navigator.pop(popupContext);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              '취소',
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            onPressed: () {
              Navigator.pop(popupContext);
            },
          ),
        );
      },
    );
  }

  void _buildEditNameDialog(BuildContext context) {
    _timeTableNameController.text =
        widget.userBloc.currentSelectedTimeTable!.currentName;
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
          title: '변경할 이름을 입력해주세요',
          hasTextField: true,
          textEditingController: _timeTableNameController,
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
                if (_timeTableNameController.text.isEmpty) {
                  showCupertinoDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return CustomCupertinoAlertDialog(
                        isDarkStream: widget.userBloc.isDark,
                        title: '올바른 이름이 아닙니다.',
                        actions: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Text(
                              '닫기',
                            ),
                            onPressed: () {
                              Navigator.pop(alertDialogContext);
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  widget.userBloc.updateTimeTableList(
                    widget.userBloc.currentSelectedTimeTable!.termString,
                    widget.userBloc.currentSelectedTimeTable!.currentName,
                    newName: _timeTableNameController.text,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _buildEditSettingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return CustomButtonModalBottomSheet(
          buttonList: [
            CustomButtonModalBottomSheetButton(
              icon: Icons.edit_outlined,
              title: '이름 변경',
              onPressed: () {
                Navigator.pop(bottomSheetContext);
                _buildEditNameDialog(context);
              },
            ),
            CustomButtonModalBottomSheetButton(
              icon: Icons.lock_outlined,
              title: '공개 범위 변경',
              onPressed: () {
                Navigator.pop(bottomSheetContext);
                _buildEditPrivacyBounds(
                  context,
                  widget
                      .userBloc.currentSelectedTimeTable!.currentPrivacyBounds,
                );
              },
            ),
            CustomButtonModalBottomSheetButton(
              icon: Icons.auto_fix_high_outlined,
              title: '테마 및 스타일 변경',
              onPressed: () {},
            ),
            CustomButtonModalBottomSheetButton(
              icon: Icons.image_outlined,
              title: '이미지로 저장',
              onPressed: () {},
            ),
            CustomButtonModalBottomSheetButton(
              icon: Icons.share_outlined,
              title: 'URL로 공유',
              onPressed: () {},
            ),
            CustomButtonModalBottomSheetButton(
              icon: Icons.chat_outlined,
              title: '카카오톡으로 공유',
              onPressed: () {},
            ),
            CustomButtonModalBottomSheetButton(
              icon: Icons.delete_outline,
              title: '삭제',
              onPressed: () {
                Navigator.pop(bottomSheetContext);
                _buildRemoveTimeTableDialog(context);
              },
            ),
            //TODO: 기본 시간표로 지정 추가하기.
          ],
        );
      },
    );
  }

  void _routeAddTimeTablePage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) =>
            AddTimeTablePage(
              userBloc: widget.userBloc,
            )),
        transitionsBuilder: ((context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }),
      ),
    );
  }

  void _buildAddFriendUseId(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
          title: '추가할 친구의 아이디 또는 이메일 주소를 입력해주세요.',
          hasTextField: true,
          autoFocus: true,
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
              child: const Text('확인'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  void _buildAddFriendUseKakao(BuildContext context) async {
    late BuildContext indicatorContext;

    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulContext, _) {
            indicatorContext = statefulContext;

            return StreamBuilder(
              stream: widget.userBloc.isDark,
              builder: (streamBuilderContext, snapshot) {
                if (snapshot.hasData) {
                  return Theme(
                    data: snapshot.data! ? ThemeData.dark() : ThemeData.light(),
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(streamBuilderContext)
                              .dialogBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const CupertinoActivityIndicator(),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            );
          },
        );
      },
    );

    //TODO: 스키마를 이용해서 카카오톡 공유하기 열기.
    await Future.delayed(const Duration(seconds: 1)).whenComplete(
      () {
        Navigator.pop(indicatorContext);
      },
    );
  }

  void _buildAddFriendBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return CustomButtonModalBottomSheet(
          buttonList: [
            CustomButtonModalBottomSheetButton(
              icon: Icons.add_box_outlined,
              title: '아이디로 친구 추가',
              onPressed: () {
                Navigator.pop(bottomSheetContext);
                _buildAddFriendUseId(context);
              },
            ),
            CustomButtonModalBottomSheetButton(
              icon: Icons.chat_outlined,
              title: '카카오톡으로 친구 초대',
              onPressed: () {
                Navigator.pop(bottomSheetContext);
                _buildAddFriendUseKakao(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _routeGradeCalculatorPage(BuildContext context) {
    // 참고 페이지 : https://flutter-ko.dev/docs/cookbook/animation/page-route-animation
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            pageBuilder: ((context, animation, secondaryAnimation) =>
                GradeCalculatorPage(
                  userBloc: widget.userBloc,
                )),
            transitionsBuilder:
                ((context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            }),
          ),
        )
        .whenComplete(() => widget.userBloc.updateIsShowingKeyboard(false));
  }

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });
  }

  @override
  void dispose() {
    super.dispose();

    widget.scrollController.removeListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });

    _scrollOffset.close();
    _timeTableNameController.dispose();
  }

  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScrollsToTop(
      onScrollsToTop: (event) async {
        if (!widget.isOnScreen) return;
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            event.to,
            duration: event.duration,
            curve: event.curve,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              //TODO: 학사 일정에 따라서 바뀌도록 하면 좋을 것 같음.
              StreamBuilder(
                stream: widget.userBloc.termString,
                builder: (_, termStringSnapshot) {
                  return CustomAppBarAnimation(
                    scrollOffsetStream: _scrollOffset.stream,
                    title: termStringSnapshot.data ?? '',
                  );
                },
              ),
              StreamBuilder(
                  stream: widget.userBloc.selectedTimeTable,
                  builder: (_, selectedTimeTableSnapshot) {
                    return CustomAppBar(
                      title: selectedTimeTableSnapshot.data == null
                          ? '시간표'
                          : selectedTimeTableSnapshot.data!.currentName,
                      buttonList: [
                        Visibility(
                          visible: selectedTimeTableSnapshot.data == null
                              ? false
                              : true,
                          child: CustomAppBarButton(
                            icon: Icons.add_box_outlined,
                            onPressed: () {
                              _routeAddTimeTablePage(context);
                            },
                          ),
                        ),
                        Visibility(
                          visible: selectedTimeTableSnapshot.data == null
                              ? false
                              : true,
                          child: CustomAppBarButton(
                            icon: Icons.settings_outlined,
                            onPressed: () {
                              //TODO: bottom modal popup 만들기.
                              _buildEditSettingBottomSheet(context);
                            },
                          ),
                        ),
                        CustomAppBarButton(
                          icon: Icons.format_list_bulleted,
                          onPressed: () {
                            //TODO: 시간표 목록 불러오기.
                            log(Theme.of(context).brightness.toString());
                          },
                        ),
                      ],
                    );
                  }),
              Expanded(
                child: CustomScrollView(
                  controller: widget.scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: StreamBuilder(
                        stream: widget.userBloc.selectedTimeTable,
                        builder: (_, selectedTimeTableSnapshot) {
                          if (selectedTimeTableSnapshot.data == null) {
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
                                    borderRadius: BorderRadius.circular(
                                        appHeight * 0.02775),
                                    color: Theme.of(context).focusColor,
                                  ),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      '새 시간표 만들기',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.5,
                                        letterSpacing: 0.25,
                                      ),
                                    ),
                                    onPressed: () {
                                      TimeTable newTimeTable = TimeTable(
                                        termString:
                                            widget.userBloc.currentTermString,
                                      );

                                      widget.userBloc
                                          .addTimeTableList(newTimeTable);
                                      widget.userBloc.updateSelectedTimeTable(
                                          newTimeTable);
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return CustomContainer(
                              height: appHeight * 0.43,
                              usePadding: false,
                              //TODO: 데이터를 받아서 수정하는 코드 작성.
                              child: StreamBuilder(
                                stream: widget.userBloc.timeList,
                                builder: (_, timeListSnapshot) {
                                  if (timeListSnapshot.hasData) {
                                    return StreamBuilder(
                                      stream: widget.userBloc.weekOfDay,
                                      builder: (_, weekOfDaySnapshot) {
                                        if (weekOfDaySnapshot.hasData) {
                                          return TimeTableChart(
                                            timeList: timeListSnapshot.data!,
                                            weekOfDayList:
                                                weekOfDaySnapshot.data!,
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
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomContainer(
                        height: appHeight * 0.4,
                        child: Column(
                          children: [
                            CustomContainerTitle(
                              title: '친구 시간표',
                              type: CustomContainerTitleType.button,
                              buttonIcon: Icons.add_box_outlined,
                              onPressed: () {
                                _buildAddFriendBottomSheet(context);
                              },
                            ),
                            //TODO: 유저의 친구 수를 판별할 것.
                            const Expanded(
                              child: EmptyContent(
                                icon: Icons.people_outline,
                                title: '등록된 친구가 없습니다',
                                contentIsString: true,
                                contentString:
                                    '친구를 추가하면 시간표를 확인할 수 있어요!\n(커뮤니티 활동 내역은 공개되지 않아요.)',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomContainer(
                        height: appHeight * 0.15,
                        child: Column(
                          children: [
                            CustomContainerTitle(
                              title: '학점계산기',
                              type: CustomContainerTitleType.button,
                              buttonIcon: Icons.create_outlined,
                              onPressed: () {
                                _routeGradeCalculatorPage(context);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: appWidth * 0.05,
                                  left: appWidth * 0.05,
                                ),
                                child: Row(
                                  children: [
                                    StreamBuilder(
                                      stream: widget.userBloc.totalGradeAve,
                                      builder: (totalGradeAveContext,
                                          totalGradeAveSnapshot) {
                                        if (totalGradeAveSnapshot.hasData) {
                                          return StreamBuilder(
                                            stream: widget.userBloc.maxAve,
                                            builder: (maxAveContext,
                                                maxAveSnapshot) {
                                              if (maxAveSnapshot.hasData) {
                                                return ShowGradeMini(
                                                  title: '평균 학점',
                                                  current: totalGradeAveSnapshot
                                                      .data
                                                      .toString(),
                                                  max: maxAveSnapshot.data
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
                                    SizedBox(
                                      width: appWidth * 0.065,
                                    ),
                                    StreamBuilder(
                                      stream: widget.userBloc.currentCredit,
                                      builder: (currentCreditContext,
                                          currentCreditSnapshot) {
                                        if (currentCreditSnapshot.hasData) {
                                          return StreamBuilder(
                                            stream:
                                                widget.userBloc.targetCredit,
                                            builder: (targetCreditContext,
                                                targetCreditSnapshot) {
                                              if (targetCreditSnapshot
                                                  .hasData) {
                                                return ShowGradeMini(
                                                  title: '취득 학점',
                                                  current: currentCreditSnapshot
                                                      .data
                                                      .toString(),
                                                  max: targetCreditSnapshot.data
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
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}
