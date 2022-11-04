import 'package:rxdart/subjects.dart';

class CustomAppBarWithTextFieldBloc {
  final _visibleSuffix = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get visibleSuffix => _visibleSuffix.stream;
  Function(bool) get updateVisibleSuffix => _visibleSuffix.sink.add;

  dispose() {
    _visibleSuffix.close();
  }
}
