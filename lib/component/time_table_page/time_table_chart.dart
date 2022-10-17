import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class TimeTableChart extends StatelessWidget {
  TimeTableChart({
    Key? key,
  }) : super(key: key);

  final List<String> _weekList = ['월', '화', '수', '목', '금', '토'];
  final List<int> _timeList = [9, 10, 11, 12, 1, 2, 3];

  Widget _buildTimeTableElement(
      BuildContext context, int currentRowIndex, int currentColIndex) {
    if (currentRowIndex == 0) {
      if (currentColIndex == 0) {
        return const Center(
          child: SizedBox.shrink(),
        );
      } else {
        return Center(
          child: Container(
            alignment: Alignment.topRight,
            child: Text(
              _timeList[currentColIndex - 1].toString(),
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
        );
      }
    } else {
      if (currentColIndex == 0) {
        return Center(
          child: Text(
            _weekList[currentRowIndex - 1],
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        );
      } else {
        return Center(
            // child: Text('${currentRowIndex}, ${currentColIndex}'),
            );
      }
    }
  }

  Widget _buildTimeTableCol(BuildContext context, int currentRowIndex) {
    return Column(
      children: List.generate(
        _timeList.length + 1,
        (currentColIndex) {
          return Container(
            height: (currentColIndex == 0)
                ? appHeight * 0.022
                : appHeight * 0.0579125,
            decoration: (currentColIndex + 1 == _timeList.length + 1)
                ? null
                : BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
            child: _buildTimeTableElement(
              context,
              currentRowIndex,
              currentColIndex,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        _weekList.length + 1,
        (rowIndex) {
          return Container(
            width: (rowIndex == 0)
                ? appWidth * 0.055
                : appWidth * 0.8995 / _weekList.length,
            decoration: (rowIndex + 1 == _weekList.length + 1)
                ? null
                : BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
            child: _buildTimeTableCol(context, rowIndex),
          );
        },
      ),
    );
  }
}
