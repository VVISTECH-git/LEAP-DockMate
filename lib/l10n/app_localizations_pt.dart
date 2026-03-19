// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'LEAP DockMate';

  @override
  String get poweredBy => 'Desenvolvido com Oracle OTM';

  @override
  String get signIn => 'Entrar';

  @override
  String get username => 'Usuário';

  @override
  String get password => 'Senha';

  @override
  String get usernameRequired => 'O usuário é obrigatório';

  @override
  String get passwordRequired => 'A senha é obrigatória';

  @override
  String get instanceUrl => 'URL da instância';

  @override
  String get advanced => 'Avançado';

  @override
  String get invalidCredentials => 'Credenciais inválidas. Verifique seu usuário e senha.';

  @override
  String serverError(int code) {
    return 'Erro do servidor ($code). Tente novamente ou contate o administrador.';
  }

  @override
  String attemptsRemaining(int count) {
    return '$count tentativa restante antes do bloqueio';
  }

  @override
  String tryAgainIn(int seconds) {
    return 'Tente novamente em ${seconds}s';
  }

  @override
  String get otmInstance => 'Instância OTM';

  @override
  String get swipeToRemove => 'Deslize para a esquerda para remover';

  @override
  String get scanNewInstance => 'Escanear nova instância';

  @override
  String get savedInstances => 'Instâncias salvas';

  @override
  String get noInstancesSaved => 'Nenhuma instância salva';

  @override
  String get tapToSetupInstance => 'Toque para configurar a instância OTM';

  @override
  String get confirmInstance => 'Confirmar instância';

  @override
  String get addOtmInstance => 'Adicionar instância OTM';

  @override
  String get saveAndUse => 'Salvar e usar esta instância';

  @override
  String get scanAgain => 'Escanear novamente';

  @override
  String get scanQrCode => 'Escanear código QR';

  @override
  String get enterManually => 'Inserir manualmente';

  @override
  String get pointCamera => 'Aponte a câmera para o código QR da instância OTM';

  @override
  String get urlValidating => 'A URL será validada enquanto você digita';

  @override
  String get urlNotRecognised => 'URL não reconhecida como instância OTM';

  @override
  String get otmProduction => 'OTM Produção';

  @override
  String get otmTest => 'OTM Teste';

  @override
  String get otmDevelopment => 'OTM Desenvolvimento';

  @override
  String otmDevelopmentN(int n) {
    return 'OTM Desenvolvimento $n';
  }

  @override
  String get shipmentGroups => 'Grupos de remessa';

  @override
  String get shipmentGroup => 'GRUPO DE REMESSA';

  @override
  String get shipments => 'Remessas';

  @override
  String get groupId => 'ID DO GRUPO';

  @override
  String get inbound => 'Entrada';

  @override
  String get outbound => 'Saída';

  @override
  String get inboundUpper => 'ENTRADA';

  @override
  String get outboundUpper => 'SAÍDA';

  @override
  String get showImporter => 'Mostrar grupos importador';

  @override
  String get showExporter => 'Mostrar grupos exportador';

  @override
  String get assigned => 'Atribuído';

  @override
  String get start => 'INICIAR';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get done => 'Concluído';

  @override
  String get cancel => 'Cancelar';

  @override
  String switchTeam(String team) {
    return 'Mudar para $team';
  }

  @override
  String get plannedPickup => 'Coleta planejada';

  @override
  String get plannedDelivery => 'Entrega planejada';

  @override
  String get pickup => 'COLETA';

  @override
  String get delivery => 'ENTREGA';

  @override
  String get weight => 'Peso';

  @override
  String get volume => 'Volume';

  @override
  String get documents => 'Documentos';

  @override
  String get addDocument => 'Adicionar documento';

  @override
  String get uploadDocument => 'Enviar documento';

  @override
  String get removeDocument => 'Remover documento';

  @override
  String get remove => 'Remover';

  @override
  String get takePhoto => 'Tirar foto';

  @override
  String get chooseFile => 'Escolher arquivo';

  @override
  String get pod => 'POD';

  @override
  String get bol => 'BOL';

  @override
  String get invoice => 'Fatura';

  @override
  String get packingList => 'Lista de embalagem';

  @override
  String get inspection => 'Inspeção';

  @override
  String get customs => 'Alfândega';

  @override
  String get other => 'Outro';

  @override
  String get authorization => 'Autorização';

  @override
  String get changeTheme => 'Alterar tema';

  @override
  String get language => 'Idioma';
}
