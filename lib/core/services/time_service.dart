class TimeService {
  DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;

  void advanceByDays(int days) {
    _currentTime = _currentTime.add(Duration(days: days));
  }

  void advanceYear() => advanceByDays(365);
  void advanceMonth() => advanceByDays(30);
}
