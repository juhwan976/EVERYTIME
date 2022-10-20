import 'package:everytime/model/enums.dart';

class TimeNPlaceData {
  /// 요일
  DayOfWeek dayOfWeek;

  /// 시작 시간의 시간
  int startHour;

  /// 시작 시간의 분
  int startMinute;

  /// 종료 시간의 시간
  int endHour;

  /// 종료 시간의 분
  int endMinute;

  /// 장소
  String place;

  TimeNPlaceData({
    this.dayOfWeek = DayOfWeek.mon,
    this.startHour = 9,
    this.startMinute = 0,
    this.endHour = 10,
    this.endMinute = 0,
    this.place = '',
  });
}
