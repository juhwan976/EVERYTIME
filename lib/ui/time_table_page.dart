import 'dart:developer';

import 'package:everytime/component/custom_appbar.dart';
import 'package:everytime/component/custom_appbar_animation.dart';
import 'package:everytime/component/custom_appbar_button.dart';
import 'package:everytime/global_variable.dart';
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
    with AutomaticKeepAliveClientMixin {
  final BehaviorSubject<double> _scrollOffset = BehaviorSubject.seeded(0);

  final List<Widget> _buttonList = [
    CustomAppBarButton(
      icon: Icons.add_box_outlined,
      onPressed: () {
        log('pressed add buttton');
      },
    ),
    CustomAppBarButton(
      icon: Icons.settings_outlined,
      onPressed: () {
        log('pressed setting buttton');
      },
    ),
    CustomAppBarButton(
      icon: Icons.format_list_bulleted,
      onPressed: () {
        log('pressed list buttton');
      },
    ),
  ];

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
  }

  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBarAnimation(
              scrollOffsetStream: _scrollOffset.stream,
              title: '2022년 2학기',
            ),
            CustomAppBar(
              title: "시간표",
              buttonList: _buttonList,
            ),
            Expanded(
              child: CustomScrollView(
                controller: widget.scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: List.generate(
                        200,
                        (index) => SizedBox(
                          height: 100,
                          width: appWidth,
                          child: Center(
                            child: Text(
                              '$index',
                            ),
                          ),
                        ),
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
