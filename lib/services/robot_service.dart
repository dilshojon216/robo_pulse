import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../models/robot_models.dart';

class RobotService extends ChangeNotifier {
  WebSocketChannel? _channel;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  Timer? _statusTimer;

  RobotConfig _config = const RobotConfig(
    robotIP: '192.168.100.208',
    cameraIP: '192.168.100.208',
    cameraPort: '8080',
    apiKey: 'robo-bridge-default-key-change-me',
  );

  RobotStatus _status = RobotStatus.initial();
  final List<LogEntry> _logs = [];

  int _currentSpeed = 150;
  bool _isMoving = false;
  // DateTime? _lastHeartbeat; // Removed unused field

  // Getters
  RobotConfig get config => _config;
  RobotStatus get status => _status;
  List<LogEntry> get logs => List.unmodifiable(_logs);
  int get currentSpeed => _currentSpeed;
  bool get isConnected => _status.wsStatus == ConnectionStatus.connected;
  bool get isMoving => _isMoving;

  // Update configuration
  void updateConfig(RobotConfig newConfig) {
    _config = newConfig;
    notifyListeners();
  }

  void updateSpeed(int speed) {
    _currentSpeed = speed.clamp(0, 255);
    notifyListeners();
  }

  // Connection management
  Future<void> connect() async {
    if (_status.wsStatus == ConnectionStatus.connecting) return;

    _updateStatus(_status.copyWith(wsStatus: ConnectionStatus.connecting));
    _addLog('Robot ga ulanmoqda...', LogLevel.info);

    // Always check camera first
    await _checkCameraStatus();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_config.wsUrl));

      // Listen to messages
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDisconnect,
      );

      // Wait for connection or timeout
      await Future.delayed(const Duration(seconds: 2));

      if (_channel != null) {
        _updateStatus(_status.copyWith(wsStatus: ConnectionStatus.connected));
        _addLog('WebSocket ulandi!', LogLevel.success);
        _startHeartbeat();
        _startStatusUpdates();
        await _checkHealth();
      }
    } catch (e) {
      _addLog('WebSocket ulanish xatosi: $e', LogLevel.error);
      _updateStatus(_status.copyWith(wsStatus: ConnectionStatus.error));

      // Even if WebSocket fails, camera might still work
      if (_status.cameraAvailable) {
        _addLog(
          'Kamera ishlayapti, lekin robot boshqaruv mavjud emas',
          LogLevel.warning,
        );
      }
    }

    // Start status updates even if WebSocket fails (for camera monitoring)
    if (_statusTimer == null) {
      _startStatusUpdates();
    }
  }

  Future<void> disconnect() async {
    _stopHeartbeat();
    _stopReconnectTimer();
    _stopStatusUpdates();

    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
    }

    _updateStatus(_status.copyWith(wsStatus: ConnectionStatus.disconnected));
    _addLog('Ulanish uzildi', LogLevel.info);
  }

  // Robot control commands
  DateTime? _lastMoveLog;
  RobotDirection? _lastDirection;

  void move(RobotDirection direction) {
    if (!isConnected || direction == RobotDirection.stop) return;

    _isMoving = true;
    final command = RobotCommand.move(direction, _currentSpeed);
    _sendCommand(command);

    // Only log if direction changed or 2 seconds passed
    final now = DateTime.now();
    if (_lastDirection != direction ||
        _lastMoveLog == null ||
        now.difference(_lastMoveLog!).inSeconds >= 2) {
      _addLog(
        'Harakat: ${direction.displayName} (${_currentSpeed})',
        LogLevel.info,
      );
      _lastMoveLog = now;
      _lastDirection = direction;
    }

    notifyListeners();
  }

  void stop() {
    _isMoving = false;
    final command = RobotCommand.stop();
    _sendCommand(command);
    _addLog('To\'xtatildi', LogLevel.info);
    notifyListeners();
  }

  void signal(SignalType type, {int value = 200, int duration = 1000}) {
    if (!isConnected) return;

    final command = RobotCommand.signal(type, value: value, duration: duration);
    _sendCommand(command);
    _addLog('Signal: ${type.displayName}', LogLevel.info);
  }

  // Private methods
  void _sendCommand(RobotCommand command) {
    if (_channel == null) return;

    try {
      final message = jsonEncode(command.toJson());
      _channel!.sink.add(message);
    } catch (e) {
      _addLog('Xabar yuborishda xato: $e', LogLevel.error);
    }
  }

  void _onMessage(dynamic message) {
    try {
      final data = jsonDecode(message);

      if (data['error'] != null) {
        _addLog('Xato: ${data['error']}', LogLevel.error);
      } else if (data['status'] == 'ok') {
        // Success response
      }

      _updateStatus(_status.copyWith(lastUpdate: DateTime.now()));
    } catch (e) {
      _addLog('Xabarni o\'qishda xato: $e', LogLevel.error);
    }
  }

  void _onError(dynamic error) {
    _addLog('WebSocket xato: $error', LogLevel.error);
    _updateStatus(_status.copyWith(wsStatus: ConnectionStatus.error));
    _attemptReconnect();
  }

  void _onDisconnect() {
    _addLog('WebSocket uzildi', LogLevel.warning);
    _updateStatus(_status.copyWith(wsStatus: ConnectionStatus.disconnected));
    _stopHeartbeat();
    _isMoving = false;
    notifyListeners();
    _attemptReconnect();
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(milliseconds: 1500), (
      timer,
    ) {
      if (isConnected && _isMoving) {
        _sendCommand(RobotCommand.heartbeat());
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _startStatusUpdates() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkCameraStatus();
    });
  }

  void _stopStatusUpdates() {
    _statusTimer?.cancel();
    _statusTimer = null;
  }

  void _attemptReconnect() {
    if (_reconnectTimer != null) return;

    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      _reconnectTimer = null;
      if (_status.wsStatus != ConnectionStatus.connected) {
        _addLog('Qayta ulanishga harakat...', LogLevel.info);
        connect();
      }
    });
  }

  void _stopReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  Future<void> _checkHealth() async {
    try {
      // Test camera availability and latency
      await _checkCameraStatus();

      // Try health endpoint if available
      final response = await http
          .get(
            Uri.parse('${_config.httpUrl}/health'),
            headers: {'X-API-Key': _config.apiKey},
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _updateStatus(
          _status.copyWith(usbConnected: data['usb_connected'] ?? false),
        );
        _addLog('Health check muvaffaqiyatli', LogLevel.success);
      }
    } catch (e) {
      _addLog('Health check xatosi: $e', LogLevel.warning);
      // Still check camera even if health endpoint fails
      await _checkCameraStatus();
    }
  }

  // Check camera status and measure latency (lightweight check)
  Future<void> _checkCameraStatus() async {
    try {
      final stopwatch = Stopwatch()..start();

      // Use a simple TCP socket check instead of HTTP request to avoid interfering with stream
      final socket = await Socket.connect(
        _config.cameraIP,
        int.parse(_config.cameraPort),
      ).timeout(const Duration(seconds: 2));

      await socket.close();
      stopwatch.stop();

      // Camera server is responding
      _updateStatus(
        _status.copyWith(
          cameraAvailable: true,
          latency: stopwatch.elapsedMilliseconds,
        ),
      );

      // Only log every 30 seconds to avoid spam
      if (DateTime.now().second % 30 == 0) {
        _addLog(
          'Kamera mavjud - ${stopwatch.elapsedMilliseconds}ms',
          LogLevel.success,
        );
      }
    } catch (e) {
      _updateStatus(_status.copyWith(cameraAvailable: false, latency: 0));

      // Only log errors every 30 seconds to avoid spam
      if (DateTime.now().second % 30 == 0) {
        _addLog('Kamera mavjud emas: $e', LogLevel.warning);
      }
    }
  }

  void _updateStatus(RobotStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void _addLog(String message, LogLevel level) {
    _logs.insert(
      0,
      LogEntry(timestamp: DateTime.now(), message: message, level: level),
    );

    // Keep only last 50 entries
    if (_logs.length > 50) {
      _logs.removeRange(50, _logs.length);
    }

    notifyListeners();
  }

  // Camera methods
  String get cameraStreamUrl => _config.cameraStreamUrl;

  @override
  void dispose() {
    disconnect();
    _stopStatusUpdates();
    super.dispose();
  }
}
