// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'LEAP DockMate';

  @override
  String get poweredBy => 'Unterstützt von Oracle OTM';

  @override
  String get signIn => 'Anmelden';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get usernameRequired => 'Benutzername ist erforderlich';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get instanceUrl => 'Instanz-URL';

  @override
  String get advanced => 'Erweitert';

  @override
  String get invalidCredentials => 'Ungültige Anmeldedaten. Überprüfen Sie Benutzername und Passwort.';

  @override
  String serverError(int code) {
    return 'Serverfehler ($code). Versuchen Sie es erneut oder kontaktieren Sie den Administrator.';
  }

  @override
  String attemptsRemaining(int count) {
    return '$count Versuch verbleibend vor Sperrung';
  }

  @override
  String tryAgainIn(int seconds) {
    return 'Versuchen Sie es in ${seconds}s erneut';
  }

  @override
  String get otmInstance => 'OTM-Instanz';

  @override
  String get swipeToRemove => 'Nach links wischen zum Entfernen';

  @override
  String get scanNewInstance => 'Neue Instanz scannen';

  @override
  String get savedInstances => 'Gespeicherte Instanzen';

  @override
  String get noInstancesSaved => 'Keine gespeicherten Instanzen';

  @override
  String get tapToSetupInstance => 'Tippen Sie, um die OTM-Instanz einzurichten';

  @override
  String get confirmInstance => 'Instanz bestätigen';

  @override
  String get addOtmInstance => 'OTM-Instanz hinzufügen';

  @override
  String get saveAndUse => 'Diese Instanz speichern und verwenden';

  @override
  String get scanAgain => 'Erneut scannen';

  @override
  String get scanQrCode => 'QR-Code scannen';

  @override
  String get enterManually => 'Manuell eingeben';

  @override
  String get pointCamera => 'Kamera auf den QR-Code der OTM-Instanz richten';

  @override
  String get urlValidating => 'URL wird während der Eingabe validiert';

  @override
  String get urlNotRecognised => 'URL nicht als OTM-Instanz erkannt';

  @override
  String get otmProduction => 'OTM Produktion';

  @override
  String get otmTest => 'OTM Test';

  @override
  String get otmDevelopment => 'OTM Entwicklung';

  @override
  String otmDevelopmentN(int n) {
    return 'OTM Entwicklung $n';
  }

  @override
  String get shipmentGroups => 'Sendungsgruppen';

  @override
  String get shipmentGroup => 'SENDUNGSGRUPPE';

  @override
  String get shipments => 'Sendungen';

  @override
  String get groupId => 'GRUPPEN-ID';

  @override
  String get inbound => 'Eingehend';

  @override
  String get outbound => 'Ausgehend';

  @override
  String get inboundUpper => 'EINGEHEND';

  @override
  String get outboundUpper => 'AUSGEHEND';

  @override
  String get showImporter => 'Importeur-Gruppen anzeigen';

  @override
  String get showExporter => 'Exporteur-Gruppen anzeigen';

  @override
  String get assigned => 'Zugewiesen';

  @override
  String get start => 'STARTEN';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get done => 'Fertig';

  @override
  String get cancel => 'Abbrechen';

  @override
  String switchTeam(String team) {
    return 'Zu $team wechseln';
  }

  @override
  String get plannedPickup => 'Geplante Abholung';

  @override
  String get plannedDelivery => 'Geplante Lieferung';

  @override
  String get pickup => 'ABHOLUNG';

  @override
  String get delivery => 'LIEFERUNG';

  @override
  String get weight => 'Gewicht';

  @override
  String get volume => 'Volumen';

  @override
  String get documents => 'Dokumente';

  @override
  String get addDocument => 'Dokument hinzufügen';

  @override
  String get uploadDocument => 'Dokument hochladen';

  @override
  String get removeDocument => 'Dokument entfernen';

  @override
  String get remove => 'Entfernen';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get chooseFile => 'Datei wählen';

  @override
  String get pod => 'POD';

  @override
  String get bol => 'BOL';

  @override
  String get invoice => 'Rechnung';

  @override
  String get packingList => 'Packliste';

  @override
  String get inspection => 'Inspektion';

  @override
  String get customs => 'Zoll';

  @override
  String get other => 'Sonstige';

  @override
  String get authorization => 'Autorisierung';

  @override
  String get changeTheme => 'Thema ändern';

  @override
  String get language => 'Sprache';
}
