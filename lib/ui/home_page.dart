import 'package:everytime/component/custom_appbar.dart';
import 'package:everytime/component/custom_appbar_animation.dart';
import 'package:everytime/component/custom_appbar_button.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final BehaviorSubject<double> _scrollOffset = BehaviorSubject.seeded(0);

  final List<Widget> _buttonList = [
    CustomAppBarButton(
      icon: Icons.search_rounded,
      onPressed: () {},
    ),
    CustomAppBarButton(
      icon: Icons.person,
      onPressed: () {},
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
  bool get wantKeepAlive => true;

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
              title: "에브리타임",
            ),
            CustomAppBar(title: "대학교이름", buttonList: _buttonList),
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
