import 'package:everytime/model/grade_type.dart';
import 'package:rxdart/subjects.dart';

class SubjectInfo {
  final _title = BehaviorSubject<String>.seeded('');
  final _credit = BehaviorSubject<int>.seeded(0);
  final _gradeType = BehaviorSubject<GradeType>.seeded(GradeType.ap);
  final _isPNP = BehaviorSubject<bool>.seeded(false);
  final _isMajor = BehaviorSubject<bool>.seeded(false);

  Stream<String> get title => _title.stream;
  Function(String) get updateTitle => _title.sink.add;
  Stream<int> get credit => _credit.stream;
  Function(int) get updateCredit => _credit.sink.add;
  Stream<GradeType> get gradeType => _gradeType.stream;
  Function(GradeType) get updateGradeType => _gradeType.sink.add;
  Stream<bool> get isPNP => _isPNP.stream;
  Function(bool) get updateIsPNP => _isPNP.sink.add;
  Stream<bool> get isMajor => _isMajor.stream;
  Function(bool) get updateIsMajor => _isMajor.sink.add;

  // current values
  String get currentTitle => _title.value;
  int get currentCredit => _credit.value;
  GradeType get currentGradeType => _gradeType.value;
  bool get currentIsPNP => _isPNP.value;
  bool get currentIsMajor => _isMajor.value;

  void dispose() {
    _title.close();
    _credit.close();
    _gradeType.close();
    _isPNP.close();
    _isMajor.close();
  }
}
