// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'LEAP DockMate';

  @override
  String get poweredBy => 'Oracle OTM द्वारा संचालित';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get password => 'पासवर्ड';

  @override
  String get usernameRequired => 'उपयोगकर्ता नाम आवश्यक है';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get instanceUrl => 'इंस्टेंस URL';

  @override
  String get advanced => 'उन्नत';

  @override
  String get invalidCredentials => 'अमान्य क्रेडेंशियल। कृपया उपयोगकर्ता नाम और पासवर्ड जांचें।';

  @override
  String serverError(int code) {
    return 'सर्वर त्रुटि ($code)। पुनः प्रयास करें या व्यवस्थापक से संपर्क करें।';
  }

  @override
  String attemptsRemaining(int count) {
    return 'लॉकआउट से पहले $count प्रयास शेष';
  }

  @override
  String tryAgainIn(int seconds) {
    return '$seconds सेकंड में पुनः प्रयास करें';
  }

  @override
  String get otmInstance => 'OTM इंस्टेंस';

  @override
  String get swipeToRemove => 'हटाने के लिए बाईं ओर स्वाइप करें';

  @override
  String get scanNewInstance => 'नया इंस्टेंस स्कैन करें';

  @override
  String get savedInstances => 'सहेजे गए इंस्टेंस';

  @override
  String get noInstancesSaved => 'कोई इंस्टेंस सहेजा नहीं गया';

  @override
  String get tapToSetupInstance => 'OTM इंस्टेंस सेट अप करने के लिए टैप करें';

  @override
  String get confirmInstance => 'इंस्टेंस की पुष्टि करें';

  @override
  String get addOtmInstance => 'OTM इंस्टेंस जोड़ें';

  @override
  String get saveAndUse => 'इस इंस्टेंस को सहेजें और उपयोग करें';

  @override
  String get scanAgain => 'फिर से स्कैन करें';

  @override
  String get scanQrCode => 'QR कोड स्कैन करें';

  @override
  String get enterManually => 'मैन्युअली दर्ज करें';

  @override
  String get pointCamera => 'OTM इंस्टेंस QR कोड पर कैमरा निर्देशित करें';

  @override
  String get urlValidating => 'टाइप करते समय URL मान्य किया जाएगा';

  @override
  String get urlNotRecognised => 'URL को OTM इंस्टेंस के रूप में नहीं पहचाना गया';

  @override
  String get otmProduction => 'OTM उत्पादन';

  @override
  String get otmTest => 'OTM परीक्षण';

  @override
  String get otmDevelopment => 'OTM विकास';

  @override
  String otmDevelopmentN(int n) {
    return 'OTM विकास $n';
  }

  @override
  String get shipmentGroups => 'शिपमेंट समूह';

  @override
  String get shipmentGroup => 'शिपमेंट समूह';

  @override
  String get shipments => 'शिपमेंट';

  @override
  String get groupId => 'समूह ID';

  @override
  String get inbound => 'आवक';

  @override
  String get outbound => 'जावक';

  @override
  String get inboundUpper => 'आवक';

  @override
  String get outboundUpper => 'जावक';

  @override
  String get showImporter => 'आयातक शिपमेंट समूह दिखाएं';

  @override
  String get showExporter => 'निर्यातक शिपमेंट समूह दिखाएं';

  @override
  String get assigned => 'असाइन किया गया';

  @override
  String get start => 'शुरू करें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get done => 'हो गया';

  @override
  String get cancel => 'रद्द करें';

  @override
  String switchTeam(String team) {
    return '$team पर स्विच करें';
  }

  @override
  String get plannedPickup => 'नियोजित पिकअप';

  @override
  String get plannedDelivery => 'नियोजित डिलीवरी';

  @override
  String get pickup => 'पिकअप';

  @override
  String get delivery => 'डिलीवरी';

  @override
  String get weight => 'वजन';

  @override
  String get volume => 'आयतन';

  @override
  String get documents => 'दस्तावेज़';

  @override
  String get addDocument => 'दस्तावेज़ जोड़ें';

  @override
  String get uploadDocument => 'दस्तावेज़ अपलोड करें';

  @override
  String get removeDocument => 'दस्तावेज़ हटाएं';

  @override
  String get remove => 'हटाएं';

  @override
  String get takePhoto => 'फ़ोटो लें';

  @override
  String get chooseFile => 'फ़ाइल चुनें';

  @override
  String get pod => 'POD';

  @override
  String get bol => 'BOL';

  @override
  String get invoice => 'चालान';

  @override
  String get packingList => 'पैकिंग सूची';

  @override
  String get inspection => 'निरीक्षण';

  @override
  String get customs => 'सीमा शुल्क';

  @override
  String get other => 'अन्य';

  @override
  String get authorization => 'प्राधिकरण';

  @override
  String get changeTheme => 'थीम बदलें';

  @override
  String get language => 'भाषा';
}
