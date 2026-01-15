import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:course/app/resources/app_assets.dart';
import 'package:course/app/services/secure_storage.dart';
import 'package:course/app/constants/app_routes.dart';
import 'package:course/app/di/dependency_injection.dart';
import 'package:sizer/sizer.dart';

class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({Key? key}) : super(key: key);

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Đợi một chút để UI render xong
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    final secureStorage = getIt<SecureStorage>();
    final hasToken = await secureStorage.hasValidToken();

    if (!mounted) return;

    // Navigate dựa trên token
    if (hasToken) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.getStarted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: BoxDecoration(gradient: AppColor.appGradient)),
    );
  }
}
