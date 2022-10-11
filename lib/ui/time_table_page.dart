import 'dart:developer';

import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_appbar.dart';
import 'package:everytime/component/custom_appbar_animation.dart';
import 'package:everytime/component/custom_appbar_button.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_title.dart';
import 'package:everytime/component/custom_modal_bottom_sheet.dart';
import 'package:everytime/component/empty_content.dart';
import 'package:everytime/component/time_table_page/show_grade_mini.dart';
import 'package:everytime/component/time_table_page/time_table.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/ui/time_table_page/grade_calculator_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final BehaviorSubject<double> _scrollOffset = BehaviorSubject.seeded(0);
  final _isDark = BehaviorSubject<bool>.seeded(
    WidgetsBinding.instance.window.platformBrightness == Brightness.dark
        ? true
        : false,
  );

  final FocusNode _addFrindFocusNode = FocusNode();

  //TODO: 글로벌화 시키기.
  final _user = EverytimeUserBloc();

  void _buildFriendTableDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return CustomModalBottomSheet(
          buttonList: [
            CustomModalBottomSheetButton(
              icon: Icons.add_box_outlined,
              title: '아이디로 친구 추가',
              onPressed: () {
                Navigator.pop(bottomSheetContext);
                showCupertinoDialog(
                  context: context,
                  builder: (dialogContext) {
                    return StatefulBuilder(
                      builder: (statefulContext, statefulSetState) {
                        return StreamBuilder(
                          stream: _isDark.stream,
                          builder: (streamBuilderContext, snapshot) {
                            if (snapshot.hasData) {
                              return Theme(
                                data: snapshot.data!
                                    ? ThemeData.dark()
                                    : ThemeData.light(),
                                child: CupertinoAlertDialog(
                                  title: const Text(
                                    '추가할 친구의 아이디 또는 이메일 주소를 입력해주세요.',
                                  ),
                                  content: Container(
                                    margin: EdgeInsets.only(
                                      top: appHeight * 0.025,
                                    ),
                                    child: CupertinoTextField(
                                      autofocus: true,
                                      focusNode: _addFrindFocusNode,
                                      keyboardAppearance: snapshot.data!
                                          ? Brightness.dark
                                          : Brightness.light,
                                      style: TextStyle(
                                        color: snapshot.data!
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: const Text('취소'),
                                      onPressed: () {
                                        _addFrindFocusNode.unfocus();
                                        Navigator.pop(dialogContext);
                                      },
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: const Text('확인'),
                                      onPressed: () {
                                        _addFrindFocusNode.unfocus();
                                        Navigator.pop(dialogContext);
                                      },
                                    ),
                                  ],
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
              },
            ),
            CustomModalBottomSheetButton(
              icon: Icons.chat_outlined,
              title: '카카오톡으로 친구 초대',
              onPressed: () async {
                Navigator.pop(bottomSheetContext);

                late BuildContext indicatorContext;

                showCupertinoDialog(
                  context: context,
                  builder: (dialogContext) {
                    return StatefulBuilder(
                      builder: (statefulContext, statefulSetState) {
                        indicatorContext = statefulContext;

                        return StreamBuilder(
                          stream: _isDark.stream,
                          builder: (streamBuilderContext, snapshot) {
                            if (snapshot.hasData) {
                              return Theme(
                                data: snapshot.data!
                                    ? ThemeData.dark()
                                    : ThemeData.light(),
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
              },
            ),
          ],
        );
      },
    );
  }

  void _buildGradeCalculatorPage(BuildContext context) {
    // 참고 페이지 : https://flutter-ko.dev/docs/cookbook/animation/page-route-animation
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) =>
            GradeCalculatorPage(
              userBloc: _user,
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

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });

    WidgetsBinding.instance.addObserver(this);

    //TODO: 글로벌화 할 때 지우기.
    _user.initTest();
  }

  @override
  void dispose() {
    super.dispose();

    widget.scrollController.removeListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });

    WidgetsBinding.instance.removeObserver(this);

    _scrollOffset.close();
    _isDark.close();

    _addFrindFocusNode.dispose();

    //TODO: 글로벌화 할 때 지우기.
    _user.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    if (WidgetsBinding.instance.window.platformBrightness == Brightness.dark) {
      _isDark.sink.add(true);
    } else {
      _isDark.sink.add(false);
    }

    if (_addFrindFocusNode.hasFocus) {
      _addFrindFocusNode.unfocus();
    }
  }

  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBarAnimation(
              scrollOffsetStream: _scrollOffset.stream,
              title: '2022년 2학기',
            ),
            CustomAppBar(
              title: "시간표",
              buttonList: [
                CustomAppBarButton(
                  icon: Icons.add_box_outlined,
                  onPressed: () {
                    //TODO: 시간표 추가하는 코드 작성.
                    log('pressed add buttton');
                  },
                ),
                CustomAppBarButton(
                  icon: Icons.settings_outlined,
                  onPressed: () {
                    //TODO: bottom modal popup 만들기.
                    log('pressed setting buttton');
                  },
                ),
                CustomAppBarButton(
                  icon: Icons.format_list_bulleted,
                  onPressed: () {
                    //TODO: 시간표 목록 불러오기.
                    log(Theme.of(context).brightness.toString());
                  },
                ),
              ],
            ),
            Expanded(
              child: CustomScrollView(
                controller: widget.scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: CustomContainer(
                      height: appHeight * 0.43,
                      usePadding: false,
                      //TODO: 데이터를 받아서 수정하는 코드 작성.
                      child: TimeTable(),
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
                              _buildFriendTableDialog(context);
                            },
                          ),
                          //TODO: 유저의 친구 수를 판별할 것.
                          const Expanded(
                            child: EmptyContent(
                              icon: Icons.people_outline,
                              title: '등록된 친구가 없습니다',
                              content:
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
                              _buildGradeCalculatorPage(context);
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
                                    stream: _user.totalGradeAve,
                                    builder: (totalGradeAveContext,
                                        totalGradeAveSnapshot) {
                                      if (totalGradeAveSnapshot.hasData) {
                                        return StreamBuilder(
                                            stream: _user.maxGrade,
                                            builder: (maxGradeContext,
                                                maxGradeSnapshot) {
                                              if (maxGradeSnapshot.hasData) {
                                                return ShowGradeMini(
                                                  title: '평균 학점',
                                                  current: totalGradeAveSnapshot
                                                      .data
                                                      .toString(),
                                                  max: maxGradeSnapshot.data
                                                      .toString(),
                                                );
                                              }

                                              return const SizedBox.shrink();
                                            });
                                      }

                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  SizedBox(
                                    width: appWidth * 0.065,
                                  ),
                                  StreamBuilder(
                                    stream: _user.currentCredit,
                                    builder: (currentCreditContext,
                                        currentCreditSnapshot) {
                                      if (currentCreditSnapshot.hasData) {
                                        return StreamBuilder(
                                            stream: _user.targetCredit,
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
                                            });
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
    );
  }
}
