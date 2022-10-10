import 'package:everytime/bloc/tabbar_bloc.dart';
import 'package:everytime/component/custom_tabbar.dart';
import 'package:everytime/component/custom_tabbar_view.dart';
import 'package:everytime/ui/alarm_page/alarm_alarm_page.dart';
import 'package:everytime/ui/alarm_page/alarm_note_page.dart';
import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage>
    with AutomaticKeepAliveClientMixin {
  final _tabBarBloc = TabBarBloc();

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
              buttonTitleList: const ['알림', '쪽지함'],
            ),
            CustomTabBarView(
              tabBarBloc: _tabBarBloc,
              tabs: [
                AlarmAlarmPage(),
                AlarmNotePage(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
