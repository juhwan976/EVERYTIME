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
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        unselectedWidgetColor: const Color.fromRGBO(208, 208, 208, 1),
        dividerColor: Colors.black12,
        highlightColor: Colors.black, //usage: bottom navigation icon, font
        hintColor: Colors.black38,
        secondaryHeaderColor: Colors.black54, //usage: timetable
        focusColor: const Color.fromARGB(255, 212, 28, 0),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
        scaffoldBackgroundColor: const Color.fromRGBO(16, 16, 16, 1),
        unselectedWidgetColor: const Color.fromRGBO(62, 62, 62, 1),
        dividerColor: Colors.white10,
        highlightColor: Colors.white,
        hintColor: Colors.white54,
        secondaryHeaderColor: Colors.white54,
        focusColor: const Color.fromRGBO(203, 93, 72, 1),
      ),
      themeMode: ThemeMode.system,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageController = PageController(initialPage: 0);

  final _homeScrollController = ScrollController();
  final _timeTableScrollController = ScrollController();
  final _campusPickScrollController = ScrollController();

  final List<IconData> _bottomNavIcons = const [
    Icons.home_rounded,
    Icons.table_chart_rounded,
    Icons.dashboard_rounded,
    Icons.notifications_active_rounded,
    Icons.alternate_email_rounded,
  ];

  final _mainBloc = MainBloc();

  @override
  dispose() {
    super.dispose();

    _pageController.dispose();

    _homeScrollController.dispose();
    _timeTableScrollController.dispose();
    _campusPickScrollController.dispose();

    _mainBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageList = [
      HomePage(
        scrollController: _homeScrollController,
      ),
      TimeTablePage(
        scrollController: _timeTableScrollController,
      ),
      BoardPage(),
      AlarmPage(),
      CampusPickPage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pageList,
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _mainBloc.getPage,
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: appHeight * 0.11,
              width: appWidth,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    width: appWidth,
                    color: Theme.of(context).dividerColor,
                  ),
                  Row(
                    children: List.generate(
                      pageList.length,
                      (index) {
                        return SizedBox(
                          height: appHeight * 0.11 - 1,
                          width: appWidth / pageList.length,
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
                                  ? Theme.of(context).highlightColor
                                  : Theme.of(context).unselectedWidgetColor,
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
