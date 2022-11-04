import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_appbar.dart';
import 'package:everytime/component/custom_appbar_animation.dart';
import 'package:everytime/component/custom_appbar_button.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/ui/home_page/my_info_page/my_info_page.dart';
import 'package:everytime/ui/home_page/search_page/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.scrollController,
    required this.userBloc,
  }) : super(key: key);

  final ScrollController scrollController;
  final EverytimeUserBloc userBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final BehaviorSubject<double> _scrollOffset = BehaviorSubject.seeded(0);

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
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBarAnimation(
              scrollOffsetStream: _scrollOffset.stream,
              title: "에브리타임",
            ),
            StreamBuilder(
              stream: widget.userBloc.univ,
              builder: (_, univSnapshot) {
                if (univSnapshot.hasData) {
                  return CustomAppBar(
                    title: univSnapshot.data!,
                    buttonList: [
                      CustomAppBarButton(
                        icon: Icons.search_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext pageContext) {
                              return SearchPage(
                                userBloc: widget.userBloc,
                              );
                            }),
                          );
                        },
                      ),
                      CustomAppBarButton(
                        icon: Icons.person_outline,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext pageContext) {
                                return MyInfoPage(
                                  userBloc: widget.userBloc,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
                return CustomAppBar(title: "로딩중..", buttonList: const []);
              },
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
                              style: TextStyle(
                                color: Theme.of(context).highlightColor,
                              ),
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
