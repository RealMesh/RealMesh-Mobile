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
      'Направљена са Flutter-ом и подржава српску ћирилицу и енглески језик.';

  @override
  String get kosovoJeSrbija => 'Косово је Србија! 🇷🇸';

  @override
  String get messages => 'Поруке';

  @override
  String get home => 'Почетна';

  @override
  String get readyToScan => 'Спреман за скенирање';

  @override
  String get lookingForRealMeshNodes => 'Тражим RealMesh чворове';

  @override
  String get tapScanToFindNodes => 'Тапни скенирај да пронађеш чворове';

  @override
  String get scan => 'Скенирај';

  @override
  String get searchingForDevices => 'Претражујем уређаје...';

  @override
  String get makeSureNodeIsPowered =>
      'Провери да ли је твој RealMesh чвор укључен';

  @override
  String get signal => 'Сигнал';

  @override
  String connectedTo(String name) {
    return 'Повезан са $name';
  }

  @override
  String get nodeIdentity => 'Идентитет Чвора';

  @override
  String get domain => 'Домен';

  @override
  String get type => 'Тип';

  @override
  String get stationary => 'Стационаран';

  @override
  String get mobile => 'Мобилан';

  @override
  String get network => 'Мрежа';

  @override
  String get battery => 'Батерија';

  @override
  String get radio => 'Радио';

  @override
  String get frequency => 'Фреквенција';

  @override
  String get bandwidth => 'Пропусност';

  @override
  String get spreadingFactor => 'Фактор Ширења';

  @override
  String get txPower => 'TX Снага';

  @override
  String get sent => 'Послато';

  @override
  String get received => 'Примљено';

  @override
  String get errors => 'Грешке';

  @override
  String get notConnected => 'Није Повезан';

  @override
  String get connectToSendMessages =>
      'Повежи се са чвором да шаљеш и примаш поруке';

  @override
  String get noMessagesYet => 'Још нема порука';

  @override
  String get broadcastToSvet => 'Емитуј на \"свет\" да стигне свима';

  @override
  String get broadcastToSvetHint => 'Емитуј на свет...';

  @override
  String get noDirectMessages => 'Нема директних порука';

  @override
  String get sendMessageToNode => 'Пошаљи поруку одређеном чвору';

  @override
  String get messageToNode => 'Порука чвору...';

  @override
  String get selectRecipient => 'Изабери Примаоца';

  @override
  String get svet => 'Свет';

  @override
  String get direct => 'Директне';

  @override
  String get you => 'Ти';

  @override
  String get searchNodes => 'Претражи чворове...';

  @override
  String get recentConversations => 'Недавне Конверзације';

  @override
  String get availableNodes => 'Доступни Чворови';

  @override
  String get noNodesAvailable => 'Нема доступних чворова';

  @override
  String get waitForNodeDiscovery =>
      'Сачекај да мрежа пронађе чворове у близини';

  @override
  String get directMessage => 'Директна Порука';

  @override
  String get startConversation => 'Почни конверзацију';

  @override
  String get typeMessage => 'Напиши поруку...';

  @override
  String get failedToSendMessage => 'Слање поруке неуспешно';
}
