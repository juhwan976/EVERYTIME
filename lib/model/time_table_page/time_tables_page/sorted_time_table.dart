import 'package:everytime/model/time_table_page/time_table.dart';

class SortedTimeTable {
  /// 학기 이름 ex) 2022년 2학기
  final String termString;

  /// 학기 이름에 해당되는 시간표들
  final List<TimeTable> timeTables = [];

  SortedTimeTable({
    required this.termString,
  });
}
