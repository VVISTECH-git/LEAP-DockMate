// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LEAP DockMate';

  @override
  String get poweredBy => 'Propulsé par Oracle OTM';

  @override
  String get signIn => 'Se connecter';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get usernameRequired => 'Le nom d\'utilisateur est requis';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get instanceUrl => 'URL de l\'instance';

  @override
  String get advanced => 'Avancé';

  @override
  String get invalidCredentials => 'Identifiants invalides. Vérifiez votre nom d\'utilisateur et mot de passe.';

  @override
  String serverError(int code) {
    return 'Erreur serveur ($code). Réessayez ou contactez votre administrateur.';
  }

  @override
  String attemptsRemaining(int count) {
    return '$count tentative restante avant le verrouillage';
  }

  @override
  String tryAgainIn(int seconds) {
    return 'Réessayez dans ${seconds}s';
  }

  @override
  String get otmInstance => 'Instance OTM';

  @override
  String get swipeToRemove => 'Glisser à gauche pour supprimer';

  @override
  String get scanNewInstance => 'Scanner une nouvelle instance';

  @override
  String get savedInstances => 'Instances enregistrées';

  @override
  String get noInstancesSaved => 'Aucune instance enregistrée';

  @override
  String get tapToSetupInstance => 'Appuyez pour configurer l\'instance OTM';

  @override
  String get confirmInstance => 'Confirmer l\'instance';

  @override
  String get addOtmInstance => 'Ajouter une instance OTM';

  @override
  String get saveAndUse => 'Enregistrer et utiliser cette instance';

  @override
  String get scanAgain => 'Scanner à nouveau';

  @override
  String get scanQrCode => 'Scanner le code QR';

  @override
  String get enterManually => 'Saisir manuellement';

  @override
  String get pointCamera => 'Pointez la caméra vers le code QR de l\'instance OTM';

  @override
  String get urlValidating => 'L\'URL sera validée pendant la saisie';

  @override
  String get urlNotRecognised => 'URL non reconnue comme instance OTM';

  @override
  String get otmProduction => 'OTM Production';

  @override
  String get otmTest => 'OTM Test';

  @override
  String get otmDevelopment => 'OTM Développement';

  @override
  String otmDevelopmentN(int n) {
    return 'OTM Développement $n';
  }

  @override
  String get shipmentGroups => 'Groupes d\'expédition';

  @override
  String get shipmentGroup => 'GROUPE D\'EXPÉDITION';

  @override
  String get shipments => 'Expéditions';

  @override
  String get groupId => 'ID GROUPE';

  @override
  String get inbound => 'Entrant';

  @override
  String get outbound => 'Sortant';

  @override
  String get inboundUpper => 'ENTRANT';

  @override
  String get outboundUpper => 'SORTANT';

  @override
  String get showImporter => 'Afficher les groupes importateur';

  @override
  String get showExporter => 'Afficher les groupes exportateur';

  @override
  String get assigned => 'Assigné';

  @override
  String get start => 'DÉMARRER';

  @override
  String get retry => 'Réessayer';

  @override
  String get done => 'Terminé';

  @override
  String get cancel => 'Annuler';

  @override
  String switchTeam(String team) {
    return 'Passer à $team';
  }

  @override
  String get plannedPickup => 'Enlèvement prévu';

  @override
  String get plannedDelivery => 'Livraison prévue';

  @override
  String get pickup => 'ENLÈVEMENT';

  @override
  String get delivery => 'LIVRAISON';

  @override
  String get weight => 'Poids';

  @override
  String get volume => 'Volume';

  @override
  String get documents => 'Documents';

  @override
  String get addDocument => 'Ajouter un document';

  @override
  String get uploadDocument => 'Télécharger un document';

  @override
  String get removeDocument => 'Supprimer le document';

  @override
  String get remove => 'Supprimer';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseFile => 'Choisir un fichier';

  @override
  String get pod => 'POD';

  @override
  String get bol => 'BOL';

  @override
  String get invoice => 'Facture';

  @override
  String get packingList => 'Liste de colisage';

  @override
  String get inspection => 'Inspection';

  @override
  String get customs => 'Douanes';

  @override
  String get other => 'Autre';

  @override
  String get authorization => 'Autorisation';

  @override
  String get changeTheme => 'Changer le thème';

  @override
  String get language => 'Langue';
}
