import 'package:everytime/model/time_table_page/time_table.dart';
import 'package:everytime/model/time_table_page/time_tables_page/sorted_time_table.dart';
import 'package:rxdart/subjects.dart';

class TimeTableListBloc {
  final _sortedTimeTable = BehaviorSubject<List<SortedTimeTable>>.seeded([]);

  Stream<List<SortedTimeTable>> get sortedTimeTable => _sortedTimeTable.stream;
  Function(List<SortedTimeTable>) get updateSortedTimeTable =>
      _sortedTimeTable.sink.add;
  List<SortedTimeTable> get currentSortedTimeTable => _sortedTimeTable.value;

  void sortTimeTable(List<TimeTable> timeTableList) {
    List<SortedTimeTable> tempSortedTimeTable = currentSortedTimeTable;

    for (TimeTable timeTable in timeTableList) {
      bool result = false;
      int? index;

      for (int i = 0; i < tempSortedTimeTable.length; i++) {
        if (tempSortedTimeTable[i].termString == timeTable.termString) {
          result = true;
          index = i;
          break;
        }
      }

      if (result) {
        tempSortedTimeTable[index!].timeTables.add(timeTable);
      } else {
        SortedTimeTable newSortedTimeTable = SortedTimeTable(
          termString: timeTable.termString,
        );
        newSortedTimeTable.timeTables.add(timeTable);
        tempSortedTimeTable.add(newSortedTimeTable);
      }
    }

    //TODO: 학기에 순서대로 해야함

    updateSortedTimeTable(tempSortedTimeTable);
  }

  dispose() {
    _sortedTimeTable.close();
  }
}
