import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/bloc/time_table_list_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_title.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/time_table_page/time_tables_page/sorted_time_table.dart';
import 'package:flutter/material.dart';

class TimeTablesAtTimeTableListPage extends StatelessWidget {
  TimeTablesAtTimeTableListPage({
    Key? key,
    required this.userBloc,
    required this.timeTableListBloc,
    required this.pageScrollController,
    required this.pageContext,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final TimeTableListBloc timeTableListBloc;
  final ScrollController pageScrollController;
  final BuildContext pageContext;

  final double _buttonHeight = appHeight * 0.025;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: timeTableListBloc.sortedTimeTable,
        builder: (_, sortedTimeTableSnapshot) {
          if (sortedTimeTableSnapshot.hasData) {
            return ListView(
              controller: pageScrollController,
              children: List.generate(
                sortedTimeTableSnapshot.data!.length,
                (sortedTimeTableIndex) {
                  return CustomContainer(
                    child: Column(
                      children: [
                        CustomContainerTitle(
                          title: sortedTimeTableSnapshot
                              .data![sortedTimeTableIndex].termString,
                          type: CustomContainerTitleType.none,
                        ),
                        _buildContents(
                          sortedTimeTableSnapshot.data!,
                          sortedTimeTableIndex,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContents(
    List<SortedTimeTable> sortedTimeTable,
    int sortedTimeTableIndex,
  ) {
    return Container(
      height: sortedTimeTable[sortedTimeTableIndex].timeTables.length *
          _buttonHeight,
      margin: EdgeInsets.only(
        top: appHeight * 0.01,
        left: appWidth * 0.05,
        right: appWidth * 0.05,
      ),
      child: Column(
        children: List.generate(
          sortedTimeTable[sortedTimeTableIndex].timeTables.length,
          (timeTableIndex) {
            return SizedBox(
              height: _buttonHeight,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      sortedTimeTable[sortedTimeTableIndex]
                          .timeTables[timeTableIndex]
                          .currentName,
                      style: const TextStyle(
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      width: appWidth * 0.03,
                    ),
                    Visibility(
                      visible: sortedTimeTable[sortedTimeTableIndex]
                          .timeTables[timeTableIndex]
                          .currentIsDefault,
                      child: Text(
                        '기본',
                        style: TextStyle(
                            color: Theme.of(pageContext).focusColor,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  userBloc.updateSelectedTimeTable(
                    sortedTimeTable[sortedTimeTableIndex]
                        .timeTables[timeTableIndex],
                  );
                  Navigator.pop(pageContext);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
