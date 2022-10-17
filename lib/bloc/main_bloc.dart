import 'package:rxdart/subjects.dart';

class MainBloc {
  final _page = BehaviorSubject<int>.seeded(0);

  Stream<int> get page => _page.stream;
  Function(int) get updatePage => _page.sink.add;

  onTapNavIcon(index) {
    updatePage(index);
  }

  dispose() {
    _page.close();
  }
}
