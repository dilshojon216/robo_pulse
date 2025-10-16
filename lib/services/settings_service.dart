import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/robot_models.dart';

class SettingsService extends ChangeNotifier {
  static const String _configKey = 'robot_config';
  static const String _speedKey = 'robot_speed';

  SharedPreferences? _prefs;

  RobotConfig _config = const RobotConfig(
    robotIP: '192.168.100.23',
    cameraIP: '192.168.100.23',
    cameraPort: '8080',
    apiKey: 'robo-bridge-default-key-change-me',
  );

  int _speed = 150;

  // Getters
  RobotConfig get config => _config;
  int get speed => _speed;

  // Initialize
  Future<void> initialize() async {
    try {
      debugPrint('SettingsService initialize boshlanadi...');
      _prefs = await SharedPreferences.getInstance();
      debugPrint('SharedPreferences muvaffaqiyatli olindi');
      await _loadSettings();
      debugPrint('SettingsService initialize tugadi');
    } catch (e) {
      debugPrint('SettingsService initialize qilishda xato: $e');
      rethrow;
    }
  }

  // Load settings from storage
  Future<void> _loadSettings() async {
    try {
      if (_prefs == null) {
        debugPrint('SharedPreferences initialize qilinmagan!');
        return;
      }

      // Load config
      final configJson = _prefs!.getString(_configKey);
      debugPrint('Yuklangan config JSON: $configJson');

      if (configJson != null && configJson.isNotEmpty) {
        try {
          final configMap = jsonDecode(configJson) as Map<String, dynamic>;
          _config = RobotConfig.fromJson(configMap);
          debugPrint('Config muvaffaqiyatli yuklandi: ${_config.robotIP}');
        } catch (e) {
          debugPrint('Config parse qilishda xato: $e');
        }
      } else {
        debugPrint(
          'Saqlangan config topilmadi, standart qiymatlar ishlatiladi',
        );
      }

      // Load speed
      _speed = _prefs!.getInt(_speedKey) ?? 150;
      debugPrint('Yuklangan speed: $_speed');

      notifyListeners();
    } catch (e) {
      debugPrint('Settings yüklashda xato: $e');
    }
  }

  // Save config
  Future<void> saveConfig(RobotConfig config) async {
    _config = config;

    try {
      if (_prefs == null) {
        debugPrint('SharedPreferences initialize qilinmagan!');
        return;
      }

      final jsonString = jsonEncode(config.toJson());
      final success = await _prefs!.setString(_configKey, jsonString);

      debugPrint('Config saqlash: ${success ? "Muvaffaqiyatli" : "Xato"}');
      debugPrint('Saqlangan config: $jsonString');

      notifyListeners();
    } catch (e) {
      debugPrint('Config saqlashda xato: $e');
      rethrow;
    }
  }

  // Save speed
  Future<void> saveSpeed(int speed) async {
    _speed = speed.clamp(0, 255);

    try {
      await _prefs?.setInt(_speedKey, _speed);
      notifyListeners();
    } catch (e) {
      debugPrint('Speed saqlashda xato: $e');
    }
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    _config = const RobotConfig(
      robotIP: '192.168.100.23',
      cameraIP: '192.168.100.23',
      cameraPort: '8080',
      apiKey: 'robo-bridge-default-key-change-me',
    );
    _speed = 150;

    try {
      await _prefs?.remove(_configKey);
      await _prefs?.remove(_speedKey);
      notifyListeners();
    } catch (e) {
      debugPrint('Reset qilishda xato: $e');
    }
  }

  // Validate config
  bool isConfigValid(RobotConfig config) {
    return config.robotIP.isNotEmpty &&
        config.cameraIP.isNotEmpty &&
        config.cameraPort.isNotEmpty &&
        config.apiKey.isNotEmpty;
  }

  // Get default configs for quick setup
  static List<RobotConfig> getPresetConfigs() {
    return [
      const RobotConfig(
        robotIP: '192.168.1.100',
        cameraIP: '192.168.1.100',
        cameraPort: '8080',
        apiKey: 'robo-bridge-default-key-change-me',
      ),
      const RobotConfig(
        robotIP: '192.168.100.23',
        cameraIP: '192.168.100.23',
        cameraPort: '8080',
        apiKey: 'robo-bridge-default-key-change-me',
      ),
      const RobotConfig(
        robotIP: '10.0.0.100',
        cameraIP: '10.0.0.100',
        cameraPort: '8080',
        apiKey: 'robo-bridge-default-key-change-me',
      ),
    ];
  }
}
