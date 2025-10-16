import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/robot_models.dart';

class StatusBar extends StatelessWidget {
  final RobotStatus status;

  const StatusBar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSizes.borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatusItem(
            label: 'WebSocket',
            value: _getConnectionStatusText(status.wsStatus),
            color: _getConnectionStatusColor(status.wsStatus),
            icon: _getConnectionStatusIcon(status.wsStatus),
          ),

          _StatusItem(
            label: 'USB',
            value: status.usbConnected ? 'Ulandi' : 'Uzilgan',
            color: status.usbConnected
                ? AppColors.primaryBlue
                : AppColors.signalRed,
            icon: status.usbConnected ? Icons.usb : Icons.usb_off,
          ),

          _StatusItem(
            label: 'Kamera',
            value: status.cameraAvailable ? 'Mavjud' : 'Yo\'q',
            color: status.cameraAvailable
                ? AppColors.primaryBlue
                : AppColors.signalRed,
            icon: status.cameraAvailable ? Icons.videocam : Icons.videocam_off,
          ),

          _StatusItem(
            label: 'Latency',
            value: '${status.latency} ms',
            color: _getLatencyColor(status.latency),
            icon: Icons.speed,
          ),
        ],
      ),
    );
  }

  String _getConnectionStatusText(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return 'Ulandi';
      case ConnectionStatus.connecting:
        return 'Ulanmoqda...';
      case ConnectionStatus.error:
        return 'Xato';
      case ConnectionStatus.disconnected:
        return 'Uzilgan';
    }
  }

  Color _getConnectionStatusColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return AppColors.primaryBlue;
      case ConnectionStatus.connecting:
        return Colors.orange;
      case ConnectionStatus.error:
        return AppColors.signalRed;
      case ConnectionStatus.disconnected:
        return AppColors.darkGray;
    }
  }

  IconData _getConnectionStatusIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return Icons.wifi;
      case ConnectionStatus.connecting:
        return Icons.wifi_find;
      case ConnectionStatus.error:
        return Icons.wifi_off;
      case ConnectionStatus.disconnected:
        return Icons.wifi_off;
    }
  }

  Color _getLatencyColor(int latency) {
    if (latency == 0) return AppColors.darkGray;
    if (latency < 50) return AppColors.primaryBlue;
    if (latency < 100) return Colors.orange;
    return AppColors.signalRed;
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatusItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconMedium, color: color),

          const SizedBox(height: 4),

          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.darkGray),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
