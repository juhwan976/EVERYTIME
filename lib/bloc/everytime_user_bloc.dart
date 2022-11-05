import 'dart:math';

import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/bar_chart_data.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/grade_of_term.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/point_chart_data.dart';
import 'package:everytime/model/time_table_page/time_n_place_data.dart';
import 'package:everytime/model/time_table_page/time_table.dart';
import 'package:everytime/model/time_table_page/time_table_data.dart';
import 'package:rxdart/subjects.dart';

class EverytimeUserBloc {
  //****************************************************************************************************
  // 유저 관련
  //****************************************************************************************************

  /// 유저 이름
  final _name = BehaviorSubject<String>();

  /// 유저 학교
  final _univ = BehaviorSubject<String>();

  /// 유저 닉네임
  final _nickName = BehaviorSubject<String>();

  /// 유저 아이디
  final _id = BehaviorSubject<String>();

  /// 유저가 입학한 년도
  final _year = BehaviorSubject<int>();

  /// 유저의 친구
  /// TODO:  시간표 완성하고 이 구문도 수정
  // final _userFriends = BehaviorSubject<List<EveryTimeFriend>>();

  Stream<String> get name => _name.stream;
  Stream<String> get univ => _univ.stream;
  Stream<String> get nickName => _nickName.stream;
  Stream<String> get id => _id.stream;
  Stream<int> get year => _year.stream;

  Function(String) get updateName => _name.sink.add;
  Function(String) get updateUniv => _univ.sink.add;
  Function(String) get updateNickName => _nickName.sink.add;
  Function(String) get updateId => _id.sink.add;
  Function(int) get updateYear => _year.sink.add;

  //****************************************************************************************************
  // 시간표 관련
  // TODO: 서버 추가할 때 여기 데이터들도 올리기
  //****************************************************************************************************

  /// 시간표 리스트
  final _timeTableList = BehaviorSubject<List<TimeTable>>.seeded([]);

  /// 현재 선택된 시간표
  final _selectedTimeTable = BehaviorSubject<TimeTable?>.seeded(null);

  Stream<List<TimeTable>> get timeTableList => _timeTableList.stream;
  Stream<TimeTable?> get selectedTimeTable => _selectedTimeTable.stream;

  Function(List<TimeTable>) get _updateTimeTableList => _timeTableList.sink.add;
  Function(TimeTable?) get updateSelectedTimeTable =>
      _selectedTimeTable.sink.add;

  List<TimeTable> get currentTimeTableList => _timeTableList.value;
  TimeTable? get currentSelectedTimeTable => _selectedTimeTable.value;

  TimeTable? findTimeTableAtSpecificTerm(String termString) {
    List<TimeTable> timeTableList = currentTimeTableList;
    TimeTable? secondTimeTable;

    for (TimeTable timeTable in timeTableList) {
      if (timeTable.termString == termString) {
        if (timeTable.currentIsDefault) {
          return timeTable;
        }

        if (secondTimeTable == null) {
          secondTimeTable = timeTable;
          secondTimeTable.updateIsDefault(true);

          break;
        }
      }
    }

    return secondTimeTable;
  }

  void removeTimeTableDataAt(
    int currentIndex,
    List<TimeTableData> timeTableData,
  ) {
    int tempDayOfWeekIndex = defaultDayOfWeekListLast;
    int tempStartHour = defaultTimeListFirst;
    int tempEndHour = defaultTimeListLast;

    int removeDayOfWeekIndex = defaultDayOfWeekListLast;
    int removeStartHour = defaultTimeListFirst;
    int removeEndHour = defaultTimeListLast;

    for (int i = 0; i < timeTableData.length; i++) {
      for (TimeNPlaceData dates in timeTableData[i].dates) {
        if (i == currentIndex) {
          if (removeDayOfWeekIndex <
              DayOfWeek.getByDayOfWeek(dates.dayOfWeek)) {
            removeDayOfWeekIndex = DayOfWeek.getByDayOfWeek(dates.dayOfWeek);
          }

          if (removeStartHour > dates.startHour) {
            removeStartHour = dates.startHour;
          }

          if (removeEndHour < dates.endHour) {
            removeEndHour = dates.endHour;
          }
        } else {
          if (tempDayOfWeekIndex < DayOfWeek.getByDayOfWeek(dates.dayOfWeek)) {
            tempDayOfWeekIndex = DayOfWeek.getByDayOfWeek(dates.dayOfWeek);
          }

          if (tempStartHour > dates.startHour) {
            tempStartHour = dates.startHour;
          }

          if (tempEndHour < dates.endHour) {
            tempEndHour = dates.endHour;
          }
        }
      }
    }

    currentSelectedTimeTable!.removeTimeTableData(currentIndex);

    removeDayOfWeek(
      removeDayOfWeekIndex,
      [
        TimeNPlaceData(
          dayOfWeek: DayOfWeek.getByIndex(tempDayOfWeekIndex),
          startHour: tempStartHour,
          endHour: tempEndHour,
        ),
      ],
    );
    removeTimeList(
      removeStartHour,
      removeEndHour,
      [
        TimeNPlaceData(
          dayOfWeek: DayOfWeek.getByIndex(tempDayOfWeekIndex),
          startHour: tempStartHour,
          endHour: tempEndHour,
        ),
      ],
    );
  }

  /// 시간표를 추가할 때 현재 선택된 시간표의 내용과 겹치는게 있는지 판별
  ///
  /// inputs
  /// * [data] : 비교를 수행할 데이터
  ///
  /// returns
  /// * [String] : [null]일 경우 통과, 그 외의 경우 겹치는 항목이 있음.
  String? checkTimeTableCrash(TimeTableData data) {
    String? result;

    // 입력한 값들과 비교
    for (int oldIndex = 0; oldIndex < data.dates.length; oldIndex++) {
      TimeNPlaceData oldData = data.dates[oldIndex];
      for (int newIndex = 0; newIndex < data.dates.length; newIndex++) {
        if (oldIndex == newIndex) {
          continue;
        }

        TimeNPlaceData newData = data.dates[newIndex];

        if (oldData.dayOfWeek == newData.dayOfWeek) {
          DateTime newStartTime =
              DateTime(1970, 1, 1, newData.startHour, newData.startMinute);
          DateTime newEndTime =
              DateTime(1970, 1, 1, newData.endHour, newData.endMinute);
          DateTime oldStartTime =
              DateTime(1970, 1, 1, oldData.startHour, oldData.startMinute);
          DateTime oldEndTime =
              DateTime(1970, 1, 1, oldData.endHour, oldData.endMinute);

          int oldPlayTime = oldEndTime.difference(oldStartTime).inMinutes;

          if (newStartTime.difference(oldStartTime).inMinutes >= oldPlayTime) {
            /* do nothing */
          } else if (oldEndTime.difference(newEndTime).inMinutes >=
              oldPlayTime) {
            /* do nothing */
          } else {
            result = '입력 받은';
            break;
          }
        }
      }
    }

    if (result != null) {
      return result;
    }

    // 전체 시간표와 비교
    for (TimeTableData timeTableData
        in currentSelectedTimeTable!.currentTimeTableData) {
      for (TimeNPlaceData oldData in timeTableData.dates) {
        for (TimeNPlaceData newData in data.dates) {
          if (oldData.dayOfWeek == newData.dayOfWeek) {
            DateTime newStartTime =
                DateTime(1970, 1, 1, newData.startHour, newData.startMinute);
            DateTime newEndTime =
                DateTime(1970, 1, 1, newData.endHour, newData.endMinute);
            DateTime oldStartTime =
                DateTime(1970, 1, 1, oldData.startHour, oldData.startMinute);
            DateTime oldEndTime =
                DateTime(1970, 1, 1, oldData.endHour, oldData.endMinute);

            int oldPlayTime = oldEndTime.difference(oldStartTime).inMinutes;

            if (newStartTime.difference(oldStartTime).inMinutes >=
                oldPlayTime) {
              /* do nothing */
            } else if (oldEndTime.difference(newEndTime).inMinutes >=
                oldPlayTime) {
              /* do nothing */
            } else {
              result = timeTableData.subjectName;
              break;
            }
          }
        }
      }

      if (result != null) {
        break;
      }
    }

    return result;
  }

  /// 입력받은 [termString]과 [name]을 가진 시간표를 삭제
  ///
  /// inputs
  /// * [termString] : 학기 이름 ex) 2022년 1학기
  /// * [name] : 시간표의 이름
  void removeTimeTableList(String termString, String name) {
    Map<String, dynamic> result = findTimeTable(termString, name);

    if (result['timeTable'] == null || result['index'] == null) return;

    List<TimeTable> tempTimeTableList = currentTimeTableList;
    tempTimeTableList.removeAt(result['index']);
    _updateTimeTableList(tempTimeTableList);
  }

  /// 입력받은 시간표를 시간표 리스트에 추가
  ///
  /// inputs
  /// * [newTimeTable] : 원래의 시간표 리스트에 추가할 새로운 시간표
  void addTimeTableList(TimeTable newTimeTable) {
    List<TimeTable> tempList = currentTimeTableList;
    tempList.add(newTimeTable);
    _timeTableList.add(tempList);
  }

  /// 입력받은 [termString]과 [name]으로 그 시간표를 찾아서
  /// 옵션으로 입력받는 변수들을 이용해서 데이터를 갱신
  ///
  /// inputs
  /// * [terString] : 학기 이름 ex) 2022년 1학기
  /// * [name] : 시간표 이름
  ///
  /// inputs(option)
  /// * [newName] : 시간표의 이름
  /// * [timeTableData] : 시간표 정보
  /// * [privacyBounds] : 공개 범위
  /// * [isDefault] : 이 시간표가 기본 시간표인지
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

  /// 입력받은 [termString]과 [name]을 이용해서 시간표를 찾아서 반환해주는 함수
  ///
  /// inputs
  /// * [termString] : 학기 이름 ex) 2022년 1학기
  /// * [name] : 시간표 이름
  ///
  /// returns
  /// * ['timeTable'] : [_timeTableList]에서 찾은 시간표
  /// * ['index'] : 찾은 시간표의 [_timeTableList]에서 인덱스값
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

  /// [_timeList]의 기본 길이 값
  ///
  // ignore: constant_identifier_names
  static const DEFAULT_TIME_LIST_LENGTH = 7;
  int get defaultTimeListLength => DEFAULT_TIME_LIST_LENGTH;

  /// [_timeList]의 [0]의 기본 값
  ///
  // ignore: constant_identifier_names
  static const DEFAULT_TIME_LIST_FIRST = 9;
  int get defaultTimeListFirst => DEFAULT_TIME_LIST_FIRST;

  /// [_timeList]의 [last]의 기본 값
  ///
  // ignore: constant_identifier_names
  static const DEFAULT_TIME_LIST_LAST = 15;
  int get defaultTimeListLast => DEFAULT_TIME_LIST_LAST;

  /// [_dayOfWeekList]의 [last]의 기본 값
  ///
  // ignore: constant_identifier_names
  static const DEFAULT_DAY_OF_WEEK_LIST_LAST = 4;
  int get defaultDayOfWeekListLast => DEFAULT_DAY_OF_WEEK_LIST_LAST;

  /// 시간표의 시간 부분을 저장할 변수
  final _timeList =
      BehaviorSubject<List<int>>.seeded([9, 10, 11, 12, 13, 14, 15]);

  /// 시간표의 요일 부분을 저장할 변수
  final _dayOfWeekList = BehaviorSubject<List<DayOfWeek>>.seeded([
    DayOfWeek.mon,
    DayOfWeek.tue,
    DayOfWeek.wed,
    DayOfWeek.thu,
    DayOfWeek.fri
  ]);

  Stream<List<int>> get timeList => _timeList.stream;
  Stream<List<DayOfWeek>> get dayOfWeek => _dayOfWeekList.stream;

  Function(List<int>) get updateTimeList => _timeList.sink.add;
  Function(List<DayOfWeek>) get updateDayOfWeekList => _dayOfWeekList.sink.add;

  List<int> get currentTimeList => _timeList.value;
  List<DayOfWeek> get currentDayOfWeek => _dayOfWeekList.value;

  /// 입력받은 지우려는 값의 [startHour]와 [endHour]을 이용해서 [timeNPlaceData]에서
  /// 값을 판별해서 일정 만큼 [_timeList]에서 시간 값들을 지우는 함수
  ///
  /// inputs
  /// * [startHour] : 시작 시간
  /// * [endHour] : 끝나는 시간
  /// * [timeNPlaceData] : 비교를 수행할 데이터
  ///
  /// TODO: 주석을 좀 더 명확하게 써야할 듯
  void removeTimeList(
      int startHour, int endHour, List<TimeNPlaceData> timeNPlaceData) {
    int minHour = min(startHour, endHour);
    int maxHour = max(startHour, endHour);
    bool minCheck = false;
    bool maxCheck = false;

    if (minHour >= DEFAULT_TIME_LIST_FIRST) {
      minCheck = true;
    }
    if (maxHour <= DEFAULT_TIME_LIST_LAST) {
      maxCheck = true;
    }
    if (minCheck && maxCheck) return;

    bool isSmallExist = false;
    bool isLargeExist = false;
    int largestHour = DEFAULT_TIME_LIST_LAST;
    int smallestHour = DEFAULT_TIME_LIST_FIRST;

    for (int i = 0; i < timeNPlaceData.length; i++) {
      if (min(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour) <=
          minHour) {
        isSmallExist = true;
      } else {
        if (smallestHour >=
            min(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour)) {
          smallestHour =
              min(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour);
        }
      }

      if (max(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour) >=
          maxHour) {
        isLargeExist = true;
      } else {
        if (largestHour <=
            max(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour)) {
          largestHour =
              max(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour);
        }
      }
    }

    List<int> currentList = currentTimeList;
    if (!isSmallExist) {
      smallestHour = (smallestHour >= DEFAULT_TIME_LIST_FIRST)
          ? DEFAULT_TIME_LIST_FIRST
          : smallestHour;

      for (int i = (smallestHour - minHour); i >= 1; i--) {
        currentList.removeAt(0);
      }
    }

    if (!isLargeExist) {
      largestHour = (largestHour <= DEFAULT_TIME_LIST_LAST)
          ? DEFAULT_TIME_LIST_LAST
          : largestHour;

      for (int i = (maxHour - largestHour); i >= 1; i--) {
        currentList.removeLast();
      }
    }

    updateTimeList(currentList);
  }

  /// [startHour], [endHour]를 현재의 [_timeList]와 비교해서
  /// 최대값 또는 최소값이 [startHour], [endHour] 중에 존재 할 경우
  /// 그 시간만큼을 [_timeList]에 추가하는 함수
  ///
  /// inputs
  /// * [startHour] : 시간 시간
  /// * [endHour] : 끝나는 시간
  void addTimeList(int startHour, int endHour) {
    int maxHour = max(startHour, endHour);
    int minHour = min(startHour, endHour);
    List<int> currentList = currentTimeList;

    if (minHour < currentTimeList.first) {
      int currentFirst = currentList.first;

      for (int i = 1; i <= currentFirst - minHour; i++) {
        currentList.insert(0, currentList.first - 1);
      }
    }

    if (maxHour > currentList.last) {
      int currentLast = currentList.last;

      for (int i = 1; i <= maxHour - currentLast; i++) {
        currentList.add(currentList.last + 1);
      }
    }

    updateTimeList(currentList);
  }

  /// 입력받은 [dayOfWeekIndex]를 [timeNPlaceData]와 비교해서 적절한 만큼의
  /// 요일을 [_dayOfWeekList]에서 제거하는 함수
  ///
  /// inputs
  /// * [dayOfWeekIndex] : 제거 할 요일의 인덱스, [DayOfWeek.getByDayOfWeek] 사용 권장
  /// * [timeNPlaceData] : 비교룰 수행할 데이터
  void removeDayOfWeek(
      int dayOfWeekIndex, List<TimeNPlaceData> timeNPlaceData) {
    if (dayOfWeekIndex <= DEFAULT_DAY_OF_WEEK_LIST_LAST) {
      return;
    }

    bool isExist = false;
    int largestIndex = DEFAULT_DAY_OF_WEEK_LIST_LAST;

    for (int i = 0; i < timeNPlaceData.length; i++) {
      if (timeNPlaceData[i].dayOfWeek.index >=
          DayOfWeek.getByIndex(dayOfWeekIndex).index) {
        isExist = true;
      } else {
        largestIndex = DayOfWeek.getByDayOfWeek(timeNPlaceData[i].dayOfWeek);
      }
    }

    List<DayOfWeek> currentList = currentDayOfWeek;
    if (!isExist) {
      largestIndex = (largestIndex <= DEFAULT_DAY_OF_WEEK_LIST_LAST)
          ? DEFAULT_DAY_OF_WEEK_LIST_LAST
          : largestIndex;

      for (int i = (dayOfWeekIndex - largestIndex); i >= 1; i--) {
        currentList.removeLast();
      }
    }
    updateDayOfWeekList(currentList);
  }

  /// 입력받은 [dayOfWeekIndex]가 현재의 [_dayOfWeekList]에 있는지 판단해서
  /// 없다면 그 차이만큼 요일을 추가하는 함수
  ///
  /// inputs
  /// * [dayOfWeekIndex] : 요일의 인덱스, [DayOfWeek.getByDayOfWeek] 사용 권장
  void addDayOfWeek(int dayOfWeekIndex) {
    if (dayOfWeekIndex > currentDayOfWeek.length - 1) {
      List<DayOfWeek> currentList = currentDayOfWeek;
      int currentLength = currentList.length;

      for (int i = 1; i <= dayOfWeekIndex - (currentLength - 1); i++) {
        currentList.add(DayOfWeek.getByIndex(currentLength - 1 + i));
      }

      updateDayOfWeekList(currentList);
    }
  }

  //****************************************************************************************************
  // 성적 관련
  // TODO: 서버 추가할 때 여기 데이터들도 올리기
  //****************************************************************************************************

  /// 전체 평점
  final _totalGradeAve = BehaviorSubject<double>.seeded(0.0);

  /// 전공 평점
  final _majorGradeAve = BehaviorSubject<double>.seeded(0.0);

  /// 평점의 최댓값. 혹시나 해서 만들어뒀다.
  final _maxAve = BehaviorSubject<double>.seeded(4.5);

  /// 현재 획득한 학점
  final _currentCredit = BehaviorSubject<int>.seeded(0);

  /// 채워야 하는 학점, 목표 학점
  final _targetCredit = BehaviorSubject<int>.seeded(0);

  /// 점 그래프 데이터
  final _aveData = BehaviorSubject<List<PointChartData>>.seeded([]);

  /// 바 그래프 데이터
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

  /// 학기의 성적 정보
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

  /// 임시로 각 성적의 총합들을 저장할 공간. 자주 용하는거 같아서 전역 변수로 선언해줌.
  ///
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

  /// 각 변수들을 최신 상태로 업데이트 하는 함수
  ///
  /// target
  /// * [totalGrade]
  /// * [totalCredit]
  /// * [majorGrade]
  /// * [majorCredit]
  /// * [pCredit]
  /// * [totalGradeAve]
  /// * [majorGradeAve]
  /// * [currentCredit]
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

  /// [_percentData]를 [_tempGradesAmount]에 있는 데이터를 바탕으로 업데이트하는 함수
  void _updatePercentData() {
    Map<GradeType, int> sortByValue = Map.fromEntries(
        _tempGradesAmount.entries.toList()
          ..sort((e1, e2) => e2.value.compareTo(e1.value)));

    List<BarChartData> tempList = [];

    for (int i = 0; i < 5; i++) {
      if (sortByValue.values.elementAt(i) == 0) {
        continue;
      }

      tempList.add(
        BarChartData(
          percent:
              (sortByValue.values.elementAt(i) / _currentCredit.value * 100)
                  .round(),
          grade: (sortByValue.keys.elementAt(i).data),
        ),
      );
    }

    _percentData.sink.add(tempList);
  }

  /// 테스트용 데이터
  ///
  /// TODO: 나중에 지우기
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

  /// 현재 다크모드인지 나타내는 변수
  final _isDark = BehaviorSubject<bool>.seeded(false);

  /// 현재 키보드가 보여지고 있는지 나타내는 변수
  final _isShowingKeyboard = BehaviorSubject<bool>.seeded(false);

  /// 현재 학기를 나타낼 문자열 ex) 2022년 2학기
  final _termString = BehaviorSubject<String>();

  Stream<bool> get isDark => _isDark.stream;
  Function(bool) get updateIsDark => _isDark.sink.add;

  Stream<bool> get isShowingKeyboard => _isShowingKeyboard.stream;
  Function(bool) get updateIsShowingKeyboard => _isShowingKeyboard.sink.add;

  bool get currentIsShowingKeyboard => _isShowingKeyboard.value;

  Stream<String> get termString => _termString.stream;

  /// 현재 시간을 기반으로 [_termString]을 갱신
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
    _name.close();
    _univ.close();
    _nickName.close();
    _id.close();
    _year.close();

    //****************************************************************************************************
    for (int i = 0; i < _timeTableList.value.length; i++) {
      _timeTableList.value[i].dispose();
    }
    _timeTableList.close();
    _selectedTimeTable.close();

    _timeList.close();
    _dayOfWeekList.close();

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
