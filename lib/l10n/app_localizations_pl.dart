// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'LEAP DockMate';

  @override
  String get poweredBy => 'Zasilane przez Oracle OTM';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get password => 'Hasło';

  @override
  String get usernameRequired => 'Nazwa użytkownika jest wymagana';

  @override
  String get passwordRequired => 'Hasło jest wymagane';

  @override
  String get instanceUrl => 'URL instancji';

  @override
  String get advanced => 'Zaawansowane';

  @override
  String get invalidCredentials => 'Nieprawidłowe dane. Sprawdź nazwę użytkownika i hasło.';

  @override
  String serverError(int code) {
    return 'Błąd serwera ($code). Spróbuj ponownie lub skontaktuj się z administratorem.';
  }

  @override
  String attemptsRemaining(int count) {
    return 'Pozostała $count próba przed blokadą';
  }

  @override
  String tryAgainIn(int seconds) {
    return 'Spróbuj ponownie za ${seconds}s';
  }

  @override
  String get otmInstance => 'Instancja OTM';

  @override
  String get swipeToRemove => 'Przesuń w lewo, aby usunąć';

  @override
  String get scanNewInstance => 'Skanuj nową instancję';

  @override
  String get savedInstances => 'Zapisane instancje';

  @override
  String get noInstancesSaved => 'Brak zapisanych instancji';

  @override
  String get tapToSetupInstance => 'Dotknij, aby skonfigurować instancję OTM';

  @override
  String get confirmInstance => 'Potwierdź instancję';

  @override
  String get addOtmInstance => 'Dodaj instancję OTM';

  @override
  String get saveAndUse => 'Zapisz i użyj tej instancji';

  @override
  String get scanAgain => 'Skanuj ponownie';

  @override
  String get scanQrCode => 'Skanuj kod QR';

  @override
  String get enterManually => 'Wprowadź ręcznie';

  @override
  String get pointCamera => 'Skieruj kamerę na kod QR instancji OTM';

  @override
  String get urlValidating => 'URL będzie weryfikowany podczas pisania';

  @override
  String get urlNotRecognised => 'URL nie jest rozpoznany jako instancja OTM';

  @override
  String get otmProduction => 'OTM Produkcja';

  @override
  String get otmTest => 'OTM Test';

  @override
  String get otmDevelopment => 'OTM Rozwój';

  @override
  String otmDevelopmentN(int n) {
    return 'OTM Rozwój $n';
  }

  @override
  String get shipmentGroups => 'Grupy przesyłek';

  @override
  String get shipmentGroup => 'GRUPA PRZESYŁEK';

  @override
  String get shipments => 'Przesyłki';

  @override
  String get groupId => 'ID GRUPY';

  @override
  String get inbound => 'Przychodzące';

  @override
  String get outbound => 'Wychodzące';

  @override
  String get inboundUpper => 'PRZYCHODZĄCE';

  @override
  String get outboundUpper => 'WYCHODZĄCE';

  @override
  String get showImporter => 'Pokaż grupy importera';

  @override
  String get showExporter => 'Pokaż grupy eksportera';

  @override
  String get assigned => 'Przypisany';

  @override
  String get start => 'ROZPOCZNIJ';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get done => 'Gotowe';

  @override
  String get cancel => 'Anuluj';

  @override
  String switchTeam(String team) {
    return 'Przełącz na $team';
  }

  @override
  String get plannedPickup => 'Planowany odbiór';

  @override
  String get plannedDelivery => 'Planowana dostawa';

  @override
  String get pickup => 'ODBIÓR';

  @override
  String get delivery => 'DOSTAWA';

  @override
  String get weight => 'Waga';

  @override
  String get volume => 'Objętość';

  @override
  String get documents => 'Dokumenty';

  @override
  String get addDocument => 'Dodaj dokument';

  @override
  String get uploadDocument => 'Prześlij dokument';

  @override
  String get removeDocument => 'Usuń dokument';

  @override
  String get remove => 'Usuń';

  @override
  String get takePhoto => 'Zrób zdjęcie';

  @override
  String get chooseFile => 'Wybierz plik';

  @override
  String get pod => 'POD';

  @override
  String get bol => 'BOL';

  @override
  String get invoice => 'Faktura';

  @override
  String get packingList => 'Lista pakowania';

  @override
  String get inspection => 'Inspekcja';

  @override
  String get customs => 'Cło';

  @override
  String get other => 'Inne';

  @override
  String get authorization => 'Autoryzacja';

  @override
  String get changeTheme => 'Zmień motyw';

  @override
  String get language => 'Język';
}
