//********************************************************************
// time_table_page
//********************************************************************
enum SubjectType {
  libralArtsSelect,
  libralArtsEssential,
  majorSelect,
  majorEssential
}

enum PrivacyBounds {
  everyone,
  onlyFriend,
  private,
}

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
  final String string;

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

  static DayOfWeek getByIndex(int index) {
    return getDayOfWeeks()[index];
  }

  static int getByDayOfWeek(DayOfWeek dayOfWeek) {
    return getDayOfWeeks().indexOf(dayOfWeek);
  }
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

  static getByIndex(int index) {
    return GradeType.getGrades()[index];
  }

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

  static int getIndex(GradeType gradeType) {
    return GradeType.getGrades().indexOf(gradeType);
  }

  static String getGradeElementAt(int index) {
    return GradeType.getGrades()[index].data;
  }
}
