import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/initial_screen/view/view.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'pages/home/view/view.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();

  // WindowOptions windowOptions = const WindowOptions(
  //   size: Size(800, 600),
  //   center: true,
  //   backgroundColor: Colors.transparent,
  //   skipTaskbar: false,
  //   titleBarStyle: TitleBarStyle.hidden,
  //   windowButtonVisibility: false,
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFEF4444)),
            borderRadius: BorderRadius.circular(16.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(color: Color(0xFFBC5D19)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(color: Color(0xFFEF4444)),
          ),
          filled: true,
          fillColor: const Color(0xFF27272A),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: BorderSide(color: const Color(0xFFBC5D19)),
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          tileColor: const Color(0xFF27272A),
          selectedTileColor: const Color(0xFF27272A),
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
    );
  }
}
