// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'LEAP DockMate';

  @override
  String get poweredBy => 'Impulsado por Oracle OTM';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get username => 'Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get usernameRequired => 'El usuario es obligatorio';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String get instanceUrl => 'URL de la instancia';

  @override
  String get advanced => 'Avanzado';

  @override
  String get invalidCredentials => 'Credenciales inválidas. Verifica tu usuario y contraseña.';

  @override
  String serverError(int code) {
    return 'Error del servidor ($code). Inténtalo de nuevo o contacta al administrador.';
  }

  @override
  String attemptsRemaining(int count) {
    return '$count intento restante antes del bloqueo';
  }

  @override
  String tryAgainIn(int seconds) {
    return 'Inténtalo en ${seconds}s';
  }

  @override
  String get otmInstance => 'Instancia OTM';

  @override
  String get swipeToRemove => 'Desliza a la izquierda para eliminar';

  @override
  String get scanNewInstance => 'Escanear nueva instancia';

  @override
  String get savedInstances => 'Instancias guardadas';

  @override
  String get noInstancesSaved => 'No hay instancias guardadas';

  @override
  String get tapToSetupInstance => 'Toca para configurar la instancia OTM';

  @override
  String get confirmInstance => 'Confirmar instancia';

  @override
  String get addOtmInstance => 'Agregar instancia OTM';

  @override
  String get saveAndUse => 'Guardar y usar esta instancia';

  @override
  String get scanAgain => 'Escanear de nuevo';

  @override
  String get scanQrCode => 'Escanear código QR';

  @override
  String get enterManually => 'Ingresar manualmente';

  @override
  String get pointCamera => 'Apunta la cámara al código QR de la instancia OTM';

  @override
  String get urlValidating => 'La URL se validará mientras escribes';

  @override
  String get urlNotRecognised => 'URL no reconocida como instancia OTM';

  @override
  String get otmProduction => 'OTM Producción';

  @override
  String get otmTest => 'OTM Pruebas';

  @override
  String get otmDevelopment => 'OTM Desarrollo';

  @override
  String otmDevelopmentN(int n) {
    return 'OTM Desarrollo $n';
  }

  @override
  String get shipmentGroups => 'Grupos de envío';

  @override
  String get shipmentGroup => 'GRUPO DE ENVÍO';

  @override
  String get shipments => 'Envíos';

  @override
  String get groupId => 'ID GRUPO';

  @override
  String get inbound => 'Entrante';

  @override
  String get outbound => 'Saliente';

  @override
  String get inboundUpper => 'ENTRANTE';

  @override
  String get outboundUpper => 'SALIENTE';

  @override
  String get showImporter => 'Mostrar grupos importador';

  @override
  String get showExporter => 'Mostrar grupos exportador';

  @override
  String get assigned => 'Asignado';

  @override
  String get start => 'INICIAR';

  @override
  String get retry => 'Reintentar';

  @override
  String get done => 'Listo';

  @override
  String get cancel => 'Cancelar';

  @override
  String switchTeam(String team) {
    return 'Cambiar a $team';
  }

  @override
  String get plannedPickup => 'Recogida planificada';

  @override
  String get plannedDelivery => 'Entrega planificada';

  @override
  String get pickup => 'RECOGIDA';

  @override
  String get delivery => 'ENTREGA';

  @override
  String get weight => 'Peso';

  @override
  String get volume => 'Volumen';

  @override
  String get documents => 'Documentos';

  @override
  String get addDocument => 'Agregar documento';

  @override
  String get uploadDocument => 'Subir documento';

  @override
  String get removeDocument => 'Eliminar documento';

  @override
  String get remove => 'Eliminar';

  @override
  String get takePhoto => 'Tomar foto';

  @override
  String get chooseFile => 'Elegir archivo';

  @override
  String get pod => 'POD';

  @override
  String get bol => 'BOL';

  @override
  String get invoice => 'Factura';

  @override
  String get packingList => 'Lista de empaque';

  @override
  String get inspection => 'Inspección';

  @override
  String get customs => 'Aduanas';

  @override
  String get other => 'Otro';

  @override
  String get authorization => 'Autorización';

  @override
  String get changeTheme => 'Cambiar tema';

  @override
  String get language => 'Idioma';
}
