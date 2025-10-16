import 'package:flutter/material.dart';

class RobotConfig {
  final String robotIP;
  final String cameraIP;
  final String cameraPort;
  final String apiKey;
  final int wsPort;
  final int httpPort;

  const RobotConfig({
    required this.robotIP,
    required this.cameraIP,
    required this.cameraPort,
    required this.apiKey,
    this.wsPort = 5050,
    this.httpPort = 5050,
  });

  RobotConfig copyWith({
    String? robotIP,
    String? cameraIP,
    String? cameraPort,
    String? apiKey,
    int? wsPort,
    int? httpPort,
  }) {
    return RobotConfig(
      robotIP: robotIP ?? this.robotIP,
      cameraIP: cameraIP ?? this.cameraIP,
      cameraPort: cameraPort ?? this.cameraPort,
      apiKey: apiKey ?? this.apiKey,
      wsPort: wsPort ?? this.wsPort,
      httpPort: httpPort ?? this.httpPort,
    );
  }

  String get wsUrl => 'ws://$robotIP:$wsPort/control/ws?api_key=$apiKey';
  String get httpUrl => 'http://$robotIP:$httpPort';
  String get cameraUrl => 'http://$cameraIP:$cameraPort';
  String get cameraStreamUrl => '$cameraUrl/shot.jpg';

  Map<String, dynamic> toJson() {
    return {
      'robotIP': robotIP,
      'cameraIP': cameraIP,
      'cameraPort': cameraPort,
      'apiKey': apiKey,
      'wsPort': wsPort,
      'httpPort': httpPort,
    };
  }

  factory RobotConfig.fromJson(Map<String, dynamic> json) {
    return RobotConfig(
      robotIP: json['robotIP'] ?? '',
      cameraIP: json['cameraIP'] ?? '',
      cameraPort: json['cameraPort'] ?? '8080',
      apiKey: json['apiKey'] ?? '',
      wsPort: json['wsPort'] ?? 5050,
      httpPort: json['httpPort'] ?? 5050,
    );
  }
}

enum ConnectionStatus { disconnected, connecting, connected, error }

enum RobotDirection {
  forward(1),
  backward(2),
  left(3),
  right(4),
  stop(0);

  const RobotDirection(this.value);
  final int value;

  String get displayName {
    switch (this) {
      case RobotDirection.forward:
        return 'Oldinga';
      case RobotDirection.backward:
        return 'Orqaga';
      case RobotDirection.left:
        return 'Chapga';
      case RobotDirection.right:
        return 'O\'ngga';
      case RobotDirection.stop:
        return 'To\'xtatish';
    }
  }

  IconData get icon {
    switch (this) {
      case RobotDirection.forward:
        return Icons.keyboard_arrow_up;
      case RobotDirection.backward:
        return Icons.keyboard_arrow_down;
      case RobotDirection.left:
        return Icons.keyboard_arrow_left;
      case RobotDirection.right:
        return Icons.keyboard_arrow_right;
      case RobotDirection.stop:
        return Icons.stop;
    }
  }
}

enum SignalType {
  beep(1),
  light(2);

  const SignalType(this.value);
  final int value;

  String get displayName {
    switch (this) {
      case SignalType.beep:
        return 'Ovozli signal';
      case SignalType.light:
        return 'Chiroq';
    }
  }
}

class RobotStatus {
  final ConnectionStatus wsStatus;
  final bool usbConnected;
  final bool cameraAvailable;
  final int latency;
  final DateTime lastUpdate;

  const RobotStatus({
    required this.wsStatus,
    required this.usbConnected,
    required this.cameraAvailable,
    required this.latency,
    required this.lastUpdate,
  });

  RobotStatus copyWith({
    ConnectionStatus? wsStatus,
    bool? usbConnected,
    bool? cameraAvailable,
    int? latency,
    DateTime? lastUpdate,
  }) {
    return RobotStatus(
      wsStatus: wsStatus ?? this.wsStatus,
      usbConnected: usbConnected ?? this.usbConnected,
      cameraAvailable: cameraAvailable ?? this.cameraAvailable,
      latency: latency ?? this.latency,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  factory RobotStatus.initial() {
    return RobotStatus(
      wsStatus: ConnectionStatus.disconnected,
      usbConnected: false,
      cameraAvailable: false,
      latency: 0,
      lastUpdate: DateTime.now(),
    );
  }
}

class RobotCommand {
  final String action;
  final Map<String, dynamic> data;

  const RobotCommand({required this.action, required this.data});

  factory RobotCommand.move(RobotDirection direction, int speed) {
    return RobotCommand(
      action: 'move',
      data: {'dir': direction.value, 'speed': speed},
    );
  }

  factory RobotCommand.stop({int mode = 0}) {
    return RobotCommand(action: 'stop', data: {'mode': mode});
  }

  factory RobotCommand.signal(
    SignalType type, {
    int value = 200,
    int duration = 1000,
  }) {
    return RobotCommand(
      action: 'signal',
      data: {'type': type.value, 'value': value, 'duration': duration},
    );
  }

  factory RobotCommand.heartbeat() {
    return const RobotCommand(action: 'heartbeat', data: {});
  }

  Map<String, dynamic> toJson() {
    return {'action': action, ...data};
  }
}

class LogEntry {
  final DateTime timestamp;
  final String message;
  final LogLevel level;

  const LogEntry({
    required this.timestamp,
    required this.message,
    required this.level,
  });

  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}

enum LogLevel {
  info,
  success,
  warning,
  error;

  Color get color {
    switch (this) {
      case LogLevel.info:
        return Colors.blue;
      case LogLevel.success:
        return Colors.green;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
    }
  }
}
