import 'dart:collection';
import 'dart:developer';

import 'package:everytime/model/bar_chart_data.dart';
import 'package:everytime/model/grade_of_term.dart';
import 'package:everytime/model/grade_type.dart';
import 'package:everytime/model/point_chart_data.dart';
import 'package:rxdart/subjects.dart';

class EverytimeUserBloc {
  // 유저 이름
  final _userName = BehaviorSubject<String>();
  // 전체 평점
  final _totalGradeAve = BehaviorSubject<double>.seeded(0.0);
  // 전공 평점
  final _majorGradeAve = BehaviorSubject<double>.seeded(0.0);
  // 평점의 최댓값. 혹시나 해서 만들어뒀다.
  final _maxAve = BehaviorSubject<double>.seeded(4.5);
  // 현재 획득한 학점
  final _currentCredit = BehaviorSubject<int>.seeded(0);
  // 채워야 하는 학점, 목표 학점
  final _targetCredit = BehaviorSubject<int>.seeded(0);
  // 점 그래프 데이터
  final _aveData = BehaviorSubject<List<PointChartData>>.seeded([]);
  // 바 그래프 데이터
  final _percentData = BehaviorSubject<List<BarChartData>>.seeded([]);

  Stream<double> get totalGradeAve => _totalGradeAve.stream;
  Function(double) get _updateTotalGradeAve => _totalGradeAve.sink.add;
  Stream<double> get majorGradeAve => _majorGradeAve.stream;
  Function(double) get _updateMajorGradeAve => _majorGradeAve.sink.add;
  Stream<double> get maxAve => _maxAve.stream;
  Function(double) get _updateMaxAve => _maxAve.sink.add;

  Stream<int> get currentCredit => _currentCredit.stream;
  Function(int) get _updateCurrentCredit => _currentCredit.sink.add;
  Stream<int> get targetCredit => _targetCredit.stream;
  Function(int) get updateTargetCredit => _targetCredit.sink.add;

  // 학기의 성적 정보
  final List<GradeOfTerm> _gradeOfTerms = [
    GradeOfTerm(
      term: '1학년 1학기',
    ),
    GradeOfTerm(
      term: '1학년 2학기',
    ),
    GradeOfTerm(
      term: '2학년 1학기',
    ),
    GradeOfTerm(
      term: '2학년 2학기',
    ),
    GradeOfTerm(
      term: '3학년 1학기',
    ),
    GradeOfTerm(
      term: '3학년 2학기',
    ),
    GradeOfTerm(
      term: '4학년 1학기',
    ),
    GradeOfTerm(
      term: '4학년 2학기',
    ),
    GradeOfTerm(
      term: '5학년 1학기',
    ),
    GradeOfTerm(
      term: '5학년 2학기',
    ),
    GradeOfTerm(
      term: '6학년 1학기',
    ),
    GradeOfTerm(
      term: '6학년 2학기',
    ),
    GradeOfTerm(
      term: '기타 학기',
    ),
  ];

  // 임시로 각 성적의 총합들을 저장할 공간. 자주 용하는거 같아서 전역 변수로 선언해줌.
  // ignore: prefer_for_elements_to_map_fromiterable, prefer_final_fields
  Map<GradeType, int> _tempGradesAmount = Map<GradeType, int>.fromIterable(
      GradeType.getGrades(),
      key: (element) => element,
      value: (element) => 0);

  int get getTermsLength => _gradeOfTerms.length;
  GradeOfTerm getTerm(int index) => _gradeOfTerms[index];
  Stream<double> getTotalGradeAve(int index) =>
      _gradeOfTerms[index].totalGradeAve;
  Stream<double> getMajorGradeAve(int index) =>
      _gradeOfTerms[index].majorGradeAve;
  Stream<int> getCreditAmount(int index) => _gradeOfTerms[index].creditAmount;

  void updateData() {
    double tempTotalGrade = 0.0;
    int tempTotalCredit = 0;
    double tempMajorGrade = 0.0;
    int tempMajorCredit = 0;
    int tempPCredit = 0;
    List<PointChartData> tempPointChartDataList = [];
    _tempGradesAmount.forEach(
      (key, value) => _tempGradesAmount[key] = 0,
    );

    for (int i = 0; i < _gradeOfTerms.length; i++) {
      tempTotalGrade += getTerm(i).currentTotalGrade;
      tempTotalCredit += getTerm(i).currentTotalCredit;
      tempMajorGrade += getTerm(i).currentMajorGrade;
      tempMajorCredit += getTerm(i).currentMajorCredit;
      tempPCredit += getTerm(i).currentPCredit;
      for (int j = 0; j < GradeType.getGrades().length; j++) {
        _tempGradesAmount.update(GradeType.getByIndex(j),
            (value) => value += getTerm(i).currentGradeAmountsElementAt(j));
      }
    }

    _updateTotalGradeAve(double.parse(
        (tempTotalGrade / (tempTotalCredit == 0 ? 1 : tempTotalCredit))
            .toStringAsFixed(2)));
    _updateMajorGradeAve(double.parse(
        (tempMajorGrade / (tempMajorCredit == 0 ? 1 : tempMajorCredit))
            .toStringAsFixed(2)));
    _updateCurrentCredit(tempTotalCredit + tempPCredit);

    for (int i = 0; i < getTermsLength; i++) {
      if (getTerm(i).currentTotalGradeAve == 0.0 &&
          getTerm(i).currentMajorGradeAve == 0.0) {
        continue;
      }
      tempPointChartDataList.add(PointChartData(
        term: getTerm(i).term,
        totalGrade: (getTerm(i).currentTotalGradeAve == 0.0)
            ? null
            : getTerm(i).currentTotalGradeAve,
        majorGrade: (getTerm(i).currentMajorGradeAve == 0.0)
            ? null
            : getTerm(i).currentMajorGradeAve,
      ));
    }
    _updateAveData(tempPointChartDataList);
    _updatePercentData();
  }

  Stream<List<PointChartData>> get aveData => _aveData.stream;
  Function(List<PointChartData>) get _updateAveData => _aveData.sink.add;

  Stream<List<BarChartData>> get percentData => _percentData.stream;
  void _updatePercentData() {
    Map<GradeType, int> sortByValue = Map.fromEntries(
        _tempGradesAmount.entries.toList()
          ..sort((e1, e2) => e2.value.compareTo(e1.value)));

    List<BarChartData> tempList = [];

    for (int i = 0; i < 5; i++) {
      if (sortByValue.values.elementAt(i) == 0) {
        continue;
      }

      tempList.add(BarChartData(
          percent:
              (sortByValue.values.elementAt(i) / _currentCredit.value * 100)
                  .round(),
          grade: (sortByValue.keys.elementAt(i).data)));
    }

    _percentData.sink.add(tempList);
  }

  void initTest() {
    updateTargetCredit(140);

    getTerm(0).updateSubject(
      0,
      credit: 9,
      gradeType: GradeType.ap,
    );
    getTerm(0).updateSubject(
      1,
      credit: 5,
      gradeType: GradeType.az,
    );
    getTerm(0).updateSubject(
      2,
      credit: 5,
      gradeType: GradeType.ap,
      isMajor: true,
    );
    getTerm(0).updateSubject(
      3,
      credit: 2,
      gradeType: GradeType.bp,
    );

    getTerm(1).updateSubject(
      0,
      credit: 4,
      gradeType: GradeType.ap,
    );
    getTerm(1).updateSubject(
      1,
      credit: 6,
      gradeType: GradeType.az,
    );
    getTerm(1).updateSubject(
      2,
      credit: 6,
      gradeType: GradeType.ap,
      isMajor: true,
    );
    getTerm(1).updateSubject(
      3,
      credit: 4,
      gradeType: GradeType.bz,
    );

    updateData();
  }

  void dispose() {
    _userName.close();

    _totalGradeAve.close();
    _majorGradeAve.close();
    _maxAve.close();

    _currentCredit.close();
    _targetCredit.close();

    for (int i = 0; i < _gradeOfTerms.length; i++) {
      _gradeOfTerms[i].dispose();
    }

    _aveData.close();
    _percentData.close();
  }
}
