import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'CERISE'**
  String get appTitle;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Connect button text
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Disconnect button text
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Label for connection status
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// Status when connected
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Status when disconnected
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// Chat screen title
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Placeholder text for message input
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// Send button text
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @statusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'DISCONNECTED'**
  String get statusDisconnected;

  /// No description provided for @geminiApiKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Gemini API Key'**
  String get geminiApiKeyTitle;

  /// No description provided for @enterKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your key here'**
  String get enterKeyHint;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @apiKeyNeededStatus.
  ///
  /// In en, this message translates to:
  /// **'API KEY NEEDED'**
  String get apiKeyNeededStatus;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'SCANNING...'**
  String get scanning;

  /// No description provided for @noDevices.
  ///
  /// In en, this message translates to:
  /// **'NO DEVICES'**
  String get noDevices;

  /// No description provided for @devicesFound.
  ///
  /// In en, this message translates to:
  /// **'DEVICES FOUND'**
  String get devicesFound;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'CONNECTING...'**
  String get connecting;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'CONNECTION FAILED'**
  String get connectionFailed;

  /// No description provided for @connectionEstablished.
  ///
  /// In en, this message translates to:
  /// **'CONNECTION ESTABLISHED'**
  String get connectionEstablished;

  /// No description provided for @systemStatus.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM STATUS'**
  String get systemStatus;

  /// No description provided for @unknownDevice.
  ///
  /// In en, this message translates to:
  /// **'UNKNOWN DEVICE'**
  String get unknownDevice;

  /// No description provided for @unknownManufacturer.
  ///
  /// In en, this message translates to:
  /// **'UNKNOWN MANUFACTURER'**
  String get unknownManufacturer;

  /// No description provided for @configureApiKey.
  ///
  /// In en, this message translates to:
  /// **'Configure API Key'**
  String get configureApiKey;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @availableDevices.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE DEVICES'**
  String get availableDevices;

  /// No description provided for @apiKeyNeededMessage.
  ///
  /// In en, this message translates to:
  /// **'Gemini API key is required.\nRestart the app to enter it.'**
  String get apiKeyNeededMessage;

  /// No description provided for @noDevicesFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'NO DEVICES FOUND'**
  String get noDevicesFoundTitle;

  /// No description provided for @connectDevicePrompt.
  ///
  /// In en, this message translates to:
  /// **'Connect a USB device and tap the scan button'**
  String get connectDevicePrompt;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @noEspContext.
  ///
  /// In en, this message translates to:
  /// **'No ESP32 context available'**
  String get noEspContext;

  /// No description provided for @recentContext.
  ///
  /// In en, this message translates to:
  /// **'Recent ESP32 chat context:\n{context}\n\nUser question: {question}'**
  String recentContext(Object context, Object question);

  /// No description provided for @userQuestion.
  ///
  /// In en, this message translates to:
  /// **'User question: {question}'**
  String userQuestion(Object question);

  /// No description provided for @normalResponse.
  ///
  /// In en, this message translates to:
  /// **'Normal Response'**
  String get normalResponse;

  /// No description provided for @shortResponse.
  ///
  /// In en, this message translates to:
  /// **'Short Response'**
  String get shortResponse;

  /// No description provided for @commandOnly.
  ///
  /// In en, this message translates to:
  /// **'Command Only'**
  String get commandOnly;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'CONNECTION ERROR: {error}'**
  String connectionError(Object error);

  /// No description provided for @mockResponse.
  ///
  /// In en, this message translates to:
  /// **'ESP32 mock response.'**
  String get mockResponse;

  /// No description provided for @sendFailure.
  ///
  /// In en, this message translates to:
  /// **'SEND FAILURE: {error}'**
  String sendFailure(Object error);

  /// No description provided for @typeCommand.
  ///
  /// In en, this message translates to:
  /// **'Type a command...'**
  String get typeCommand;

  /// No description provided for @aiDisabled.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant disabled (no API key)'**
  String get aiDisabled;

  /// No description provided for @openAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'Open AI Assistant'**
  String get openAiAssistant;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'ERROR: {error}'**
  String errorPrefix(Object error);

  /// No description provided for @aiSystemPrompt.
  ///
  /// In en, this message translates to:
  /// **'You are an intelligent assistant specialized in pentesting using the ESP32 Marauder firmware. Your goal is to assist the user in operating the Marauder by suggesting appropriate commands and explaining their functions, always considering the context of the pentest being performed at the moment.\n\nIMPORTANT: Keep your answers CONCISE and DIRECT. Maximum of 3-4 sentences per answer, focusing on the essentials.'**
  String get aiSystemPrompt;

  /// No description provided for @geminiApiError.
  ///
  /// In en, this message translates to:
  /// **'Gemini API Error: {message}'**
  String geminiApiError(Object message);

  /// No description provided for @connectionErrorCheckInternet.
  ///
  /// In en, this message translates to:
  /// **'Connection error: Check your internet connection and try again.'**
  String get connectionErrorCheckInternet;

  /// No description provided for @geminiApiKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'Error: Gemini API key invalid or expired.'**
  String get geminiApiKeyInvalid;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error: {message}'**
  String unexpectedError(Object message);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
