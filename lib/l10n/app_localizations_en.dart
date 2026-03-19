// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LEAP DockMate';

  @override
  String get poweredBy => 'Powered by Oracle OTM';

  @override
  String get signIn => 'Sign In';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get instanceUrl => 'Instance URL';

  @override
  String get advanced => 'Advanced';

  @override
  String get invalidCredentials => 'Invalid credentials. Please check your username and password.';

  @override
  String serverError(int code) {
    return 'Server error ($code). Please try again or contact your admin.';
  }

  @override
  String attemptsRemaining(int count) {
    return '$count attempt remaining before lockout';
  }

  @override
  String tryAgainIn(int seconds) {
    return 'Try again in ${seconds}s';
  }

  @override
  String get otmInstance => 'OTM Instance';

  @override
  String get swipeToRemove => 'Swipe left to remove';

  @override
  String get scanNewInstance => 'Scan new instance';

  @override
  String get savedInstances => 'Saved instances';

  @override
  String get noInstancesSaved => 'No instances saved yet';

  @override
  String get tapToSetupInstance => 'Tap to set up OTM instance';

  @override
  String get confirmInstance => 'Confirm instance';

  @override
  String get addOtmInstance => 'Add OTM instance';

  @override
  String get saveAndUse => 'Save & use this instance';

  @override
  String get scanAgain => 'Scan again';

  @override
  String get scanQrCode => 'Scan QR code';

  @override
  String get enterManually => 'Enter manually';

  @override
  String get pointCamera => 'Point camera at the OTM instance QR code';

  @override
  String get urlValidating => 'URL will be validated as you type';

  @override
  String get urlNotRecognised => 'URL not recognised as an OTM instance';

  @override
  String get otmProduction => 'OTM Production';

  @override
  String get otmTest => 'OTM Test';

  @override
  String get otmDevelopment => 'OTM Development';

  @override
  String otmDevelopmentN(int n) {
    return 'OTM Development $n';
  }

  @override
  String get shipmentGroups => 'Shipment Groups';

  @override
  String get shipmentGroup => 'SHIPMENT GROUP';

  @override
  String get shipments => 'Shipments';

  @override
  String get groupId => 'GROUP ID';

  @override
  String get inbound => 'Inbound';

  @override
  String get outbound => 'Outbound';

  @override
  String get inboundUpper => 'INBOUND';

  @override
  String get outboundUpper => 'OUTBOUND';

  @override
  String get showImporter => 'Show IMPORTER shipment groups';

  @override
  String get showExporter => 'Show EXPORTER shipment groups';

  @override
  String get assigned => 'Assigned';

  @override
  String get start => 'START';

  @override
  String get retry => 'Retry';

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String switchTeam(String team) {
    return 'Switch to $team';
  }

  @override
  String get plannedPickup => 'Planned Pickup';

  @override
  String get plannedDelivery => 'Planned Delivery';

  @override
  String get pickup => 'PICKUP';

  @override
  String get delivery => 'DELIVERY';

  @override
  String get weight => 'Weight';

  @override
  String get volume => 'Volume';

  @override
  String get documents => 'Documents';

  @override
  String get addDocument => 'Add Document';

  @override
  String get uploadDocument => 'Upload Document';

  @override
  String get removeDocument => 'Remove Document';

  @override
  String get remove => 'Remove';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFile => 'Choose File';

  @override
  String get pod => 'POD';

  @override
  String get bol => 'BOL';

  @override
  String get invoice => 'Invoice';

  @override
  String get packingList => 'Packing List';

  @override
  String get inspection => 'Inspection';

  @override
  String get customs => 'Customs';

  @override
  String get other => 'Other';

  @override
  String get authorization => 'Authorization';

  @override
  String get changeTheme => 'Change theme';

  @override
  String get language => 'Language';
}
