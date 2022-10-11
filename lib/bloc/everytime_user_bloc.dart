import 'package:rxdart/subjects.dart';

class EverytimeUserBloc {
  final _userName = BehaviorSubject<String>();

  final _totalGradeAve = BehaviorSubject<double>.seeded(0.0);
  final _majorGradeAve = BehaviorSubject<double>.seeded(0.0);
  final _maxGrade = BehaviorSubject<double>.seeded(4.5);

  final _currentCredit = BehaviorSubject<int>.seeded(0);
  final _targetCredit = BehaviorSubject<int>.seeded(0);

  Stream<double> get totalGradeAve => _totalGradeAve.stream;
  Function(double) get updateTotalGradeAve => _totalGradeAve.sink.add;
  Stream<double> get majorGradeAve => _majorGradeAve.stream;
  Function(double) get updateMajorGradeAve => _majorGradeAve.sink.add;
  Stream<double> get maxGrade => _maxGrade.stream;
  Function(double) get updateMaxGrade => _maxGrade.sink.add;

  Stream<int> get currentCredit => _currentCredit.stream;
  Function(int) get updateCurrentCredit => _currentCredit.sink.add;
  Stream<int> get targetCredit => _targetCredit.stream;
  Function(int) get updateTargetCredit => _targetCredit.sink.add;

  initTest() {
    updateTotalGradeAve(4.12);
    updateMajorGradeAve(4.22);
    updateMaxGrade(4.5);

    updateCurrentCredit(143);
    updateTargetCredit(140);
  }

  dispose() {
    _userName.close();

    _totalGradeAve.close();
    _majorGradeAve.close();
    _maxGrade.close();

    _currentCredit.close();
    _targetCredit.close();
  }
}
