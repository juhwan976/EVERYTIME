class TimeTableData {
  final String univ;
  final String prof;
  final String place;
  final TimeTableDate date;
  final String startTime;
  final String endTime;
  final String classCode;

  TimeTableData({
    required this.univ,
    required this.prof,
    required this.place,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.classCode = 'null',
  });
}

enum TimeTableDate { none, mon, tue, wen, thu, fri }
