import 'package:everytime/model/grade_of_terms.dart';
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

  List<String> get getTerms =>
      List.generate(_gradeOfTerms.length, (index) => _gradeOfTerms[index].term);
  int get getTermsLength => _gradeOfTerms.length;
  String getTerm(int index) => _gradeOfTerms[index].term;
  Stream<double> getTotalGrade(int index) => _gradeOfTerms[index].totalGrade;
  Stream<int> getTotalCredit(int index) => _gradeOfTerms[index].totalCredit;
  Stream<double> getMajorGrade(int index) => _gradeOfTerms[index].majorGrade;
  Stream<int> getMajorCredit(int index) => _gradeOfTerms[index].majorCredit;
  Stream<int> getPCredit(int index) => _gradeOfTerms[index].pCredit;
  Stream<int> getSubjectsLength(int index) =>
      _gradeOfTerms[index].subjectsLength;

  Stream<double> getTotalGradeAve(int index) =>
      _gradeOfTerms[index].totalGradeAve;
  Stream<double> getMajorGradeAve(int index) =>
      _gradeOfTerms[index].majorGradeAve;
  Stream<int> getCreditAmount(int index) => _gradeOfTerms[index].creditAmount;
  updateTerms(int termIndex, int subjectIndex, SubjectInfo subjectInfo) {
    _gradeOfTerms[termIndex].updateSubjects(
      subjectIndex,
      subjectInfo.title,
      subjectInfo.credit,
      subjectInfo.gradeType,
      subjectInfo.isPNP,
      subjectInfo.isMajor,
    );

    double tempTotalGrade = 0.0;
    int tempTotalCredit = 0;
    double tempMajorGrade = 0.0;
    int tempMajorCredit = 0;
    int tempPCredit = 0;

    for (int i = 0; i < _gradeOfTerms.length; i++) {
      getTotalGrade(i).last.then(
            (value) => tempTotalGrade += value,
          );
      getTotalCredit(i).last.then(
            (value) => tempTotalCredit += value,
          );
      getMajorGrade(i).last.then(
            (value) => tempMajorGrade += value,
          );
      getMajorCredit(i).last.then(
            (value) => tempMajorCredit += value,
          );
      getPCredit(i).last.then((value) => tempPCredit += value);
    }

    _updateTotalGradeAve(
        double.parse((tempTotalGrade / tempTotalCredit).toStringAsFixed(2)));
    _updateMajorGradeAve(
        double.parse((tempMajorGrade / tempMajorCredit).toStringAsFixed(2)));
    _updateCurrentCredit(tempTotalCredit + tempPCredit);
  }

  initTest() {
    _updateTotalGradeAve(4.12);
    _updateMajorGradeAve(4.22);
    _updateMaxGrade(4.5);

    _updateCurrentCredit(143);
    updateTargetCredit(140);
  }

  dispose() {
    _userName.close();

    _totalGradeAve.close();
    _majorGradeAve.close();
    _maxGrade.close();

    _currentCredit.close();
    _targetCredit.close();

    for (int i = 0; i < _gradeOfTerms.length; i++) {
      _gradeOfTerms[i].dispose();
    }
  }
}
