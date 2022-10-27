import 'package:everytime/ui/time_table_page/add_time_table_page/appbar_at_add_time_table_page.dart';
import 'package:flutter/material.dart';

class AddTimeTablePage extends StatefulWidget {
  const AddTimeTablePage({
    Key? key,
  }) : super(key: key);

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
            AppBarAtAddTimeTablePage(
              pageContext: context,
            ),
          ],
        ),
      ),
    );
  }
}
