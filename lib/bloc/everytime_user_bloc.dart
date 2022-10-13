import 'dart:collection';
import 'dart:developer';

import 'package:everytime/model/bar_chart_data.dart';
import 'package:everytime/model/grade_of_terms.dart';
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
  final _maxGrade = BehaviorSubject<double>.seeded(4.5);
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
  Stream<double> get maxGrade => _maxGrade.stream;
  Function(double) get _updateMaxGrade => _maxGrade.sink.add;

  Stream<int> get currentCredit => _currentCredit.stream;
  Function(int) get _updateCurrentCredit => _currentCredit.sink.add;
  Stream<int> get targetCredit => _targetCredit.stream;
  Function(int) get updateTargetCredit => _targetCredit.sink.add;

  final List<GradeOfTerms> _gradeOfTerms = [
    GradeOfTerms(
      term: '1학년 1학기',
    ),
    GradeOfTerms(
      term: '1학년 2학기',
    ),
    GradeOfTerms(
      term: '2학년 1학기',
    ),
    GradeOfTerms(
      term: '2학년 2학기',
    ),
    GradeOfTerms(
      term: '3학년 1학기',
    ),
    GradeOfTerms(
      term: '3학년 2학기',
    ),
    GradeOfTerms(
      term: '4학년 1학기',
    ),
    GradeOfTerms(
      term: '4학년 2학기',
    ),
    GradeOfTerms(
      term: '5학년 1학기',
    ),
    GradeOfTerms(
      term: '5학년 2학기',
    ),
    GradeOfTerms(
      term: '6학년 1학기',
    ),
    GradeOfTerms(
      term: '6학년 2학기',
    ),
    GradeOfTerms(
      term: '기타 학기',
    ),
  ];

  // ignore: prefer_for_elements_to_map_fromiterable, prefer_final_fields
  Map<GradeType, int> _tempGradesAmount = Map<GradeType, int>.fromIterable(
      GradeType.getGrades(),
      key: (element) => element,
      value: (element) => 0);

  int get getTermsLength => _gradeOfTerms.length;
  GradeOfTerms getTerm(int index) => _gradeOfTerms[index];
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
    //tempGradesAmount._updatePercentData(tempGradesAmountList);
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
    _updateTotalGradeAve(4.12);
    _updateMajorGradeAve(4.22);
    _updateMaxGrade(4.5);

    _updateCurrentCredit(102);
    updateTargetCredit(140);
  }

  void dispose() {
    _userName.close();

    _totalGradeAve.close();
    _majorGradeAve.close();
    _maxGrade.close();

    _currentCredit.close();
    _targetCredit.close();

    for (int i = 0; i < _gradeOfTerms.length; i++) {
      _gradeOfTerms[i].dispose();
    }

    _aveData.close();
    _percentData.close();
  }
}
