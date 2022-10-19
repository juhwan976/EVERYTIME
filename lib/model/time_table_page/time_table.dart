import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/time_table_data.dart';
import 'package:rxdart/subjects.dart';

class TimeTable {
  // 시간표 이름
  final _name = BehaviorSubject<String>.seeded('시간표');
  // 시간표의 년, 학기
  final String termString;
  // 시간표 데이터
  final _timeTableData = BehaviorSubject<List<TimeTableData>>.seeded([]);
  // 공개 범위
  final _privacyBounds =
      BehaviorSubject<PrivacyBounds>.seeded(PrivacyBounds.everyone);
  final _isDefault = BehaviorSubject<bool>.seeded(false);

  TimeTable({
    required this.termString,
  });

  Stream<String> get name => _name.stream;
  Function(String) get updateName => _name.sink.add;
  String get currentName => _name.value;
  Stream<List<TimeTableData>> get timeTableData => _timeTableData.stream;
  void _updateTimeTableData(List<TimeTableData> newData) =>
      _timeTableData.sink.add(newData);
  Stream<PrivacyBounds> get privacyBounds => _privacyBounds.stream;
  Function(PrivacyBounds) get updatePrivacyBounds => _privacyBounds.sink.add;
  Stream<bool> get isDefault => _isDefault.stream;
  Function(bool) get updateIsDefault => _isDefault.sink.add;

  List<TimeTableData> get currentTimeTableData => _timeTableData.value;
  PrivacyBounds get currentPrivacyBounds => _privacyBounds.value;

  void removeTimeTableData(int index) {
    List<TimeTableData> tempList = currentTimeTableData;
    currentTimeTableData.removeAt(index);

    _updateTimeTableData(tempList);
  }

  void addTimeTableData(TimeTableData data) {
    List<TimeTableData> tempList = currentTimeTableData;
    currentTimeTableData.add(data);

    _updateTimeTableData(tempList);
  }

  dispose() {
    _name.close();
    _timeTableData.close();
    _privacyBounds.close();
    _isDefault.close();
  }
}
