import 'package:rxdart/subjects.dart';

class GradeCalculatorBloc {
  /// 현재 선택된 학기
  final _currentTerm = BehaviorSubject<int>.seeded(0);

  /// 성적을 변경할 때 [animateTo] 사용을 위해서
  /// [ModalBottomSheet] 가 나와있는지 저장할 변수
  final _isShowingSelectGrade = BehaviorSubject<bool>.seeded(false);

  /// 현재 선택중인 성적의 인덱스
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
