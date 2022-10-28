import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/bloc/time_table_page/time_table_list_bloc.dart';
import 'package:everytime/component/time_table_page/custom_text_field.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/ui/time_table_page/add_time_table_page/appbar_at_add_time_table_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTimeTablePage extends StatefulWidget {
  const AddTimeTablePage({
    Key? key,
    required this.userBloc,
    required this.timeTableListBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final TimeTableListBloc timeTableListBloc;

  @override
  State<AddTimeTablePage> createState() => _AddTimeTablePageState();
}

class _AddTimeTablePageState extends State<AddTimeTablePage> {
  final _timeTableNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.timeTableListBloc.createTermList(
      DateTime(2010, 3, 1),
      DateTime.now(),
    );
    widget.timeTableListBloc.updatePickerIndex(0);
  }

  @override
  void dispose() {
    super.dispose();

    _timeTableNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarAtAddTimeTablePage(
              pageContext: context,
              userBloc: widget.userBloc,
              timeTableListBloc: widget.timeTableListBloc,
              timeTableNameController: _timeTableNameController,
            ),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: appHeight * 0.01,
                      left: appWidth * 0.06,
                      right: appWidth * 0.06,
                    ),
                    child: CustomTextField(
                      controller: _timeTableNameController,
                      autofocus: true,
                      isDense: true,
                      textInputAction: TextInputAction.newline,
                      maxLines: 1,
                      hintText: '시간표 이름',
                      onSubmitted: (value) {},
                      onChanged: (value) {},
                    ),
                  ),
                  Container(
                    height: 1,
                    margin: EdgeInsets.only(
                      top: appHeight * 0.015,
                      left: appWidth * 0.06,
                      right: appWidth * 0.06,
                    ),
                    color: Theme.of(context).dividerColor,
                  ),
                  SizedBox(
                    height: appHeight * 0.28,
                    child: CupertinoPicker(
                      itemExtent: appHeight * 0.05,
                      children: _buildPickerList(),
                      onSelectedItemChanged: (index) {
                        widget.timeTableListBloc.updatePickerIndex(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPickerList() {
    List<String> terms = widget.timeTableListBloc.currentTermList;

    return List.generate(
      terms.length,
      (index) {
        return Container(
          height: appHeight * 0.05,
          alignment: Alignment.center,
          child: Text(
            terms[index],
            style: const TextStyle(
              fontSize: 27.5,
            ),
          ),
        );
      },
    );
  }
}
