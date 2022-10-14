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
