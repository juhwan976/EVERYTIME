import 'package:flutter/material.dart';

class TimeTable extends StatelessWidget {
  TimeTable({
    Key? key,
  }) : super(key: key);

  final List<String> _weekList = ['월', '화', '수', '목', '금'];
  final List<int> _timeList = [9, 10, 11, 12, 1, 2, 3];

  Widget _calChild(BuildContext context, int rowIndex, int colIndex) {
    if (colIndex == 0) {
      if (rowIndex == 0) {
        return Container(
          alignment: Alignment.topRight,
          child: const Text(' '),
        );
      } else {
        return Center(
          child: Text(
            _weekList.elementAt(rowIndex - 1),
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        );
      }
    } else {
      if (rowIndex == 0) {
        return Container(
          alignment: Alignment.topRight,
          child: Text(
            '${_timeList.elementAt(colIndex - 1)}',
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        );
      } else {
        return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        6,
        (rowIndex) {
          return Flexible(
            fit: FlexFit.tight,
            flex: (rowIndex == 0) ? 1 : 3,
            child: Container(
              decoration: (rowIndex == 5)
                  ? null
                  : BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
              child: Column(
                children: List.generate(
                  8,
                  (colIndex) {
                    return Flexible(
                      fit: FlexFit.tight,
                      flex: (colIndex == 0) ? 1 : 2,
                      child: Container(
                        decoration: (colIndex == 7)
                            ? null
                            : BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ),
                        child: _calChild(context, rowIndex, colIndex),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
