import 'package:everytime/model/enums.dart';

class TimeNPlaceData {
  WeekOfDay weekOfDay;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  String place;

  TimeNPlaceData({
    this.weekOfDay = WeekOfDay.mon,
    this.startHour = 9,
    this.startMinute = 0,
    this.endHour = 10,
    this.endMinute = 0,
    this.place = '',
  });
}
