import 'package:everytime/model/enums.dart';

class SubjectInfo {
  // 과목명
  String title = '';
  // 학점
  int credit = 0;
  // 성적
  GradeType gradeType = GradeType.ap;
  // p 또는 np 과목 여부
  bool isPNP = false;
  // 전공 과목 여부
  bool isMajor = false;
}
