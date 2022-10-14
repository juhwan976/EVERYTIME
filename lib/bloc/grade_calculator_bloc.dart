import 'package:rxdart/subjects.dart';

class GradeCalculatorBloc {
  final _currentTerm = BehaviorSubject<int>.seeded(0);

  Stream<int> get currentTerm => _currentTerm.stream;
  Function(int) get updateCurrentTerm => _currentTerm.sink.add;

  dispose() {
    _currentTerm.close();
  }
}
