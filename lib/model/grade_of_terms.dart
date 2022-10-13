import 'dart:developer';

import 'package:everytime/model/grade_type.dart';
import 'package:everytime/model/subject_info.dart';
import 'package:rxdart/subjects.dart';

class GradeOfTerms {
  GradeOfTerms({
    required this.term,
  });
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

  // 각종 성적 갯수? 학점?
  final List<BehaviorSubject<int>> _gradeAmounts = List.generate(
      GradeType.getGrades().length, (index) => BehaviorSubject.seeded(0));

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
  double get currentTotalGradeAve => _totalGradeAve.value;
  Stream<double> get majorGradeAve => _majorGradeAve.stream;
  double get currentMajorGradeAve => _majorGradeAve.value;
  Stream<int> get creditAmount => _creditAmount.stream;

  Stream<int> gradeAmountsElementAt(int index) => _gradeAmounts[index].stream;
  void _updateGradeAmountsElementAt(int index, int newValue) =>
      _gradeAmounts[index].sink.add(newValue);
  int currentGradeAmountsElementAt(int index) => _gradeAmounts[index].value;

  double get currentTotalGrade => _totalGrade.value;
  int get currentTotalCredit => _totalCredit.value;
  double get currentMajorGrade => _majorGrade.value;
  int get currentMajorCredit => _majorCredit.value;
  int get currentPCredit => _pCredit.value;

  void _updateTotalGradeAve(double newTotalGrade, int newTotalCredit) =>
      _totalGradeAve.sink.add(double.parse(
          (newTotalGrade / ((newTotalCredit == 0) ? 1 : newTotalCredit))
              .toStringAsFixed(2)));

  void _updateMajorGradeAve(double newMajorGrade, int newMajorCredit) =>
      _majorGradeAve.sink.add(double.parse(
          (newMajorGrade / ((newMajorCredit == 0) ? 1 : newMajorCredit))
              .toStringAsFixed(2)));

  void _updateCreditAmount(int newTotalCredit, int newPCredit) =>
      _creditAmount.sink.add(newTotalCredit + newPCredit);

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

  // ignore: prefer_for_elements_to_map_fromiterable, prefer_final_fields
  Map<GradeType, int> _tempGrades = Map.fromIterable(GradeType.getGrades(),
      key: (element) => element, value: (element) => 0);

  Stream<int> get subjectsLength => _subjectsLength.stream;
  int get currentSubjectLength => _subjects.length;
  Function(int) get _updateSubjectsLength => _subjectsLength.sink.add;

  SubjectInfo getSubject(int index) => _subjects[index];

  void updateGrades() {
    double tempTotalGrade = 0.0;
    int tempTotalCredit = 0;
    double tempMajorGrade = 0.0;
    int tempMajorCredit = 0;
    int tempPCredit = 0;
    _tempGrades.forEach(
      (key, value) => _tempGrades[key] = 0,
    );

    int credit = 0;
    GradeType gradeType = GradeType.f;
    bool isMajor = false;
    bool isPNP = false;

    for (int i = 0; i < _subjects.length; i++) {
      credit = _subjects[i].currentCredit;
      gradeType = _subjects[i].currentGradeType;
      isMajor = _subjects[i].currentIsMajor;
      isPNP = _subjects[i].currentIsPNP;

      // log("credit: ${credit}, gradeType: ${gradeType.data}, isMajor: ${isMajor}, isPNP: ${isPNP}");

      if (credit != 0) {
        if (gradeType.grade > 0) {
          tempTotalGrade += gradeType.grade * credit;
          tempTotalCredit += credit;

          if (isMajor) {
            tempMajorGrade += gradeType.grade * credit;
            tempMajorCredit += credit;
          }
        } else if (gradeType == GradeType.p && isPNP) {
          tempPCredit += credit;
        }

        _tempGrades.update(gradeType, (value) => value += credit);
      }
    }

    // log('${gradeType} : $credit');
    _tempGrades.forEach(
      (key, value) =>
          _updateGradeAmountsElementAt(GradeType.getIndex(key), value),
    );

    _updateTotalGrade(tempTotalGrade);
    _updateTotalCredit(tempTotalCredit);
    _updateMajorGrade(tempMajorGrade);
    _updateMajorCredit(tempMajorCredit);
    _updatePCredit(tempPCredit);

    _updateTotalGradeAve(tempTotalGrade, tempTotalCredit);
    _updateMajorGradeAve(tempMajorGrade, tempMajorCredit);
    _updateCreditAmount(tempTotalCredit, tempPCredit);
  }

  void updateSubject(
    int index, {
    String? title,
    int? credit,
    GradeType? gradeType,
    bool? isPNP,
    bool? isMajor,
  }) {
    if (_subjects.length < index) {
      for (int i = 0; i < index - _subjects.length; i++) {
        _subjects.add(SubjectInfo());
      }
      _updateSubjectsLength(_subjects.length);
    }

    if (title != null) _subjects[index].updateTitle(title);
    if (credit != null) _subjects[index].updateCredit(credit);
    if (gradeType != null) _subjects[index].updateGradeType(gradeType);
    if (isPNP != null) _subjects[index].updateIsPNP(isPNP);
    if (isMajor != null) _subjects[index].updateIsMajor(isMajor);

    if (credit != null ||
        gradeType != null ||
        isPNP != null ||
        isMajor != null) {
      updateGrades();
    }
  }

  void setDefault(int index) {
    // if (_subjects[index].currentCredit != 0) {
    //   _updateGradeAmountsElementAt(
    //       GradeType.getIndex(_subjects[index].currentGradeType),
    //       -currentGradeAmountsElementAt(
    //           GradeType.getIndex(_subjects[index].currentGradeType)));
    // }

    _subjects[index].updateTitle("");
    _subjects[index].updateCredit(0);
    _subjects[index].updateGradeType(GradeType.ap);
    _subjects[index].updateIsMajor(false);
    _subjects[index].updateIsPNP(false);
    updateGrades();
  }

  void dispose() {
    _totalGrade.close();
    _totalCredit.close();
    _majorGrade.close();
    _majorCredit.close();
    _pCredit.close();

    _totalGradeAve.close();
    _majorGradeAve.close();
    _creditAmount.close();

    for (int i = 0; i < _gradeAmounts.length; i++) {
      _gradeAmounts[i].close();
    }

    for (int i = 0; i < _subjects.length; i++) {
      _subjects[i].dispose();
    }
    _subjectsLength.close();
  }
}
