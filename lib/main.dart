import 'package:course/app/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:course/app/theme/app_theme.dart';
import 'package:course/app/resources/app_route.dart';
import 'package:course/app/widgets/splash_remover.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:course/app/di/dependency_injection.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:course/app/config/dio_config.dart';
import 'package:course/app/constants/app_routes.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve native splash screen while loading
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Setup dependencies
  await setupDependencies();

  // Thiết lập màu status bar mặc định cho toàn hệ thống
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColor.primary, // hoặc AppColor.scaffoldBackground nếu muốn nền trắng
      statusBarIconBrightness: Brightness.light, // icon sáng trên nền tối
      statusBarBrightness: Brightness.dark, // cho iOS
    ),
  );

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup token expiration callback
    DioConfig.setOnTokenExpiredCallback(() {
      AppRouter.router.go(AppRoutes.getStarted);
    });

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
