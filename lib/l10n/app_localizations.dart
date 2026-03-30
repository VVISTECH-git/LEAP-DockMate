import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LEAP DockMate'**
  String get appTitle;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by Oracle OTM'**
  String get poweredBy;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @instanceUrl.
  ///
  /// In en, this message translates to:
  /// **'Instance URL'**
  String get instanceUrl;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please check your username and password.'**
  String get invalidCredentials;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error ({code}). Please try again or contact your admin.'**
  String serverError(int code);

  /// No description provided for @attemptsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} attempt remaining before lockout'**
  String attemptsRemaining(int count);

  /// No description provided for @tryAgainIn.
  ///
  /// In en, this message translates to:
  /// **'Try again in {seconds}s'**
  String tryAgainIn(int seconds);

  /// No description provided for @otmInstance.
  ///
  /// In en, this message translates to:
  /// **'OTM Instance'**
  String get otmInstance;

  /// No description provided for @swipeToRemove.
  ///
  /// In en, this message translates to:
  /// **'Swipe left to remove'**
  String get swipeToRemove;

  /// No description provided for @scanNewInstance.
  ///
  /// In en, this message translates to:
  /// **'Scan new instance'**
  String get scanNewInstance;

  /// No description provided for @savedInstances.
  ///
  /// In en, this message translates to:
  /// **'Saved instances'**
  String get savedInstances;

  /// No description provided for @noInstancesSaved.
  ///
  /// In en, this message translates to:
  /// **'No instances saved yet'**
  String get noInstancesSaved;

  /// No description provided for @tapToSetupInstance.
  ///
  /// In en, this message translates to:
  /// **'Tap to set up OTM instance'**
  String get tapToSetupInstance;

  /// No description provided for @confirmInstance.
  ///
  /// In en, this message translates to:
  /// **'Confirm instance'**
  String get confirmInstance;

  /// No description provided for @addOtmInstance.
  ///
  /// In en, this message translates to:
  /// **'Add OTM instance'**
  String get addOtmInstance;

  /// No description provided for @saveAndUse.
  ///
  /// In en, this message translates to:
  /// **'Save & use this instance'**
  String get saveAndUse;

  /// No description provided for @scanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get scanAgain;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scanQrCode;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// No description provided for @pointCamera.
  ///
  /// In en, this message translates to:
  /// **'Point camera at the OTM instance QR code'**
  String get pointCamera;

  /// No description provided for @urlValidating.
  ///
  /// In en, this message translates to:
  /// **'URL will be validated as you type'**
  String get urlValidating;

  /// No description provided for @urlNotRecognised.
  ///
  /// In en, this message translates to:
  /// **'URL not recognised as an OTM instance'**
  String get urlNotRecognised;

  /// No description provided for @otmProduction.
  ///
  /// In en, this message translates to:
  /// **'OTM Production'**
  String get otmProduction;

  /// No description provided for @otmTest.
  ///
  /// In en, this message translates to:
  /// **'OTM Test'**
  String get otmTest;

  /// No description provided for @otmDevelopment.
  ///
  /// In en, this message translates to:
  /// **'OTM Development'**
  String get otmDevelopment;

  /// No description provided for @otmDevelopmentN.
  ///
  /// In en, this message translates to:
  /// **'OTM Development {n}'**
  String otmDevelopmentN(int n);

  /// No description provided for @shipmentGroups.
  ///
  /// In en, this message translates to:
  /// **'Shipment Groups'**
  String get shipmentGroups;

  /// No description provided for @shipmentGroup.
  ///
  /// In en, this message translates to:
  /// **'SHIPMENT GROUP'**
  String get shipmentGroup;

  /// No description provided for @shipments.
  ///
  /// In en, this message translates to:
  /// **'Shipments'**
  String get shipments;

  /// No description provided for @groupId.
  ///
  /// In en, this message translates to:
  /// **'GROUP ID'**
  String get groupId;

  /// No description provided for @inbound.
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get inbound;

  /// No description provided for @outbound.
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get outbound;

  /// No description provided for @inboundUpper.
  ///
  /// In en, this message translates to:
  /// **'INBOUND'**
  String get inboundUpper;

  /// No description provided for @outboundUpper.
  ///
  /// In en, this message translates to:
  /// **'OUTBOUND'**
  String get outboundUpper;

  /// No description provided for @showImporter.
  ///
  /// In en, this message translates to:
  /// **'Show IMPORTER shipment groups'**
  String get showImporter;

  /// No description provided for @showExporter.
  ///
  /// In en, this message translates to:
  /// **'Show EXPORTER shipment groups'**
  String get showExporter;

  /// No description provided for @assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assigned;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @switchTeam.
  ///
  /// In en, this message translates to:
  /// **'Switch to {team}'**
  String switchTeam(String team);

  String get switchView;

  /// No description provided for @plannedPickup.
  ///
  /// In en, this message translates to:
  /// **'Planned Pickup'**
  String get plannedPickup;

  /// No description provided for @plannedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Planned Delivery'**
  String get plannedDelivery;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'PICKUP'**
  String get pickup;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'DELIVERY'**
  String get delivery;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocument;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @removeDocument.
  ///
  /// In en, this message translates to:
  /// **'Remove Document'**
  String get removeDocument;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No description provided for @pod.
  ///
  /// In en, this message translates to:
  /// **'POD'**
  String get pod;

  /// No description provided for @bol.
  ///
  /// In en, this message translates to:
  /// **'BOL'**
  String get bol;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @packingList.
  ///
  /// In en, this message translates to:
  /// **'Packing List'**
  String get packingList;

  /// No description provided for @inspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get inspection;

  /// No description provided for @customs.
  ///
  /// In en, this message translates to:
  /// **'Customs'**
  String get customs;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @authorization.
  ///
  /// In en, this message translates to:
  /// **'Authorization'**
  String get authorization;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get changeTheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search shipment groups…'**
  String get searchHint;

  /// No description provided for @noInboundGroups.
  ///
  /// In en, this message translates to:
  /// **'No inbound groups'**
  String get noInboundGroups;

  /// No description provided for @noOutboundGroups.
  ///
  /// In en, this message translates to:
  /// **'No outbound groups'**
  String get noOutboundGroups;

  /// No description provided for @noGroupsFound.
  ///
  /// In en, this message translates to:
  /// **'No groups found'**
  String get noGroupsFound;

  /// No description provided for @apptStart.
  ///
  /// In en, this message translates to:
  /// **'APPT START'**
  String get apptStart;

  /// No description provided for @apptEnd.
  ///
  /// In en, this message translates to:
  /// **'APPT END'**
  String get apptEnd;

  /// No description provided for @shipUnits.
  ///
  /// In en, this message translates to:
  /// **'SHIP UNITS'**
  String get shipUnits;

  /// No description provided for @truckPlate.
  ///
  /// In en, this message translates to:
  /// **'TRUCK PLATE'**
  String get truckPlate;

  /// No description provided for @dockDoor.
  ///
  /// In en, this message translates to:
  /// **'DOCK DOOR'**
  String get dockDoor;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'FROM'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'TO'**
  String get to;

  /// No description provided for @fetchingShipments.
  ///
  /// In en, this message translates to:
  /// **'Fetching shipments…'**
  String get fetchingShipments;

  /// No description provided for @noShipmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No shipments found'**
  String get noShipmentsFound;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get uploadSuccess;

  /// No description provided for @uploadFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload document'**
  String get uploadFailure;

  /// No description provided for @uploadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Upload cancelled'**
  String get uploadCancelled;

  /// No description provided for @removeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document removed'**
  String get removeSuccess;

  /// No description provided for @removeFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove document'**
  String get removeFailure;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en', 'es', 'fr', 'hi', 'pl', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}