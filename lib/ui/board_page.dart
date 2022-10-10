import 'package:everytime/bloc/tabbar_bloc.dart';
import 'package:everytime/component/custom_tabbar.dart';
import 'package:everytime/component/custom_tabbar_view.dart';
import 'package:everytime/ui/board_page/board_board_page.dart';
import 'package:everytime/ui/board_page/board_future_page.dart';
import 'package:everytime/ui/board_page/board_party_page.dart';
import 'package:everytime/ui/board_page/board_pr_page.dart';
import 'package:flutter/material.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage>
    with AutomaticKeepAliveClientMixin {
  final _tabBarBloc = TabBarBloc();

  @override
  void dispose() {
    super.dispose();

    _tabBarBloc.dispose();
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
            CustomTabBar(
              tabBarBloc: _tabBarBloc,
              buttonTitleList: const ['게시판', '진로', '홍보', '그룹'],
            ),
            CustomTabBarView(
              tabBarBloc: _tabBarBloc,
              tabs: [
                BoardBoardPage(),
                BoardFuturePage(),
                BoardPRPage(),
                BoardPartyPage(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
