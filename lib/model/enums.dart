//********************************************************************
// time_table_page 에서 사용됨
//********************************************************************

/// 과목 타입
///
/// * [libralArtsSelect] : 교양 선택, (기본값)
/// * [libralArtsEssential] : 교양 필수
/// * [majorSelect] : 전공 선택
/// * [majorEssential] : 전공 필수
enum SubjectType {
  libralArtsSelect,
  libralArtsEssential,
  majorSelect,
  majorEssential
}

/// 시간표 공개 범위
///
/// * [everyone] : 모두 공개, (기본값)
/// * [onlyFriend] : 친구 공개
/// * [private] : 비공개
enum PrivacyBounds {
  everyone,
  onlyFriend,
  private,
}

/// 요일
enum DayOfWeek {
  undefined('?'),
  mon('월'),
  tue('화'),
  wed('수'),
  thu('목'),
  fri('금'),
  sat('토'),
  sun('일');

  const DayOfWeek(this.string);

  /// 요일의 문자값
  final String string;

  /// 시간표에서 사용할 요일 배열
  static List<DayOfWeek> getDayOfWeeks() {
    return [
      DayOfWeek.mon,
      DayOfWeek.tue,
      DayOfWeek.wed,
      DayOfWeek.thu,
      DayOfWeek.fri,
      DayOfWeek.sat,
      DayOfWeek.sun,
    ];
  }

  /// [index]로 해당 [getDayOfWeeks()]의 [DayOfWeek]값을 가져온다.
  ///
  /// inputs
  /// * [index] : [getDayOfWeeks()]에서 가져올 [DayOfWeek]의 [index]
  ///
  /// returns
  /// * [DayOfWeek] : [index]로 부터 반환된 결과값
  static DayOfWeek getByIndex(int index) {
    return getDayOfWeeks()[index];
  }

  /// [dayOfWeek]로 해당 [getDayOfWeeks()]의 [index]를 가져온다.
  ///
  /// inputs
  /// * [dayOfWeek] : [getDayOfWeeks()]에서 가져올 [DayOfWeek]의 값
  ///
  /// returns
  /// * [int] : [dayOfWeek]가 있는 [index]
  static int getByDayOfWeek(DayOfWeek dayOfWeek) {
    return getDayOfWeeks().indexOf(dayOfWeek);
  }
}

/// 성적 종류
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

  /// 성적의 표시값
  final String data;

  /// 성적의 점수
  final double grade;

  /// [getGrades()]로 [index]번째에 있는 값을 호출하는 함수
  ///
  /// inputs
  /// * [index] : 호출할 [index]
  ///
  /// returns
  /// * [GradeType] : [getGrades()]의 [index]번째에 있는 값
  static getByIndex(int index) {
    return GradeType.getGrades()[index];
  }

  /// 성적 선택 화면에서 보여줄 성적들의 리스트를 반환하는 함수
  static List<GradeType> getGrades() {
    return [
      GradeType.ap,
      GradeType.az,
      GradeType.bp,
      GradeType.bz,
      GradeType.cp,
      GradeType.cz,
      GradeType.dp,
      GradeType.dz,
      GradeType.f,
      GradeType.p,
      GradeType.np,
    ];
  }

  /// [getGrades()]함수에서 [gradeType]이 몇 번째에 있는지 [index] 값을 반환하는 함수
  ///
  /// inputs
  /// * [gradeType] : [getGrades()]에서 [index]값을 알아낼 [gradeType]
  ///
  /// returns
  /// * [int] : [gradeType]이 있는 [index]
  static int getIndex(GradeType gradeType) {
    return GradeType.getGrades().indexOf(gradeType);
  }

  /// [getGrades()]함수에서 [index] 번째에 있는 [gradeType.data]를 반환하는 함수
  ///
  /// inputs
  /// * [index] : [getGrades()]의 몇번재에 있는 값을 호출할 건지를 나타내는 변수
  ///
  /// returns
  /// * [String] : [getGrades()]의 [index]번째에 있는 [GradeType]의 [data]값
  static String getGradeElementAt(int index) {
    return GradeType.getGrades()[index].data;
  }
}
