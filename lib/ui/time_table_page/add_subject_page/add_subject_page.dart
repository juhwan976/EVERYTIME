import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/time_table_page/time_table_chart.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/ui/time_table_page/add_direct_page/add_direct_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  void _routeAddDirectPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) =>
            AddDirectPage(userBloc: widget.userBloc)),
        transitionsBuilder: ((context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: appHeight * 0.055,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: appWidth * 0.15,
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Icon(
                        Icons.clear,
                        color: Theme.of(context).highlightColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: appHeight * 0.04,
                        width: appWidth * 0.15,
                        margin: EdgeInsets.only(
                          right: appWidth * 0.0225,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            '마법사',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: appHeight * 0.04,
                        width: appWidth * 0.185,
                        margin: EdgeInsets.only(
                          right: appWidth * 0.045,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            '직접 추가',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            _routeAddDirectPage(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: appHeight * 0.0025,
            ),
            CustomContainer(
              height: appHeight * 0.29,
              usePadding: false,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  StreamBuilder(
                    stream: widget.userBloc.timeList,
                    builder: (_, timeListSnapshot) {
                      if (timeListSnapshot.hasData) {
                        return StreamBuilder(
                          stream: widget.userBloc.dayOfWeek,
                          builder: (_, dayOfWeekSnapshot) {
                            if (dayOfWeekSnapshot.hasData) {
                              return StreamBuilder(
                                stream: widget.userBloc
                                    .currentSelectedTimeTable!.timeTableData,
                                builder: (_, timeTableDataSnapshot) {
                                  if (timeTableDataSnapshot.hasData) {
                                    return TimeTableChart(
                                      userBloc: widget.userBloc,
                                      timeTableData:
                                          timeTableDataSnapshot.data!,
                                      startHour: timeListSnapshot.data![0],
                                      timeList: timeListSnapshot.data!,
                                      dayOfWeekList: dayOfWeekSnapshot.data!,
                                      isActivateButton: false,
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
