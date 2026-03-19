// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'LEAP DockMate';

  @override
  String get poweredBy => 'مدعوم من Oracle OTM';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get instanceUrl => 'رابط النظام';

  @override
  String get advanced => 'متقدم';

  @override
  String get invalidCredentials => 'بيانات غير صحيحة. يرجى التحقق من اسم المستخدم وكلمة المرور.';

  @override
  String serverError(int code) {
    return 'خطأ في الخادم ($code). حاول مرة أخرى أو تواصل مع المسؤول.';
  }

  @override
  String attemptsRemaining(int count) {
    return 'تبقى $count محاولة قبل الإغلاق';
  }

  @override
  String tryAgainIn(int seconds) {
    return 'حاول مجدداً خلال $seconds ثانية';
  }

  @override
  String get otmInstance => 'نظام OTM';

  @override
  String get swipeToRemove => 'اسحب لليسار للحذف';

  @override
  String get scanNewInstance => 'مسح نظام جديد';

  @override
  String get savedInstances => 'الأنظمة المحفوظة';

  @override
  String get noInstancesSaved => 'لا توجد أنظمة محفوظة بعد';

  @override
  String get tapToSetupInstance => 'اضغط لإعداد نظام OTM';

  @override
  String get confirmInstance => 'تأكيد النظام';

  @override
  String get addOtmInstance => 'إضافة نظام OTM';

  @override
  String get saveAndUse => 'حفظ واستخدام هذا النظام';

  @override
  String get scanAgain => 'مسح مرة أخرى';

  @override
  String get scanQrCode => 'مسح رمز QR';

  @override
  String get enterManually => 'إدخال يدوي';

  @override
  String get pointCamera => 'وجّه الكاميرا نحو رمز QR الخاص بنظام OTM';

  @override
  String get urlValidating => 'سيتم التحقق من الرابط أثناء الكتابة';

  @override
  String get urlNotRecognised => 'الرابط غير معروف كنظام OTM';

  @override
  String get otmProduction => 'OTM الإنتاج';

  @override
  String get otmTest => 'OTM الاختبار';

  @override
  String get otmDevelopment => 'OTM التطوير';

  @override
  String otmDevelopmentN(int n) {
    return 'OTM التطوير $n';
  }

  @override
  String get shipmentGroups => 'مجموعات الشحن';

  @override
  String get shipmentGroup => 'مجموعة الشحن';

  @override
  String get shipments => 'الشحنات';

  @override
  String get groupId => 'رقم المجموعة';

  @override
  String get inbound => 'وارد';

  @override
  String get outbound => 'صادر';

  @override
  String get inboundUpper => 'وارد';

  @override
  String get outboundUpper => 'صادر';

  @override
  String get showImporter => 'عرض مجموعات المستورد';

  @override
  String get showExporter => 'عرض مجموعات المصدّر';

  @override
  String get assigned => 'مُعيَّن';

  @override
  String get start => 'بدء';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get done => 'تم';

  @override
  String get cancel => 'إلغاء';

  @override
  String switchTeam(String team) {
    return 'التبديل إلى $team';
  }

  @override
  String get plannedPickup => 'الاستلام المخطط';

  @override
  String get plannedDelivery => 'التسليم المخطط';

  @override
  String get pickup => 'الاستلام';

  @override
  String get delivery => 'التسليم';

  @override
  String get weight => 'الوزن';

  @override
  String get volume => 'الحجم';

  @override
  String get documents => 'المستندات';

  @override
  String get addDocument => 'إضافة مستند';

  @override
  String get uploadDocument => 'رفع مستند';

  @override
  String get removeDocument => 'حذف مستند';

  @override
  String get remove => 'حذف';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFile => 'اختيار ملف';

  @override
  String get pod => 'POD';

  @override
  String get bol => 'BOL';

  @override
  String get invoice => 'فاتورة';

  @override
  String get packingList => 'قائمة التعبئة';

  @override
  String get inspection => 'تفتيش';

  @override
  String get customs => 'جمارك';

  @override
  String get other => 'أخرى';

  @override
  String get authorization => 'التفويض';

  @override
  String get changeTheme => 'تغيير المظهر';

  @override
  String get language => 'اللغة';
}
