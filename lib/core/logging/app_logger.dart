class AppLogger {
  const AppLogger();

  void info(String message) {
    // Demo logger. Production would ship to a sink without PII.
    assert(() {
      // ignore: avoid_print
      print('[FinoraX] $message');
      return true;
    }());
  }
}
