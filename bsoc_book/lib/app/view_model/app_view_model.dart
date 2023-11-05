import 'package:rxdart/rxdart.dart';

class AppViewModel {
  bool isLoading = true;

  bool _isShowAppBar = true;

  bool get isShowAppBar => _isShowAppBar;

//AppBar stream
  final BehaviorSubject<bool> _showAppBarSubject = BehaviorSubject<bool>();

  Stream<bool> get isShowAppBarStream => _showAppBarSubject.stream;

  void setShowAppBar({required bool isShowAppBar}) {
    if (_isShowAppBar != isShowAppBar) {
      _isShowAppBar = isShowAppBar;
      _showAppBarSubject.add(isShowAppBar);
    }
  }

  void dispose() {
    _showAppBarSubject.close();
  }
}
