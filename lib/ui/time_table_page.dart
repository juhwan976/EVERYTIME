import 'dart:developer';

import 'package:everytime/component/custom_appbar.dart';
import 'package:everytime/component/custom_appbar_animation.dart';
import 'package:everytime/component/custom_appbar_button.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_title.dart';
import 'package:everytime/component/custom_modal_bottom_sheet.dart';
import 'package:everytime/component/empty_content.dart';
import 'package:everytime/component/time_table_page/grade_template.dart';
import 'package:everytime/component/time_table_page/time_table.dart';
import 'package:everytime/global_variable.dart';
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
                //TODO: 창 빌드가 끝났을 때 키보드 보여주게 코드 작성.
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

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });

    WidgetsBinding.instance.addObserver(this);
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
                    log('pressed list buttton');
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
                              //TODO: 학점 수정 페이지 작성하기.
                              log("edit grade button pushed");
                            },
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                //TODO: 유저의 학점에 따라서 달라지도록 만들기.
                                const GradeTemplate(
                                  title: '평균 학점',
                                  current: '4.0',
                                  max: '4.5',
                                ),
                                SizedBox(
                                  width: appWidth * 0.065,
                                ),
                                const GradeTemplate(
                                  title: '취득 학점',
                                  current: '140',
                                  max: '140',
                                ),
                              ],
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
