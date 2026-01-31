import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/daos/daos.dart';
import 'package:kidtastic_flutter/database/seeder/seed.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/pages/color_game/color_game.dart';
import 'package:kidtastic_flutter/pages/counting_game/counting_game.dart';
import 'package:kidtastic_flutter/pages/dashboard/view/dashboard_page.dart';
import 'package:kidtastic_flutter/pages/student_list/student_list.dart';
import 'package:path/path.dart' as p;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:window_manager/window_manager.dart';

import 'constants/constants.dart';
import 'pages/game_list/game_list.dart';
import 'pages/home/home.dart';
import 'pages/login/login.dart';
import 'pages/match_game/match_game.dart';
import 'pages/math_game/math_game.dart';
import 'pages/number_game/number_game.dart';
import 'pages/pronunciation_game/pronunciation_game.dart';
import 'pages/register/register.dart';
import 'pages/shape_game/shape_game.dart';
import 'pages/initial_screen/initial_screen.dart';
import 'pages/student_profile/student_profile.dart';
import 'repositories/repositories.dart';
import 'service/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1024, 700),
    minimumSize: Size(1024, 700),
    center: true,
    windowButtonVisibility: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'Kidtastic',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await Future.delayed(const Duration(milliseconds: 300));
    await windowManager.show();
    await windowManager.focus();
  });

  try {
    final dbPath = await _getDbPath();

    // Delete old DB if you truly want "new install = new db"
    // (or comment this out if you want to preserve it between runs)
    // if (await File(dbPath).exists()) {
    //   await File(dbPath).delete();
    // }

    final db = KidtasticDatabase.withPath(dbPath);

    final gameQuestionRepository = GameQuestionRepository(
      gameQuestionDao: GameQuestionDao(db),
    );

    final gameRepository = GameRepository(
      gameDao: GameDao(db),
    );

    final seeder = InitialDataSeeder(
      gameRepository: gameRepository,
      gameQuestionRepository: gameQuestionRepository,
    );

    await AudioService.instance.init(
      bgmAsset: Audios.pptBackground,
    );

    runApp(
      MyApp(
        studentRepository: StudentRepository(
          studentDao: StudentDao(db),
        ),
        gameQuestionRepository: gameQuestionRepository,
        gameRepository: gameRepository,
        gameSessionRepository: GameSessionRepository(
          gameSessionDao: GameSessionDao(db),
        ),
        sessionQuestionRepository: SessionQuestionRepository(
          sessionQuestionDao: SessionQuestionDao(db),
        ),
        studentInsightRepository: StudentInsightRepository(
          studentInstightDao: StudentInsightDao(db),
        ),
        teacherRepository: TeacherRepository(
          teacherDao: TeacherDao(db),
        ),
        pronunciationAttemptRepository: PronunciationAttemptRepository(
          pronunciationAttemptDao: PronunciationAttemptDao(db),
        ),
      ),
    );
    await seeder.seed();
  } catch (e, st) {
    debugPrint('Database init failed: $e\n$st');

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize: $e'),
          ),
        ),
      ),
    );
    return;
  }
}

Future<String> _getDbPath() async {
  final localAppData =
      Platform.environment['LOCALAPPDATA'] ??
      Platform.environment['APPDATA'] ??
      Directory.current.path;

  final dbDir = Directory(p.join(localAppData, 'Kidtastic'));
  if (!await dbDir.exists()) {
    await dbDir.create(recursive: true);
  }

  return p.join(dbDir.path, 'kidtasticdb.sqlite');
}

class MyApp extends StatefulWidget {
  final StudentRepository studentRepository;
  final GameRepository gameRepository;
  final GameQuestionRepository gameQuestionRepository;
  final GameSessionRepository gameSessionRepository;
  final SessionQuestionRepository sessionQuestionRepository;
  final StudentInsightRepository studentInsightRepository;
  final TeacherRepository teacherRepository;
  final PronunciationAttemptRepository pronunciationAttemptRepository;

  const MyApp({
    super.key,
    required this.studentRepository,
    required this.gameQuestionRepository,
    required this.gameRepository,
    required this.gameSessionRepository,
    required this.sessionQuestionRepository,
    required this.studentInsightRepository,
    required this.teacherRepository,
    required this.pronunciationAttemptRepository,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();

    router = GoRouter(
      initialLocation: HomePage.route,
      routes: <RouteBase>[
        GoRoute(
          path: InitialScreenPage.route,
          builder: (context, state) {
            return const InitialScreenPage();
          },
        ),
        GoRoute(
          path: HomePage.route,
          builder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: GameListPage.route,
          builder: (context, state) {
            return GameListPage(
              initialState: state.extra as GameListState,
            );
          },
        ),
        GoRoute(
          path: NumberGamePage.route,
          builder: (context, state) {
            return NumberGamePage();
          },
        ),
        GoRoute(
          path: MathGamePage.route,
          builder: (context, state) {
            return MathGamePage();
          },
        ),
        GoRoute(
          path: PronunciationGamePage.route,
          builder: (context, state) {
            return PronunciationGamePage(
              initialState: state.extra as PronunciationGameState,
            );
          },
        ),
        GoRoute(
          path: CountingGamePage.route,
          builder: (context, state) {
            return CountingGamePage(
              initialState: state.extra as CountingGameState,
            );
          },
        ),
        GoRoute(
          path: ShapeGamePage.route,
          builder: (context, state) {
            return ShapeGamePage(
              initialState: state.extra as ShapeGameState,
            );
          },
        ),
        GoRoute(
          path: MatchGamePage.route,
          builder: (context, state) {
            return MatchGamePage(
              initialState: state.extra as MatchGameState,
            );
          },
        ),
        GoRoute(
          path: RegisterPage.route,
          builder: (context, state) {
            return RegisterPage();
          },
        ),
        GoRoute(
          path: LoginPage.route,
          builder: (context, state) {
            return LoginPage();
          },
        ),
        GoRoute(
          path: RegisterPage.route,
          builder: (context, state) {
            return RegisterPage();
          },
        ),
        GoRoute(
          path: DashboardPage.route,
          builder: (context, state) {
            return DashboardPage();
          },
        ),
        GoRoute(
          path: ColorGamePage.route,
          builder: (context, state) {
            return ColorGamePage();
          },
        ),
        GoRoute(
          path: StudentListPage.route,
          builder: (context, state) {
            return StudentListPage();
          },
        ),
        GoRoute(
          path: StudentProfilePage.route,
          builder: (context, state) {
            return StudentProfilePage(
              initialState: state.extra as StudentProfileState,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: widget.studentRepository,
        ),
        RepositoryProvider.value(
          value: widget.gameRepository,
        ),
        RepositoryProvider.value(
          value: widget.gameQuestionRepository,
        ),
        RepositoryProvider.value(
          value: widget.gameSessionRepository,
        ),
        RepositoryProvider.value(
          value: widget.sessionQuestionRepository,
        ),
        RepositoryProvider.value(
          value: widget.studentInsightRepository,
        ),
        RepositoryProvider.value(
          value: widget.teacherRepository,
        ),
        RepositoryProvider.value(
          value: widget.pronunciationAttemptRepository,
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child ?? const SizedBox(),
          breakpoints: const [
            Breakpoint(
              start: 0,
              end: 600,
              name: MOBILE,
            ),
            Breakpoint(
              start: 601,
              end: 1024,
              name: TABLET,
            ),
            Breakpoint(
              start: 1025,
              end: 1440,
              name: DESKTOP,
            ),
            Breakpoint(
              start: 1441,
              end: double.infinity,
              name: 'XL',
            ),
          ],
        ),
        theme: ThemeData(
          fontFamily: 'Vag',
          textTheme: Typography.blackMountainView.apply(
            fontFamily: 'Vag',
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            primary: Colors.blueAccent,
            onPrimary: const Color(0xFFFFFFFF),
            surface: const Color(0xFFFFFFFF),
            secondary: const Color(0xFFE9C46A),
            onSecondary: const Color(0xFFEAB308),
            tertiary: const Color(0xFFBAFFBE),
            onTertiary: const Color(0xFF22C55E),
            onTertiaryContainer: const Color(0xFF14532D),
            primaryContainer: const Color(0xFF3F3F46),
            secondaryContainer: const Color(0xFF27272A),
            onSecondaryContainer: const Color(0xFFFEF9C3),
            tertiaryContainer: const Color(0xFF000000),
            error: const Color(0xFFEF4444),
            outline: const Color(0xFFA1A1AA),
            outlineVariant: const Color(0xFFD9D9D9),
            onSurface: const Color(0xFF000000),
            onSurfaceVariant: const Color(0xFF1D3557),
            onInverseSurface: const Color(0xFFD8EAFE),
            surfaceTint: const Color(0xFF474D66),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
              fontFamily: 'Vag',
            ),
            hintStyle: TextStyle(
              fontFamily: 'Vag',
            ),
            errorStyle: TextStyle(
              fontFamily: 'Vag',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFBC5D19),
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.all(12.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateColor.resolveWith(
                (states) => Colors.transparent,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFFFFFFFF),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              side: const BorderSide(
                color: Color(0xFFBC5D19),
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              backgroundColor: const Color(0xFFBC5D19),
              foregroundColor: Color(0xFFFFFFFF),
              iconColor: const Color(0xFFFFFFFF),
              disabledBackgroundColor: const Color(0xFF3F3F46),
              disabledForegroundColor: const Color(0xFFFFFFFF),
              disabledIconColor: const Color(0xFFFFFFFF),
            ),
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: const Color(0xFF051C22),
            headerBackgroundColor: const Color(0xFF051C22),
            headerForegroundColor: const Color(0xFFFFFFFF),
            dividerColor: const Color(0xFFFFFFFF),
            yearForegroundColor: WidgetStatePropertyAll(Colors.white),
            weekdayStyle: TextStyle(color: const Color(0xFFBC5D19)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            dayForegroundColor: WidgetStatePropertyAll(Colors.white),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFFBC5D19);
              }
              return Colors.transparent;
            }),
          ),
          checkboxTheme: CheckboxThemeData(
            checkColor: WidgetStatePropertyAll(Color(0xFFFFFFFF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(color: const Color(0xFFBC5D19)),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Color(0xFFBC5D19),
            unselectedItemColor: Color(0xFFFFFFFF),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme: const IconThemeData(color: Color(0xFFBC5D19)),
            unselectedIconTheme: const IconThemeData(
              color: Color(0xFFFFFFFF),
            ),
            backgroundColor: const Color(0xFF27272A),
          ),
          switchTheme: SwitchThemeData(
            trackColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color.fromARGB(255, 220, 112, 35);
              }
              return Colors.grey.shade400;
            }),
            thumbColor: WidgetStatePropertyAll(Colors.white),
            trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color.fromARGB(255, 220, 112, 35);
              }
              return Colors.transparent;
            }),
            splashRadius: 0,
          ),
          sliderTheme: SliderThemeData(
            activeTrackColor: const Color.fromARGB(255, 220, 112, 35),
            inactiveTrackColor: Colors.grey.shade400,
            valueIndicatorColor: const Color.fromARGB(255, 220, 112, 35),
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          cardTheme: CardThemeData(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }
}
