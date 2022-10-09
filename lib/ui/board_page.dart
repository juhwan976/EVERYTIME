import 'package:everytime/component/custom_tabbar_button.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/ui/board_page/board_board_page.dart';
import 'package:everytime/ui/board_page/board_future_page.dart';
import 'package:everytime/ui/board_page/board_party_page.dart';
import 'package:everytime/ui/board_page/board_pr_page.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage>
    with AutomaticKeepAliveClientMixin {
  final BehaviorSubject<int> _currentIndex = BehaviorSubject.seeded(0);

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
            Container(
              height: appHeight * 0.09,
              width: appWidth,
              padding: EdgeInsets.only(
                left: appWidth * 0.025,
                right: appWidth * 0.025,
              ),
              child: StreamBuilder(
                stream: _currentIndex.stream,
                builder: (context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        SizedBox(
                          width: appWidth * 0.025,
                        ),
                        CustomTabBarButton(
                          title: '게시판',
                          index: 0,
                          currentIndex: snapshot.data as int,
                          onPressed: () {
                            _currentIndex.sink.add(0);
                          },
                        ),
                        CustomTabBarButton(
                          title: '진로',
                          index: 1,
                          currentIndex: snapshot.data as int,
                          onPressed: () {
                            _currentIndex.sink.add(1);
                          },
                        ),
                        CustomTabBarButton(
                          title: '홍보',
                          index: 2,
                          currentIndex: snapshot.data as int,
                          onPressed: () {
                            _currentIndex.sink.add(2);
                          },
                        ),
                        CustomTabBarButton(
                          title: '단체',
                          index: 3,
                          currentIndex: snapshot.data as int,
                          onPressed: () {
                            _currentIndex.sink.add(3);
                          },
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _currentIndex.stream,
                builder: (context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return IndexedStack(
                      index: snapshot.data,
                      children: [
                        BoardBoardPage(),
                        BoardFuturePage(),
                        BoardPRPage(),
                        BoardPartyPage(),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
