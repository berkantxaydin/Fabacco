import 'dart:async';

enum LogLevel { info, warning, error }

class LogEvent {
  final DateTime timestamp;
  final String message;
  final LogLevel level;

  LogEvent({required this.message, required this.level})
    : timestamp = DateTime.now();
}

class LoggerService {
  // Broadcast stream allows multiple listeners (e.g., UI, Analytics, File writers)
  final _controller = StreamController<LogEvent>.broadcast();

  // Keep history for the bottom sheet when it opens
  final List<LogEvent> _history = [];

  Stream<LogEvent> get logStream => _controller.stream;
  List<LogEvent> get history => List.unmodifiable(_history);

  void log(String message, {LogLevel level = LogLevel.info}) {
    final event = LogEvent(message: message, level: level);
    _history.insert(0, event); // Insert at top for reverse scrolling
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
