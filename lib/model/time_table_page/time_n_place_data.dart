import 'package:everytime/model/enums.dart';

class TimeNPlaceData {
  DayOfWeek dayOfWeek;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
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
