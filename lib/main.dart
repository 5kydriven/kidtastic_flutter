import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/daos/daos.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/pages/initial_screen/view/view.dart';
import 'package:kidtastic_flutter/pages/math_game/view/math_game_page.dart';
import 'package:kidtastic_flutter/pages/number_game/view/number_game_page.dart';
import 'package:kidtastic_flutter/pages/pronunciation_game/pronunciation_game.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:window_manager/window_manager.dart';

import 'pages/home/view/view.dart';
import 'repositories/repositories.dart';

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

    final studentRepository = StudentRepository(
      studentDao: StudentDao(db),
    );

    final gameQuestionRepository = GameQuestionRepository(
      gameQuestionDao: GameQuestionDao(db),
    );

    final gameRepository = GameRepository(gameDao: GameDao(db));

    final gameSessionRepository = GameSessionRepository(
      gameSessionDao: GameSessionDao(db),
    );

    final sessionQuestionRepository = SessionQuestionRepository(
      sessionQuestionDao: SessionQuestionDao(db),
    );

    final studentInsightRepository = StudentInsightRepository(
      studentInstightDao: StudentInsightDao(db),
    );

    final teacherRepository = TeacherRepository(
      teacherDao: TeacherDao(db),
    );

    runApp(
      MyApp(
        studentRepository: studentRepository,
        gameQuestionRepository: gameQuestionRepository,
        gameRepository: gameRepository,
        gameSessionRepository: gameSessionRepository,
        sessionQuestionRepository: sessionQuestionRepository,
        studentInsightRepository: studentInsightRepository,
        teacherRepository: teacherRepository,
      ),
    );
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
  final exeDir = File(Platform.resolvedExecutable).parent.path;

  if (exeDir.contains('Program Files')) {
    final programDataDir = Directory(
      p.join(
        Platform.environment['ProgramData'] ?? r'C:\ProgramData',
        'Kidtastic',
      ),
    );
    if (!await programDataDir.exists()) {
      await programDataDir.create(recursive: true);
    }
    return p.join(programDataDir.path, 'kidtasticdb.sqlite');
  }

  final appSupportDir = await getApplicationSupportDirectory();
  final dbDir = Directory(p.join(appSupportDir.path, 'db'));
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

  const MyApp({
    super.key,
    required this.studentRepository,
    required this.gameQuestionRepository,
    required this.gameRepository,
    required this.gameSessionRepository,
    required this.sessionQuestionRepository,
    required this.studentInsightRepository,
    required this.teacherRepository,
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
      initialLocation: InitialScreenPage.route,
      routes: <RouteBase>[
        GoRoute(
          path: HomePage.route,
          builder: (context, state) {
            return HomePage();
          },
        ),
        GoRoute(
          path: InitialScreenPage.route,
          builder: (context, state) {
            return InitialScreenPage();
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
            return PronunciationGamePage();
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
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFBC5D19),
            primary: const Color(0xFFBC5D19),
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
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(
                color: Color(0xFFEF4444),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: Color(0xFFBC5D19)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(
                color: Color(0xFFEF4444),
              ),
            ),
            filled: true,
            prefixIconColor: const Color(0xFFFFFFFF),
            suffixIconColor: const Color(0xFFBC5D19),
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
              side: const BorderSide(color: Color(0xFFBC5D19)),
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
          listTileTheme: ListTileThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            tileColor: const Color.fromARGB(0, 255, 255, 255),
            selectedTileColor: const Color.fromARGB(0, 255, 255, 255),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Color(0xFFBC5D19),
            unselectedItemColor: Color(0xFFFFFFFF),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme: const IconThemeData(color: Color(0xFFBC5D19)),
            unselectedIconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
            backgroundColor: const Color(0xFF27272A),
          ),
        ),
      ),
    );
  }
}
