import 'package:everytime/model/time_table_page/subject_type.dart';

class TimeTableData {
  // 대학
  final String univ;
  // 교수
  final String prof;
  // // 장소
  // final String place;
  // // 시작 시간 (24시간 단위)
  // final int startHour;
  // final int startMinute;
  // // 종료 시간 (24시간 단위)
  // final int endHour;
  // final int endMinute;
  // 날짜
  // final TimeTableDate date;
  // 전공
  final String major;
  // 들을 수 있는 학년
  final List<int> year;
  // 학점
  final int credit;
  // 과목 이름
  final String subjectName;
  // 과목 종류
  final SubjectType type;

  // 과목 코드
  final String subjectCode;

  TimeTableData({
    this.univ = '에타대학',
    this.prof = '에타교수',
    // this.place = '에타교실',
    // required this.startHour,
    // required this.startMinute,
    // required this.endHour,
    // required this.endMinute,
    // required this.date,
    required this.major,
    required this.year,
    this.credit = 0,
    required this.subjectName,
    this.type = SubjectType.libralArtsSelect,
    this.subjectCode = '000000-000',
  });
}

enum TimeTableDate { undefined, mon, tue, wen, thu, fri }
