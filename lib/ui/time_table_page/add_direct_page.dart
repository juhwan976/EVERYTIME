import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/time_table_page/time_table_chart.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddDirectPage extends StatefulWidget {
  const AddDirectPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  State<AddDirectPage> createState() => _AddDirectPageState();
}

class _AddDirectPageState extends State<AddDirectPage> {
  final _subjectNameController = TextEditingController();
  final _profNameController = TextEditingController();

  List<String> _temp = [];

  List<Widget> _buildListViewChildren(BuildContext context) {
    return List.generate(
      _temp.length + 2,
      (index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.only(
              left: appWidth * 0.05,
              right: appWidth * 0.05,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _subjectNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '수업명',
                    hintStyle: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 21,
                  ),
                  cursorColor: Theme.of(context).focusColor,
                  onTap: () {
                    widget.userBloc.updateIsShowingKeyboard(true);
                  },
                  onSubmitted: (value) {
                    widget.userBloc.updateIsShowingKeyboard(false);
                  },
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(
                    bottom: appHeight * 0.0125,
                  ),
                  color: Theme.of(context).dividerColor,
                ),
                TextField(
                  controller: _profNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '교수명',
                    hintStyle: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 21,
                  ),
                  cursorColor: Theme.of(context).focusColor,
                  onTap: () {
                    widget.userBloc.updateIsShowingKeyboard(true);
                  },
                  onSubmitted: (value) {
                    widget.userBloc.updateIsShowingKeyboard(false);
                  },
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(
                    bottom: appHeight * 0.0125,
                  ),
                  color: Theme.of(context).dividerColor,
                ),
              ],
            ),
          );
        } else if (index + 1 == _temp.length + 2) {
          return Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              left: appWidth * 0.05,
              right: appWidth * 0.05,
            ),
            child: MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Text(
                '시간 및 장소 추가',
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 21,
                ),
              ),
              onPressed: () {},
            ),
          );
        } else {
          return Container(
            margin: EdgeInsets.only(
              bottom: appHeight * 0.0125,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (primaryFocus?.hasFocus ?? false) {
          widget.userBloc.updateIsShowingKeyboard(false);
          primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(
                height: appHeight * 0.055,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: appWidth * 0.15,
                      margin: EdgeInsets.only(
                        right: appWidth * 0.025,
                      ),
                      child: MaterialButton(
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
                    const Text(
                      '수업 추가',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    Container(
                      height: appHeight * 0.04,
                      width: appWidth * 0.125,
                      margin: EdgeInsets.only(
                        right: appWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(appHeight * 0.04 / 2),
                        color: Theme.of(context).focusColor,
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          '완료',
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: widget.userBloc.isShowingKeyboard,
                builder: (_, isShowingKeyboardSnapshot) {
                  if (isShowingKeyboardSnapshot.hasData) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: !isShowingKeyboardSnapshot.data!
                          ? appHeight * 0.3025
                          : 0,
                      child: Visibility(
                        visible: !isShowingKeyboardSnapshot.data!,
                        child: CustomContainer(
                          usePadding: false,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const ClampingScrollPhysics(),
                            children: [
                              Stack(
                                children: [
                                  TimeTableChart(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: ListView(
                  children: _buildListViewChildren(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
