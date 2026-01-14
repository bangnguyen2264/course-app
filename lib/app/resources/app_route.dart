import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:course/app/constants/app_routes.dart';
import 'package:course/presentation/pages/get_started/get_started_screen.dart';
import 'package:course/presentation/pages/home/home_screen.dart';
import 'package:course/presentation/pages/splash/splash_loading_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash route - kiểm tra auth và redirect
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashLoadingScreen()),

      // Auth routes
      GoRoute(
        path: AppRoutes.getStarted,
        name: 'get-started',
        builder: (context, state) => const GetStartedScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Login Screen - TODO'))),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Register Screen - TODO'))),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Forgot Password Screen - TODO'))),
      ),

      // Main routes
      GoRoute(path: AppRoutes.home, name: 'home', builder: (context, state) => const HomeScreen()),

      // Course routes
      GoRoute(
        path: AppRoutes.courseList,
        name: 'course-list',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Course List - TODO'))),
      ),
      GoRoute(
        path: AppRoutes.courseDetail,
        name: 'course-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return Scaffold(body: Center(child: Text('Course Detail $id - TODO')));
        },
      ),

      // Quiz routes
      GoRoute(
        path: AppRoutes.quizList,
        name: 'quiz-list',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Quiz List - TODO'))),
      ),
      GoRoute(
        path: AppRoutes.quizDetail,
        name: 'quiz-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return Scaffold(body: Center(child: Text('Quiz Detail $id - TODO')));
        },
      ),

      // Profile routes
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Profile - TODO'))),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Edit Profile - TODO'))),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Settings - TODO'))),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text('Trang không tồn tại', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(state.error.toString()),
          ],
        ),
      ),
    ),
  );
}
