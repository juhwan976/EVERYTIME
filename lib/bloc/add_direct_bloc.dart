import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/time_n_place_data.dart';
import 'package:rxdart/subjects.dart';

class AddDirectBloc {
  final _timeNPlaceDataList = BehaviorSubject<List<TimeNPlaceData>>.seeded([]);

  Stream<List<TimeNPlaceData>> get timeNPlaceData => _timeNPlaceDataList.stream;
  Function(List<TimeNPlaceData>) get _updateTimeNPlaceData =>
      _timeNPlaceDataList.sink.add;
  List<TimeNPlaceData> get currentTimeNPlaceData => _timeNPlaceDataList.value;

  void resetTimeNPlaceData() {
    _updateTimeNPlaceData([]);
  }

  void updateTimeNPlaceData(
    int index, {
    String? place,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    DayOfWeek? dayOfWeek,
  }) {
    if (place != null ||
        startHour != null ||
        startMinute != null ||
        endHour != null ||
        endMinute != null ||
        dayOfWeek != null) {
      List<TimeNPlaceData> temp = _timeNPlaceDataList.value;
      if (place != null) temp[index].place = place;
      if (startHour != null) temp[index].startHour = startHour;
      if (startMinute != null) temp[index].startMinute = startMinute;
      if (endHour != null) temp[index].endHour = endHour;
      if (endMinute != null) temp[index].endMinute = endMinute;
      if (dayOfWeek != null) temp[index].dayOfWeek = dayOfWeek;

      _updateTimeNPlaceData(temp);
    }
  }

  void removeTimeNPlaceData(int index) {
    List<TimeNPlaceData> temp = currentTimeNPlaceData;
    temp.removeAt(index);
    _updateTimeNPlaceData(temp);
  }

  void addTimeNPlaceData({
    String? place,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    DayOfWeek? dayOfWeek,
  }) {
    _updateTimeNPlaceData([
      ...currentTimeNPlaceData,
      TimeNPlaceData(),
    ]);
  }

  void dispose() {
    _timeNPlaceDataList.close();
  }
}
