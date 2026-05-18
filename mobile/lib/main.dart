import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

// Core
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';

// Database
import 'data/database/database_helper.dart';

// Services
import 'data/services/seed_service.dart';
import 'data/services/notification_service.dart';

// Repositories
import 'data/repositories/profil_repository.dart';
import 'data/repositories/evaluation_repository.dart';
import 'data/repositories/rappel_repository.dart';
import 'data/repositories/centre_repository.dart';
import 'data/repositories/contenu_repository.dart';
import 'data/repositories/stat_repository.dart';

// ViewModels
import 'features/langue/langue_viewmodel.dart';
import 'features/home/home_viewmodel.dart';
import 'features/informations/informations_viewmodel.dart';
import 'features/auto_examen/auto_examen_viewmodel.dart';
import 'features/evaluation/evaluation_viewmodel.dart';
import 'features/centres/centres_viewmodel.dart';
import 'features/rappels/rappels_viewmodel.dart';
import 'features/historique/historique_viewmodel.dart';

// Screens
import 'features/splash/splash_screen.dart';
import 'features/langue/langue_screen.dart';
import 'features/home/home_screen.dart';
import 'features/informations/informations_screen.dart';
import 'features/evaluation/evaluation_screen.dart';
import 'features/evaluation/resultat_screen.dart';
import 'features/centres/centres_screen.dart';
import 'features/rappels/rappels_screen.dart';
import 'features/historique/historique_screen.dart';
import 'features/historique/detail_evaluation_screen.dart';
import 'features/auto_examen/auto_examen_video_screen.dart';
import 'features/auto_examen/auto_examen_guide_screen.dart';
import 'features/auto_examen/etapes_screen.dart';
void main() async {
  // Obligatoire avant tout appel async dans main()
  WidgetsFlutterBinding.ensureInitialized();

  // Portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Couleur de la barre de statut Android
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFFC0185A),
    statusBarIconBrightness: Brightness.light,
  ));

  // Fuseaux horaires (nécessaire pour les notifications)
  tz.initializeTimeZones();

  // Initialiser la base de données SQLite
  final db = DatabaseHelper.instance;
  await db.database; // Crée les tables si premier lancement

  // Insérer les données statiques (questions, centres, contenus)
  await SeedService(db).initialiser();

  // Initialiser les notifications locales
  await NotificationService.instance.initialiser();
  runApp(
    MultiProvider(
      providers: [
        // ── Repositories ──
        // Provider simple : pas de ChangeNotifier,
        // juste une instance partagée
        Provider(create: (_) => ProfilRepository(db)),
        Provider(create: (_) => EvaluationRepository(db)),
        Provider(create: (_) => RappelRepository(db)),
        Provider(create: (_) => CentreRepository(db)),
        Provider(create: (_) => ContenuRepository(db)),
        Provider(create: (_) => StatRepository(db)),

        // ── ViewModels ──
        // ChangeNotifierProxyProvider : le ViewModel
        // dépend d'un Repository déjà créé ci-dessus

        ChangeNotifierProxyProvider<ProfilRepository, LangueViewModel>(
          create: (ctx) => LangueViewModel(ctx.read<ProfilRepository>()),
          update: (_, repo, vm) => vm ?? LangueViewModel(repo),
        ),

        ChangeNotifierProxyProvider<ProfilRepository, HomeViewModel>(
          create: (ctx) => HomeViewModel(ctx.read<ProfilRepository>()),
          update: (_, repo, vm) => vm ?? HomeViewModel(repo),
        ),

        ChangeNotifierProxyProvider<ContenuRepository, InformationsViewModel>(
          create: (ctx) =>
              InformationsViewModel(ctx.read<ContenuRepository>()),
          update: (_, repo, vm) => vm ?? InformationsViewModel(repo),
        ),

        ChangeNotifierProxyProvider<ContenuRepository, AutoExamenViewModel>(
          create: (ctx) =>
              AutoExamenViewModel(ctx.read<ContenuRepository>()),
          update: (_, repo, vm) => vm ?? AutoExamenViewModel(repo),
        ),

        // EvaluationViewModel dépend de DEUX repositories
        ChangeNotifierProxyProvider2<EvaluationRepository, ProfilRepository,
            EvaluationViewModel>(
          create: (ctx) => EvaluationViewModel(
            ctx.read<EvaluationRepository>(),
            ctx.read<ProfilRepository>(),
          ),
          update: (_, evalRepo, profilRepo, vm) =>
              vm ?? EvaluationViewModel(evalRepo, profilRepo),
        ),

        ChangeNotifierProxyProvider<CentreRepository, CentresViewModel>(
          create: (ctx) => CentresViewModel(ctx.read<CentreRepository>()),
          update: (_, repo, vm) => vm ?? CentresViewModel(repo),
        ),

        // RappelsViewModel dépend de DEUX repositories
        ChangeNotifierProxyProvider2<RappelRepository, ProfilRepository,
            RappelsViewModel>(
          create: (ctx) => RappelsViewModel(
            ctx.read<RappelRepository>(),
            ctx.read<ProfilRepository>(),
          ),
          update: (_, rappelRepo, profilRepo, vm) =>
              vm ?? RappelsViewModel(rappelRepo, profilRepo),
        ),

        ChangeNotifierProxyProvider<EvaluationRepository, HistoriqueViewModel>(
          create: (ctx) =>
              HistoriqueViewModel(ctx.read<EvaluationRepository>()),
          update: (_, repo, vm) => vm ?? HistoriqueViewModel(repo),
        ),
      ],
      child: const PagLaafiApp(),
    ),
  );
}

class PagLaafiApp extends StatelessWidget {
  const PagLaafiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pag Laafi',
      debugShowCheckedModeBanner: false,

      // Thème global
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.roseVif,
          primary: AppColors.roseFonce,
        ),
        scaffoldBackgroundColor: AppColors.fondPrincipal,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.roseFonce,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.roseFonce,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.roseFonce,
            side: const BorderSide(color: AppColors.roseFonce, width: 1.5),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),

      // Page de démarrage
      initialRoute: AppRoutes.splash,

      // Toutes les routes de l'application
      routes: {
  AppRoutes.splash:           (_) => const SplashScreen(),
  AppRoutes.langue:           (_) => const LangueScreen(),
  AppRoutes.home:             (_) => const HomeScreen(),
  AppRoutes.informations:     (_) => const InformationsScreen(),
  AppRoutes.autoExamen:       (_) => const AutoExamenGuideScreen(),  // ← Guide direct
  AppRoutes.autoExamenVideo:  (_) => const AutoExamenVideoScreen(),   // ← Si encore utile
  AppRoutes.autoExamenGuide:  (_) => const AutoExamenGuideScreen(),   // ← Redondant, peux supprimer
  AppRoutes.evaluation:       (_) => const EvaluationScreen(),
  AppRoutes.resultat:         (_) => const ResultatScreen(),
  AppRoutes.centres:          (_) => const CentresScreen(),
  AppRoutes.rappels:          (_) => const RappelsScreen(),
  AppRoutes.historique:       (_) => const HistoriqueScreen(),
  AppRoutes.detailEvaluation: (_) => const DetailEvaluationScreen(),
  AppRoutes.etapesAutoExamen: (_) => const EtapesScreen(),
},
    );
  }
}