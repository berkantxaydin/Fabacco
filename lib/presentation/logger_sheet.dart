import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../application/providers.dart';
import '../core/logger_service.dart';

class LoggerBottomSheet extends ConsumerWidget {
  const LoggerBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.watch(loggerProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Live Developer Logs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: StreamBuilder<LogEvent>(
              stream: logger.logStream,
              builder: (context, snapshot) {
                final logs = logger.history;

                if (logs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No logs yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  reverse:
                      true, // Auto-scrolls to the newest item at the bottom (index 0)
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return _buildLogItem(log);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(LogEvent log) {
    Color textColor;
    switch (log.level) {
      case LogLevel.error:
        textColor = Colors.redAccent;
        break;
      case LogLevel.warning:
        textColor = Colors.orangeAccent;
        break;
      case LogLevel.info:
        textColor = Colors.greenAccent;
    }

    final timeString = DateFormat('HH:mm:ss.SSS').format(log.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          children: [
            TextSpan(
              text: '[$timeString] ',
              style: const TextStyle(color: Colors.grey),
            ),
            TextSpan(
              text: log.message,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
