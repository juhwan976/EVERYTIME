import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/time_table_page/time_table_chart.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTimeTablePage extends StatefulWidget {
  const AddTimeTablePage({
    Key? key,
    required this.userBloc,
    required this.isOnScreen,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final bool isOnScreen;

  @override
  State<AddTimeTablePage> createState() => _AddTimeTablePageState();
}

class _AddTimeTablePageState extends State<AddTimeTablePage> {
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
                          onPressed: () {},
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
                  TimeTableChart(),
                ],
              ),
            ),
            // SizedBox(
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
