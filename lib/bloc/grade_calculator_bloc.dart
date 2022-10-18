import 'package:rxdart/subjects.dart';

class GradeCalculatorBloc {
  final _currentTerm = BehaviorSubject<int>.seeded(0);

  final _isShowingSelectGrade = BehaviorSubject<bool>.seeded(false);
  final _currentSelectingIndex = BehaviorSubject<int?>.seeded(null);

  Stream<int> get currentTerm => _currentTerm.stream;
  Function(int) get updateCurrentTerm => _currentTerm.sink.add;

  Stream<bool> get isShowingSelectGrade => _isShowingSelectGrade.stream;
  Function(bool) get updateIsShowingSelectGrade =>
      _isShowingSelectGrade.sink.add;

  Stream<int?> get currentSelectingIndex => _currentSelectingIndex.stream;
  Function(int?) get updateCurrentSelectingIndex =>
      _currentSelectingIndex.sink.add;

  int get currentCurrentTerm => _currentTerm.value;

  dispose() {
    _currentTerm.close();

    _isShowingSelectGrade.close();
    _currentSelectingIndex.close();
  }
}
