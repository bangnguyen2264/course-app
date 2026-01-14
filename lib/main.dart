import 'package:flutter/material.dart';
import 'package:course/app/theme/app_theme.dart';
import 'package:course/app/resources/app_route.dart';
import 'package:course/app/widgets/splash_remover.dart';
import 'package:sizer/sizer.dart';
import 'package:course/app/di/dependency_injection.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve native splash screen while loading
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Setup dependencies
  await setupDependencies();

  // DON'T remove splash here - let SplashRemover do it after first frame

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashRemover(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            title: 'Course App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
