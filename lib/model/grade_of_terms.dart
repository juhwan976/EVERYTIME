import 'package:rxdart/subjects.dart';

class GradeOfTerms {
  // 학기 이름
  final String term;
  // 학점 * 점수의 총합
  final _totalGrade = BehaviorSubject<double>.seeded(0.0);
  // P 과목의 학점을 제외한 모든 학점
  final _totalCredit = BehaviorSubject<int>.seeded(0);
  // 전공 과목의 학점 * 점수의 총합
  final _majorGrade = BehaviorSubject<double>.seeded(0.0);
  // 전공과목의 P 과목의 학점을 제외한 모든 학점
  final _majorCredit = BehaviorSubject<int>.seeded(0);
  // P 과목의 학점
  final _pCredit = BehaviorSubject<int>.seeded(0);

  // 평점
  final _totalGradeAve = BehaviorSubject<double>.seeded(0.0);
  // 전공 평점
  final _majorGradeAve = BehaviorSubject<double>.seeded(0.0);
  // 취득 학점
  final _creditAmount = BehaviorSubject<int>.seeded(0);

  // subjects배열 길이의 기본값
  // ignore: constant_identifier_names
  static const DEFAULT_SUBJECTS_LENGTH = 10;
  // subjects배열 길이
  final _subjectsLength = BehaviorSubject<int>.seeded(DEFAULT_SUBJECTS_LENGTH);
  // ignore: prefer_final_fields
  List<SubjectInfo> _subjects = [
    SubjectInfo(),
    SubjectInfo(),
    SubjectInfo(),
    SubjectInfo(),
    SubjectInfo(),
    SubjectInfo(),
    SubjectInfo(),
    SubjectInfo(),
    SubjectInfo(),
    SubjectInfo(),
  ];

  GradeOfTerms({
    required this.term,
  });

  Stream<double> get totalGrade => _totalGrade.stream;
  Stream<int> get totalCredit => _totalCredit.stream;
  Stream<double> get majorGrade => _majorGrade.stream;
  Stream<int> get majorCredit => _majorCredit.stream;
  Stream<int> get pCredit => _pCredit.stream;

  Function(double) get _updateTotalGrade => _totalGrade.sink.add;
  Function(int) get _updateTotalCredit => _totalCredit.sink.add;
  Function(double) get _updateMajorGrade => _majorGrade.sink.add;
  Function(int) get _updateMajorCredit => _majorCredit.sink.add;
  Function(int) get _updatePCredit => _pCredit.sink.add;

  Stream<double> get totalGradeAve => _totalGradeAve.stream;
  Stream<double> get majorGradeAve => _majorGradeAve.stream;
  Stream<int> get creditAmount => _creditAmount.stream;

  _updateTotalGradeAve(double newTotalGrade, int newTotalCredit) =>
      _totalGradeAve.sink.add(
          double.parse((newTotalGrade / newTotalCredit).toStringAsFixed(2)));

  _updateMajorGradeAve(double newMajorGrade, int newMajorCredit) =>
      _majorGradeAve.sink.add(
          double.parse((newMajorGrade / newMajorCredit).toStringAsFixed(2)));

  _updateCreditAmount(int newTotalCredit, int newPCredit) =>
      _creditAmount.sink.add(newTotalCredit + newPCredit);

  Stream<int> get subjectsLength => _subjectsLength.stream;
  Function(int) get _updateSubjectsLength => _subjectsLength.sink.add;

  updateGrades() {
    double tempTotalGrade = 0.0;
    int tempTotalCredit = 0;
    double tempMajorGrade = 0.0;
    int tempMajorCredit = 0;
    int tempPCredit = 0;

    for (int i = 0; i < _subjects.length; i++) {
      if (_subjects[i].credit != 0) {
        if (_subjects[i].gradeType.grade > 0) {
          // 학점이 0이 아닌데 성적도 0보다 클 경우,
          tempTotalGrade += _subjects[i].gradeType.grade * _subjects[i].credit;
          tempTotalCredit += _subjects[i].credit;

          if (_subjects[i].isMajor) {
            tempMajorGrade +=
                _subjects[i].gradeType.grade * _subjects[i].credit;
            tempMajorCredit += _subjects[i].credit;
          }
        } else if (_subjects[i].isPNP &&
            _subjects[i].gradeType == GradeType.p) {
          tempPCredit += _subjects[i].credit;
        }
      }
    }

    _updateTotalGrade(tempTotalGrade);
    _updateTotalCredit(tempTotalCredit);
    _updateMajorGrade(tempMajorGrade);
    _updateMajorCredit(tempMajorCredit);
    _updatePCredit(tempPCredit);

    _updateTotalGradeAve(tempTotalGrade, tempTotalCredit);
    _updateMajorGradeAve(tempMajorGrade, tempMajorCredit);
    _updateCreditAmount(tempTotalCredit, tempPCredit);
  }

  updateSubjects(int index, String title, int credit, GradeType gradeType,
      bool isPNP, bool isMajor) {
    if (_subjects.length < index) {
      for (int i = 0; i < index - _subjects.length; i++) {
        _subjects.add(SubjectInfo());
      }
      _updateSubjectsLength(_subjects.length);
    }

    _subjects[index] = SubjectInfo(
      title: title,
      credit: credit,
      gradeType: gradeType,
      isMajor: isMajor,
      isPNP: isPNP,
    );

    updateGrades();
  }

  dispose() {
    _totalGrade.close();
    _totalCredit.close();
    _majorGrade.close();
    _majorCredit.close();
    _pCredit.close();

    _totalGradeAve.close();
    _majorGradeAve.close();
    _creditAmount.close();

    _subjectsLength.close();
  }
}

class SubjectInfo {
  final String title;
  final int credit;
  final GradeType gradeType;
  final bool isPNP;
  final bool isMajor;

  SubjectInfo({
    this.title = '',
    this.credit = 0,
    this.gradeType = GradeType.f,
    this.isPNP = false,
    this.isMajor = false,
  });
}

enum GradeType {
  ap('A+', 4.5),
  az('A0', 4.0),
  bp('B+', 3.5),
  bz('B0', 3.0),
  cp('C+', 2.5),
  cz('C0', 2.0),
  dp('D+', 1.5),
  dz('D0', 1.0),
  f('F', 0.0),
  p('P', 0.0),
  np('NP', 0.0),
  undefined('undefined', 0.0);

  const GradeType(this.data, this.grade);
  final String data;
  final double grade;

  factory GradeType.getByData(String data) {
    return GradeType.values.firstWhere(
      (value) => value.data == data,
      orElse: () => GradeType.undefined,
    );
  }
}
