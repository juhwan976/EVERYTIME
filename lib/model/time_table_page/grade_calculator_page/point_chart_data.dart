class PointChartData {
  /// 학기 ex) 1학년 1학기
  final String? term;

  /// 전체 평점
  final double? totalGrade;

  /// 전공 평점
  final double? majorGrade;

  PointChartData({
    required this.term,
    required this.majorGrade,
    required this.totalGrade,
  });
}
