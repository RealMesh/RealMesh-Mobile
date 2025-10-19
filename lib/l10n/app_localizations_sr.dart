// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'RealMesh';

  @override
  String get scanForDevices => 'Скенирај Уређаје';

  @override
  String get stopScan => 'Заустави Скен';

  @override
  String get connecting => 'Повезивање...';

  @override
  String get connected => 'Повезан';

  @override
  String get disconnected => 'Дисконектован';

  @override
  String get connectionFailed => 'Повезивање Неуспешно';

  @override
  String get deviceName => 'Име Уређаја';

  @override
  String get deviceAddress => 'Адреса Уређаја';

  @override
  String get rssi => 'Јачина Сигнала';

  @override
  String get connect => 'Повежи се';

  @override
  String get disconnect => 'Дисконектуј се';

  @override
  String get settings => 'Подешавања';

  @override
  String get nodeSettings => 'Подешавања Чвора';

  @override
  String get nodeStatus => 'Статус Чвора';

  @override
  String get nodeInformation => 'Информације о Чвору';

  @override
  String get networkStatistics => 'Мрежне Статистике';

  @override
  String get messagesSent => 'Послате Поруке';

  @override
  String get messagesReceived => 'Примљене Поруке';

  @override
  String get messagesDropped => 'Изгубљене Поруке';

  @override
  String get knownNodes => 'Познати Чворови';

  @override
  String get uptime => 'Време Рада';

  @override
  String get sendMessage => 'Пошаљи Поруку';

  @override
  String get message => 'Порука';

  @override
  String get targetAddress => 'Циљна Адреса';

  @override
  String get send => 'Пошаљи';

  @override
  String get bluetoothNotAvailable => 'Блутут није доступан';

  @override
  String get bluetoothNotEnabled => 'Блутут није укључен';

  @override
  String get permissionDenied => 'Дозвола одбачена';

  @override
  String get noDevicesFound => 'Нема пронађених уређаја';

  @override
  String get scanning => 'Скенирање...';

  @override
  String get refresh => 'Освежи';

  @override
  String get cancel => 'Откажи';

  @override
  String get ok => 'У реду';

  @override
  String get error => 'Грешка';

  @override
  String get success => 'Успех';

  @override
  String get language => 'Језик';

  @override
  String get english => 'Енглески';

  @override
  String get serbian => 'Српски';

  @override
  String get lookingForRealMeshDevices => 'Тражим RealMesh уређаје...';

  @override
  String get makeSureDeviceIsPowered =>
      'Уверите се да је ваш RealMesh уређај укључен и у близини';

  @override
  String get connectToViewStatus =>
      'Повежите се са RealMesh чвором да бисте видели његов статус';

  @override
  String get about => 'О апликацији';

  @override
  String get version => 'Верзија';

  @override
  String get aboutAppDescription =>
      'Flutter апликација за повезивање и управљање RealMesh чворовима преко Bluetooth-а.';

  @override
  String get aboutTechDescription =>
      'Направљена са Flutter-ом и подржава српски ћирилица и енглески језик.';
}
