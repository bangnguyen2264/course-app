import 'package:course/domain/entities/exam/exam.dart';
import 'package:course/domain/entities/exam_result.dart/exam_result_detail.dart';
import 'package:course/domain/entities/lesson/lesson.dart';
import 'package:course/domain/entities/subject/subject.dart';
import 'package:course/presentation/pages/chapter/chapter_page.dart';
import 'package:course/presentation/pages/exam_history/exam_history_page.dart';
import 'package:course/presentation/pages/exam_list/exam_list_page.dart';
import 'package:course/presentation/pages/exam_result/exam_result_page.dart';
import 'package:course/presentation/pages/exam_review/exam_review_page.dart';
import 'package:course/presentation/pages/home/home_page.dart';
import 'package:course/presentation/pages/exam_take/exam_take_page.dart';
import 'package:course/presentation/pages/lesson_detail/lesson_detail_page.dart';
import 'package:course/presentation/pages/login/login_page.dart';
import 'package:course/presentation/pages/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:course/app/constants/app_routes.dart';
import 'package:course/presentation/pages/get_started/get_started_page.dart';
import 'package:course/presentation/pages/splash_loading_page.dart';
import 'package:course/presentation/pages/dashboard/dashboard_shell_page.dart';
import 'package:course/presentation/pages/exam/exam_page.dart';
import 'package:course/presentation/pages/setting/setting_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash route - kiểm tra auth và redirect
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashLoadingPage()),

      // Auth routes
      GoRoute(
        path: AppRoutes.getStarted,
        name: 'get-started',
        builder: (context, state) => const GetStartedPage(),
      ),
      GoRoute(path: AppRoutes.login, name: 'login', builder: (context, state) => LoginPage()),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Forgot Password Screen - TODO'))),
      ),

      // Main routes (Dashboard Shell)
      ShellRoute(
        builder: (context, state, child) => DashboardShellPage(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.exam,
            name: 'exam',
            builder: (context, state) => const ExamPage(),
          ),
          GoRoute(
            path: AppRoutes.setting,
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),

      // Course routes
      GoRoute(
        path: AppRoutes.courseList,
        name: 'course-list',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Course List - TODO'))),
      ),

      // Chapter routes
      GoRoute(
        path: AppRoutes.chapter,
        name: 'chapter',
        builder: (context, state) {
          final subject = state.extra as Subject?;
          if (subject == null) {
            return const Scaffold(body: Center(child: Text('Subject not found')));
          }
          return ChapterPage(subject: subject);
        },
      ),

      // Lesson Detail routes
      GoRoute(
        path: AppRoutes.lessonSection,
        name: 'lesson-section',
        builder: (context, state) {
          final lesson = state.extra as Lesson?;
          if (lesson == null) {
            return const Scaffold(body: Center(child: Text('Lesson not found')));
          }
          return LessonDetailPage(lesson: lesson);
        },
      ),

      // Exam List routes
      GoRoute(
        path: AppRoutes.examList,
        name: 'exam-list',
        builder: (context, state) {
          final subject = state.extra as Subject?;
          if (subject == null) {
            return const Scaffold(body: Center(child: Text('Subject not found')));
          }
          return ExamListPage(subject: subject);
        },
      ),

      // Exam Take routes
      GoRoute(
        path: AppRoutes.examTake,
        name: 'exam-take',
        builder: (context, state) {
          final exam = state.extra as Exam?;
          if (exam == null) {
            return const Scaffold(body: Center(child: Text('Exam not found')));
          }
          return ExamTakePage(exam: exam);
        },
      ),

      // Exam Result routes
      GoRoute(
        path: AppRoutes.examResult,
        name: 'exam-result',
        builder: (context, state) {
          final result = state.extra as ExamResultDetail?;
          return ExamResultPage(result: result);
        },
      ),

      // Exam History routes
      GoRoute(
        path: AppRoutes.examHistory,
        name: 'exam-history',
        builder: (context, state) {
          final examId = state.extra as Exam?;
          return ExamHistoryPage(exam: examId!);
        },
      ),



      // Exam Review routes
      GoRoute(
        path: AppRoutes.examReview,
        name: 'exam-review',
        builder: (context, state) {
          final examResult = state.extra as ExamResultDetail?;
          if (examResult == null) {
            return const Scaffold(body: Center(child: Text('Không có examResult.')));
          }
          return ExamReviewPage(examResult: examResult);
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
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Edit Profile - TODO'))),
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
