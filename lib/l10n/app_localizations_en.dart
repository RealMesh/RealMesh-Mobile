// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RealMesh';

  @override
  String get scanForDevices => 'Scan for Devices';

  @override
  String get stopScan => 'Stop Scan';

  @override
  String get connecting => 'Connecting...';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get connectionFailed => 'Connection Failed';

  @override
  String get deviceName => 'Device Name';

  @override
  String get deviceAddress => 'Device Address';

  @override
  String get rssi => 'Signal Strength';

  @override
  String get connect => 'Connect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get settings => 'Settings';

  @override
  String get nodeSettings => 'Node Settings';

  @override
  String get nodeStatus => 'Node Status';

  @override
  String get nodeInformation => 'Node Information';

  @override
  String get networkStatistics => 'Network Statistics';

  @override
  String get messagesSent => 'Messages Sent';

  @override
  String get messagesReceived => 'Messages Received';

  @override
  String get messagesDropped => 'Messages Dropped';

  @override
  String get knownNodes => 'Known Nodes';

  @override
  String get uptime => 'Uptime';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get message => 'Message';

  @override
  String get targetAddress => 'Target Address';

  @override
  String get send => 'Send';

  @override
  String get bluetoothNotAvailable => 'Bluetooth not available';

  @override
  String get bluetoothNotEnabled => 'Bluetooth not enabled';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get noDevicesFound => 'No devices found';

  @override
  String get scanning => 'Scanning...';

  @override
  String get refresh => 'Refresh';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get serbian => 'Serbian';

  @override
  String get lookingForRealMeshDevices => 'Looking for RealMesh devices...';

  @override
  String get makeSureDeviceIsPowered =>
      'Make sure your RealMesh device is powered on and nearby';

  @override
  String get connectToViewStatus =>
      'Connect to a RealMesh node to view its status';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get aboutAppDescription =>
      'A Flutter app for connecting to and managing RealMesh nodes via Bluetooth.';

  @override
  String get aboutTechDescription =>
      'Built with Flutter and supports Serbian Cyrillic and English languages.';
}
