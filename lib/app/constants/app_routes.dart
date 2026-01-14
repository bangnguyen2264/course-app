/// Abstract class định nghĩa các route names
abstract class AppRoutes {
  // Auth routes
  static const String getStarted = '/get-started';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main routes
  static const String home = '/home';
  static const String splash = '/';

  // Course routes
  static const String courseList = '/courses';
  static const String courseDetail = '/courses/:id';
  static const String courseLesson = '/courses/:courseId/lessons/:lessonId';

  // Quiz routes
  static const String quizList = '/quizzes';
  static const String quizDetail = '/quizzes/:id';
  static const String quizResult = '/quizzes/:id/result';

  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';

  // Other routes
  static const String notifications = '/notifications';
  static const String help = '/help';
  static const String about = '/about';
}
