import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

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
    Locale('sr'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'RealMesh'**
  String get appTitle;

  /// Button text for scanning Bluetooth devices
  ///
  /// In en, this message translates to:
  /// **'Scan for Devices'**
  String get scanForDevices;

  /// Button text for stopping Bluetooth scan
  ///
  /// In en, this message translates to:
  /// **'Stop Scan'**
  String get stopScan;

  /// Status text when connecting to device
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// Status text when connected to device
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Status text when disconnected from device
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// Status text when connection fails
  ///
  /// In en, this message translates to:
  /// **'Connection Failed'**
  String get connectionFailed;

  /// Label for device name
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// Label for device address
  ///
  /// In en, this message translates to:
  /// **'Device Address'**
  String get deviceAddress;

  /// Label for signal strength
  ///
  /// In en, this message translates to:
  /// **'Signal Strength'**
  String get rssi;

  /// Button text for connecting to device
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Button text for disconnecting from device
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Node settings screen title
  ///
  /// In en, this message translates to:
  /// **'Node Settings'**
  String get nodeSettings;

  /// Node status section title
  ///
  /// In en, this message translates to:
  /// **'Node Status'**
  String get nodeStatus;

  /// Node information section title
  ///
  /// In en, this message translates to:
  /// **'Node Information'**
  String get nodeInformation;

  /// Network statistics section title
  ///
  /// In en, this message translates to:
  /// **'Network Statistics'**
  String get networkStatistics;

  /// Label for messages sent count
  ///
  /// In en, this message translates to:
  /// **'Messages Sent'**
  String get messagesSent;

  /// Label for messages received count
  ///
  /// In en, this message translates to:
  /// **'Messages Received'**
  String get messagesReceived;

  /// Label for messages dropped count
  ///
  /// In en, this message translates to:
  /// **'Messages Dropped'**
  String get messagesDropped;

  /// Label for known nodes count
  ///
  /// In en, this message translates to:
  /// **'Known Nodes'**
  String get knownNodes;

  /// Label for node uptime
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get uptime;

  /// Button text for sending message
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// Label for message input
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// Label for target address input
  ///
  /// In en, this message translates to:
  /// **'Target Address'**
  String get targetAddress;

  /// Generic send button text
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Error message when Bluetooth is not available
  ///
  /// In en, this message translates to:
  /// **'Bluetooth not available'**
  String get bluetoothNotAvailable;

  /// Error message when Bluetooth is not enabled
  ///
  /// In en, this message translates to:
  /// **'Bluetooth not enabled'**
  String get bluetoothNotEnabled;

  /// Error message when permission is denied
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// Message when no devices are found during scan
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevicesFound;

  /// Status text when scanning for devices
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// Button text for refreshing
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Generic cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Generic OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Generic success title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Serbian language option
  ///
  /// In en, this message translates to:
  /// **'Serbian'**
  String get serbian;

  /// Status text when scanning for devices
  ///
  /// In en, this message translates to:
  /// **'Looking for RealMesh devices...'**
  String get lookingForRealMeshDevices;

  /// Help text when no devices are found
  ///
  /// In en, this message translates to:
  /// **'Make sure your RealMesh device is powered on and nearby'**
  String get makeSureDeviceIsPowered;

  /// Text shown when not connected to any node
  ///
  /// In en, this message translates to:
  /// **'Connect to a RealMesh node to view its status'**
  String get connectToViewStatus;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Main app description
  ///
  /// In en, this message translates to:
  /// **'A Flutter app for connecting to and managing RealMesh nodes via Bluetooth.'**
  String get aboutAppDescription;

  /// Technical description
  ///
  /// In en, this message translates to:
  /// **'Built with Flutter and supports Serbian Cyrillic and English languages.'**
  String get aboutTechDescription;
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
      <String>['en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
