import 'package:rxdart/subjects.dart';

class TabBarBloc {
  final BehaviorSubject<int> _currentIndex = BehaviorSubject<int>.seeded(0);

  Stream<int> get getCurrentIndex => _currentIndex.stream;
  Function(int) get updateCurrentIndex => _currentIndex.sink.add;

  dispose() {
    _currentIndex.close();
  }
}
