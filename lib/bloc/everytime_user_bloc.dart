import 'dart:developer';

import 'package:everytime/model/time_table_page/grade_calculator_page/bar_chart_data.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/grade_of_term.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/grade_type.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/point_chart_data.dart';
import 'package:everytime/model/time_table_page/privacy_bounds.dart';
import 'package:everytime/model/time_table_page/time_table.dart';
import 'package:everytime/model/time_table_page/time_table_data.dart';
import 'package:rxdart/subjects.dart';

class EverytimeUserBloc {
  //****************************************************************************************************
  // 유저 관련
  //****************************************************************************************************
  // 유저 이름
  final _userName = BehaviorSubject<String>();
  // 유저의 친구
  // TODO:  시간표 완성하고 이 구문도 수정
  // final _userFriends = BehaviorSubject<List<EveryTimeFriend>>();
  //****************************************************************************************************
  // 시간표 관련
  // TODO: 서버 추가할 때 여기 데이터들도 올리기
  //****************************************************************************************************
  final _timeTableList = BehaviorSubject<List<TimeTable>>.seeded([]);
  final _selectedTimeTable = BehaviorSubject<TimeTable?>.seeded(null);

  Stream<List<TimeTable>> get timeTableList => _timeTableList.stream;
  Stream<TimeTable?> get selectedTimeTable => _selectedTimeTable.stream;

  Function(List<TimeTable>) get _updateTimeTableList => _timeTableList.sink.add;
  Function(TimeTable?) get updateSelectedTimeTable =>
      _selectedTimeTable.sink.add;

  List<TimeTable> get currentTimeTableList => _timeTableList.value;
  TimeTable? get currentSelectedTimeTable => _selectedTimeTable.value;

  void removeTimeTableList(String termString, String name) {
    Map<String, dynamic> result = findTimeTable(termString, name);

    if (result['timeTable'] == null || result['index'] == null) return;

    List<TimeTable> tempTimeTableList = currentTimeTableList;
    tempTimeTableList.removeAt(result['index']);
    _updateTimeTableList(tempTimeTableList);
  }

  void addTimeTableList(TimeTable newTimeTable) {
    List<TimeTable> tempList = currentTimeTableList;
    tempList.add(newTimeTable);
    _timeTableList.add(tempList);
  }

  void updateTimeTableList(
    String termString,
    String name, {
    String? newName,
    List<TimeTableData>? timeTableData,
    PrivacyBounds? privacyBounds,
    bool? isDefault,
  }) {
    Map<String, dynamic> result = findTimeTable(termString, name);

    if (result['timeTable'] == null || result['index'] == null) return;

    if (newName != null) result['timeTable'].updateName(newName);
    if (timeTableData != null) {
      result['timeTable'].updateTimeTableData(timeTableData);
    }
    if (privacyBounds != null) {
      result['timeTable'].updatePrivacyBounds(privacyBounds);
    }
    if (isDefault != null) result['timeTable'].updateIsDefault(isDefault);

    if (newName != null ||
        timeTableData != null ||
        privacyBounds != null ||
        isDefault != null) {
      List<TimeTable> tempTimeTableList = currentTimeTableList;
      tempTimeTableList.replaceRange(
        result['index'],
        result['index'] + 1,
        [result['timeTable']],
      );
      _updateTimeTableList(tempTimeTableList);
    }
  }

  Map<String, dynamic> findTimeTable(String termString, String name) {
    TimeTable? tempTimeTable;
    int? tempIndex;
    for (int i = 0; i < currentTimeTableList.length; i++) {
      if (currentTimeTableList[i].currentName == name &&
          currentTimeTableList[i].termString == termString) {
        tempTimeTable = currentTimeTableList[i];
        tempIndex = i;
      }
    }

    return {'timeTable': tempTimeTable, 'index': tempIndex};
  }

  //****************************************************************************************************
  // 성적 관련
  // TODO: 서버 추가할 때 여기 데이터들도 올리기
  //****************************************************************************************************
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

  // 각 변수들을 최신 상태로 업데이트
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

  // 테스트용 데이터
  void initGradeCalTest() {
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

  //****************************************************************************************************
  // 시스템 관련 변수들
  // TODO: 서버 추가할 때 이 데이터들은 제외
  //****************************************************************************************************
  final _isDark = BehaviorSubject<bool>.seeded(false);
  final _isShowingKeyboard = BehaviorSubject<bool>.seeded(false);
  final _termString = BehaviorSubject<String>();

  Stream<bool> get isDark => _isDark.stream;
  Function(bool) get updateIsDark => _isDark.sink.add;

  Stream<bool> get isShowingKeyboard => _isShowingKeyboard.stream;
  Function(bool) get updateIsShowingKeyboard => _isShowingKeyboard.sink.add;

  Stream<String> get termString => _termString.stream;
  void updateTermString() {
    DateTime now = DateTime.now();
    String term;

    if (now.month >= 3 && now.month <= 6) {
      term = '1학기';
    } else if (now.month >= 7 && now.month <= 8) {
      term = '여름학기';
    } else if (now.month >= 9 && now.month <= 12) {
      term = '2학기';
    } else {
      term = '겨울학기';
    }

    _termString.sink.add("${now.year}년 $term");
  }

  String get currentTermString => _termString.value;

  //****************************************************************************************************
  void dispose() {
    _userName.close();

    //****************************************************************************************************
    for (int i = 0; i < _timeTableList.value.length; i++) {
      _timeTableList.value[i].dispose();
    }
    _timeTableList.close();
    _selectedTimeTable.close();

    //****************************************************************************************************

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

    //****************************************************************************************************
    _isDark.close();
    _isShowingKeyboard.close();
    _termString.close();
  }
}
