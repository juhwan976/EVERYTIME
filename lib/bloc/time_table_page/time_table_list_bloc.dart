import 'package:everytime/model/time_table_page/time_table.dart';
import 'package:everytime/model/time_table_page/time_tables_page/sorted_time_table.dart';
import 'package:rxdart/subjects.dart';

class TimeTableListBloc {
  /// 정렬된 시간표들을 저장
  final _sortedTimeTable = BehaviorSubject<List<SortedTimeTable>>.seeded([]);

  Stream<List<SortedTimeTable>> get sortedTimeTable => _sortedTimeTable.stream;
  Function(List<SortedTimeTable>) get updateSortedTimeTable =>
      _sortedTimeTable.sink.add;
  List<SortedTimeTable> get currentSortedTimeTable => _sortedTimeTable.value;

  /// 입력받은 시간표들을 정렬해서 [_sortedTimeTable]에 추가하는 함수
  ///
  /// inputs
  /// * timeTableList : 정렬할 시간표들
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

        if (timeTableList.length == 1) {
          timeTable.updateIsDefault(true);
        }

        newSortedTimeTable.timeTables.add(timeTable);
        tempSortedTimeTable.add(newSortedTimeTable);
      }
    }

    //TODO: 학기 순서대로 정렬 해야함

    updateSortedTimeTable(tempSortedTimeTable);
  }

  /// 시간표 추가 페이지에서 학기들을 저장할 변수
  final _termList = BehaviorSubject<List<String>>.seeded([]);

  Stream<List<String>> get termList => _termList.stream;
  Function(List<String>) get _updateTermList => _termList.sink.add;
  List<String> get currentTermList => _termList.value;

  /// 학기들을 만드는 함수
  ///
  /// inputs
  /// * startDateTime : 시작 시간
  /// * endDateTime : 현재 시간
  void createTermList(DateTime startDate, DateTime endDate) {
    List<String> result = [];

    for (int i = 0; i <= endDate.year - startDate.year; i++) {
      result.add('${endDate.year - i}년 겨울학기');
      result.add('${endDate.year - i}년 2학기');
      result.add('${endDate.year - i}년 여름학기');
      result.add('${endDate.year - i}년 1학기');
    }

    _updateTermList(result);
  }

  final _pickerIndex = BehaviorSubject<int>.seeded(0);

  Stream<int> get pickerIndex => _pickerIndex.stream;
  Function(int) get updatePickerIndex => _pickerIndex.sink.add;
  int get currentPickerIndex => _pickerIndex.value;

  dispose() {
    _sortedTimeTable.close();

    _termList.close();

    _pickerIndex.close();
  }
}
