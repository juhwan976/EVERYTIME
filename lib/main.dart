import 'package:flutter/material.dart';

import 'package:everytime/ui/alarm_page.dart';
import 'package:everytime/ui/board_page.dart';
import 'package:everytime/ui/campus_pick_page.dart';
import 'package:everytime/ui/home_page.dart';
import 'package:everytime/ui/time_table_page.dart';

import 'package:everytime/bloc/main_bloc.dart';
import 'package:everytime/global_variable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everytime Clone',
      theme: ThemeData(),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final _pageController = PageController(initialPage: 0);

  final List<Widget> _pageList = const [
    HomePage(),
    TimeTablePage(),
    BoardPage(),
    AlarmPage(),
    CampusPickPage(),
  ];

  final List<IconData> _bottomNavIcons = const [
    Icons.home_rounded,
    Icons.table_chart_rounded,
    Icons.dashboard_rounded,
    Icons.notifications_active_rounded,
    Icons.alternate_email_rounded,
  ];

  final inActiveIconColor = const Color.fromRGBO(208, 208, 208, 1);
  final activeIconColor = Colors.black;

  final _mainBloc = MainBloc();

  final _temp = Column(
    children: [
      Container(
        height: 1,
        width: appWidth,
        color: Colors.black12,
      ),
      Row(
        children: List.generate(
          _pageList.length,
          (index) {
            return SizedBox(
              height: appHeight * 0.11 - 1,
              width: appWidth / _pageList.length,
              child: MaterialButton(
                height: appHeight * 0.11 - 1,
                padding: EdgeInsets.only(
                  bottom: appHeight * 0.045,
                ),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Icon(
                  _bottomNavIcons.elementAt(index),
                  color: (snapshot.data as int == index)
                      ? activeIconColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  _mainBloc.onTapNavIcon(index);
                  _pageController.jumpToPage(index);
                },
              ),
            );
          },
        ),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pageList,
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _mainBloc.getPage,
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: appHeight * 0.11,
              width: appWidth,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    width: appWidth,
                    color: Colors.black12,
                  ),
                  Row(
                    children: List.generate(
                      _pageList.length,
                      (index) {
                        return SizedBox(
                          height: appHeight * 0.11 - 1,
                          width: appWidth / _pageList.length,
                          child: MaterialButton(
                            height: appHeight * 0.11 - 1,
                            padding: EdgeInsets.only(
                              bottom: appHeight * 0.045,
                            ),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Icon(
                              _bottomNavIcons.elementAt(index),
                              color: (snapshot.data as int == index)
                                  ? activeIconColor
                                  : inActiveIconColor,
                            ),
                            onPressed: () {
                              _mainBloc.onTapNavIcon(index);
                              _pageController.jumpToPage(index);
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
