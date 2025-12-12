// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CERISE';

  @override
  String get welcome => 'Welcome';

  @override
  String get connect => 'Connect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get connectionStatus => 'Connection Status';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get chat => 'Chat';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get send => 'Send';

  @override
  String get statusDisconnected => 'DISCONNECTED';

  @override
  String get geminiApiKeyTitle => 'Gemini API Key';

  @override
  String get enterKeyHint => 'Enter your key here';

  @override
  String get confirm => 'Confirm';

  @override
  String get apiKeyNeededStatus => 'API KEY NEEDED';

  @override
  String get scanning => 'SCANNING...';

  @override
  String get noDevices => 'NO DEVICES';

  @override
  String get devicesFound => 'DEVICES FOUND';

  @override
  String get connecting => 'CONNECTING...';

  @override
  String get connectionFailed => 'CONNECTION FAILED';

  @override
  String get connectionEstablished => 'CONNECTION ESTABLISHED';

  @override
  String get systemStatus => 'SYSTEM STATUS';

  @override
  String get unknownDevice => 'UNKNOWN DEVICE';

  @override
  String get unknownManufacturer => 'UNKNOWN MANUFACTURER';

  @override
  String get configureApiKey => 'Configure API Key';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get availableDevices => 'AVAILABLE DEVICES';

  @override
  String get apiKeyNeededMessage =>
      'Gemini API key is required.\nRestart the app to enter it.';

  @override
  String get noDevicesFoundTitle => 'NO DEVICES FOUND';

  @override
  String get connectDevicePrompt =>
      'Connect a USB device and tap the scan button';

  @override
  String get processing => 'Processing...';

  @override
  String get noEspContext => 'No ESP32 context available';

  @override
  String recentContext(Object context, Object question) {
    return 'Recent ESP32 chat context:\n$context\n\nUser question: $question';
  }

  @override
  String userQuestion(Object question) {
    return 'User question: $question';
  }

  @override
  String get normalResponse => 'Normal Response';

  @override
  String get shortResponse => 'Short Response';

  @override
  String get commandOnly => 'Command Only';

  @override
  String connectionError(Object error) {
    return 'CONNECTION ERROR: $error';
  }

  @override
  String get mockResponse => 'ESP32 mock response.';

  @override
  String sendFailure(Object error) {
    return 'SEND FAILURE: $error';
  }

  @override
  String get typeCommand => 'Type a command...';

  @override
  String get aiDisabled => 'AI Assistant disabled (no API key)';

  @override
  String get openAiAssistant => 'Open AI Assistant';

  @override
  String get aboutApp => 'About App';

  @override
  String errorPrefix(Object error) {
    return 'ERROR: $error';
  }

  @override
  String get aiSystemPrompt =>
      'You are an intelligent assistant specialized in pentesting using the ESP32 Marauder firmware. Your goal is to assist the user in operating the Marauder by suggesting appropriate commands and explaining their functions, always considering the context of the pentest being performed at the moment.\n\nIMPORTANT: Keep your answers CONCISE and DIRECT. Maximum of 3-4 sentences per answer, focusing on the essentials.';

  @override
  String geminiApiError(Object message) {
    return 'Gemini API Error: $message';
  }

  @override
  String get connectionErrorCheckInternet =>
      'Connection error: Check your internet connection and try again.';

  @override
  String get geminiApiKeyInvalid => 'Error: Gemini API key invalid or expired.';

  @override
  String unexpectedError(Object message) {
    return 'Unexpected error: $message';
  }
}
