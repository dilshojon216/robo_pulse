import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/robot_models.dart';

class LogsPanel extends StatelessWidget {
  final List<LogEntry> logs;
  final int maxEntries;

  const LogsPanel({super.key, required this.logs, this.maxEntries = 20});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.list_alt,
                  color: AppColors.primaryBlue,
                  size: AppSizes.iconMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  'Log Ma\'lumotlari',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),

                // Clear logs button
                IconButton(
                  onPressed: logs.isNotEmpty ? _showClearConfirmation : null,
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Loglarni tozalash',
                ),
              ],
            ),

            const SizedBox(height: AppSizes.paddingSmall),

            // Logs container
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                border: Border.all(color: AppColors.lightGray),
              ),
              child: logs.isEmpty
                  ? _buildEmptyState(context)
                  : _buildLogsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Hozircha log mavjud emas',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList() {
    final displayLogs = logs.take(maxEntries).toList();

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: displayLogs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final log = displayLogs[index];
        return _LogEntryTile(log: log);
      },
    );
  }

  void _showClearConfirmation() {
    // This would need to be handled by parent widget
    // For now, just a placeholder
  }
}

class _LogEntryTile extends StatelessWidget {
  final LogEntry log;

  const _LogEntryTile({required this.log});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timestamp
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: log.level.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              log.formattedTime,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontSize: 10,
                color: log.level.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Level indicator
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: log.level.color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 8),

          // Message
          Expanded(
            child: Text(
              log.message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontSize: 12,
                color: AppColors.darkGray,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Full screen logs view
class FullScreenLogsView extends StatelessWidget {
  final List<LogEntry> logs;

  const FullScreenLogsView({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcha Loglar'),
        actions: [
          IconButton(
            onPressed: () {
              // Share logs functionality
              _shareLogs(context);
            },
            icon: const Icon(Icons.share),
            tooltip: 'Loglarni ulashish',
          ),
        ],
      ),
      body: logs.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Hozircha log mavjud emas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final log = logs[index];
                return _DetailedLogEntryTile(log: log);
              },
            ),
    );
  }

  void _shareLogs(BuildContext context) {
    // Here you would implement actual sharing
    // For now, just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Log ulashish funksiyasi')));
  }
}

class _DetailedLogEntryTile extends StatelessWidget {
  final LogEntry log;

  const _DetailedLogEntryTile({required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: log.level.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.level.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  log.formattedTime,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Colors.grey[600],
                  ),
                ),

                const Spacer(),

                Text(
                  '${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Message
            Text(
              log.message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
            ),
          ],
        ),
      ),
    );
  }
}
