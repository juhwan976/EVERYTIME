import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/time_n_place_data.dart';

class TimeTableData {
  /// 대학
  final String univ;

  /// 교수
  final String prof;

  /// 요일, 장소, 시간 리스트
  final List<TimeNPlaceData> dates;

  /// 전공
  final String? major;

  /// 들을 수 있는 학년
  final List<int>? year;

  /// 과목 이름
  final String subjectName;

  /// 과목 종류
  final SubjectType type;

  /// 과목 코드
  final String subjectCode;

  TimeTableData({
    this.univ = '에타대학',
    this.prof = '',
    required this.dates,
    this.major,
    this.year,
    this.subjectName = '',
    this.type = SubjectType.libralArtsSelect,
    this.subjectCode = '000000-000',
  });
}
