import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/time_n_place_data.dart';
import 'package:rxdart/subjects.dart';

class AddDirectBloc {
  /// 미리보기를 그릴 때 사용할 [TimeNPlaceData]들을 저장할 변수
  final _timeNPlaceDataList = BehaviorSubject<List<TimeNPlaceData>>.seeded([]);

  Stream<List<TimeNPlaceData>> get timeNPlaceData => _timeNPlaceDataList.stream;
  Function(List<TimeNPlaceData>) get _updateTimeNPlaceData =>
      _timeNPlaceDataList.sink.add;
  List<TimeNPlaceData> get currentTimeNPlaceData => _timeNPlaceDataList.value;

  /// [_timeNPlaceDataList]를 빈 배열로 초기화 시키는함수
  void resetTimeNPlaceData() {
    _updateTimeNPlaceData([]);
  }

  /// [_timeNPlaceDataList]의 [index] 번째에 있는 data를 입력받은 값들로 갱신하는 함수
  ///
  /// inputs
  /// * [index] : 값을 갱신할 데이터가 있는 [index]
  ///
  /// inputs(option)
  /// * [place] : 장소
  /// * [startHour] : 시작 시간의 시간
  /// * [startMinute] : 시작 시간의 분
  /// * [endHour] : 종료 시간의 시간
  /// * [endMinute] : 종료 시간의 분
  /// * [dayOfWeek] : 요일
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

  /// [_timeNPlaceDataList]의 [index] 번째의 데이터를 삭제하는 함수
  ///
  /// inputs
  /// * [index] : [_timeNPlaceDataList]에서 삭제할 정보가 있는 [index]
  void removeTimeNPlaceData(int index) {
    List<TimeNPlaceData> temp = currentTimeNPlaceData;
    temp.removeAt(index);
    _updateTimeNPlaceData(temp);
  }

  /// [_timePlaceNDataList]에 새로운 정보를 추가하는 함수
  ///
  /// inputs
  /// * [place] : 장소
  /// * [startHour] : 시작 시간의 시간
  /// * [startMinute] : 시작 시간의 분
  /// * [endHour] : 종료 시간의 시간
  /// * [endMinute] : 죵료 시간의 분
  /// * [dayOfWeek] : 요일
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
