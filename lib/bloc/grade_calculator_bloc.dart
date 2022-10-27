import 'package:rxdart/subjects.dart';

class GradeCalculatorBloc {
  /// 현재 선택된 학기
  final _currentTerm = BehaviorSubject<int>.seeded(0);

  /// 성적을 변경할 때 [animateTo] 사용을 위해서
  /// [ModalBottomSheet] 가 나와있는지 저장할 변수
  final _isShowingSelectGrade = BehaviorSubject<bool>.seeded(false);

  /// 현재 선택중인 성적의 인덱스
  final _currentSelectingIndex = BehaviorSubject<int?>.seeded(null);

  /// 창 애니메이션 후에 빌드하기 위한 딜레이, 애니메이션이 끝났는가를 판별
  final _delay = BehaviorSubject<bool>();

  Stream<int> get currentTerm => _currentTerm.stream;
  Function(int) get updateCurrentTerm => _currentTerm.sink.add;
  int get currentCurrentTerm => _currentTerm.value;

  Stream<bool> get isShowingSelectGrade => _isShowingSelectGrade.stream;
  Function(bool) get updateIsShowingSelectGrade =>
      _isShowingSelectGrade.sink.add;

  Stream<int?> get currentSelectingIndex => _currentSelectingIndex.stream;
  Function(int?) get updateCurrentSelectingIndex =>
      _currentSelectingIndex.sink.add;

  Stream<bool> get delay => _delay.stream;
  Function(bool) get updateDelay => _delay.sink.add;

  dispose() {
    _currentTerm.close();

    _isShowingSelectGrade.close();
    _currentSelectingIndex.close();

    _delay.close();
  }
}
