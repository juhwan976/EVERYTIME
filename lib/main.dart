import 'dart:developer';

import 'package:everytime/bloc/everytime_user_bloc.dart';
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
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 0.8235294117647058,
        ),
        child: child!,
      ),
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
        cardColor: const Color.fromRGBO(
            245, 245, 245, 1), // usage: grade_calculator_page
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
        cardColor: const Color.fromRGBO(26, 26, 26, 1),
        focusColor: const Color.fromRGBO(203, 93, 72, 1),
        textTheme: TextTheme(),
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

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
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
  final _userBloc = EverytimeUserBloc();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _userBloc.updateIsDark(
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark);
    _userBloc.initGradeCalTest();
  }

  @override
  dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    _pageController.dispose();

    _homeScrollController.dispose();
    _timeTableScrollController.dispose();
    _campusPickScrollController.dispose();

    _mainBloc.dispose();
    _userBloc.dispose();
  }

  @override
  didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    if (WidgetsBinding.instance.window.platformBrightness == Brightness.dark) {
      if (primaryFocus?.hasFocus ?? false) {
        primaryFocus?.unfocus();
        _userBloc.updateIsShowingKeyboard(false);
      }
      _userBloc.updateIsDark(true);
    } else {
      if (primaryFocus?.hasFocus ?? false) {
        primaryFocus?.unfocus();
        _userBloc.updateIsShowingKeyboard(false);
      }
      _userBloc.updateIsDark(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageList = [
      HomePage(
        scrollController: _homeScrollController,
      ),
      TimeTablePage(
        scrollController: _timeTableScrollController,
        userBloc: _userBloc,
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
