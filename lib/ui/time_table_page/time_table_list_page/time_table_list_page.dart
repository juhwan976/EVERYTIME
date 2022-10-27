import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/bloc/time_table_list_bloc.dart';
import 'package:everytime/ui/time_table_page/time_table_list_page/appbar_at_time_table_list_page.dart';
import 'package:everytime/ui/time_table_page/time_table_list_page/time_tables_at_time_table_list_page.dart';
import 'package:flutter/material.dart';

class TimeTableListPage extends StatefulWidget {
  const TimeTableListPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  State<TimeTableListPage> createState() => _TimeTableListPageState();
}

class _TimeTableListPageState extends State<TimeTableListPage> {
  final _pageScrollController = ScrollController();

  final _timeTableListBloc = TimeTableListBloc();

  @override
  void initState() {
    super.initState();

    _timeTableListBloc.sortTimeTable(widget.userBloc.currentTimeTableList);
  }

  @override
  void dispose() {
    super.dispose();

    _pageScrollController.dispose();

    _timeTableListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarAtTimeTableListPage(
              pageContext: context,
            ),
            TimeTablesAtTimeTableListPage(
              userBloc: widget.userBloc,
              timeTableListBloc: _timeTableListBloc,
              pageScrollController: _pageScrollController,
              pageContext: context,
            ),
          ],
        ),
      ),
    );
  }
}
