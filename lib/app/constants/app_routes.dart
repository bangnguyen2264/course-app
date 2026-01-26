/// Abstract class định nghĩa các route names
abstract class AppRoutes {
  // Auth routes
  static const String getStarted = '/get-started';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main routes
  static const String home = '/home';
  static const String exam = '/exam';
  static const String splash = '/';

  // Course routes
  static const String courseList = '/courses';

  // Chapter routes
  static const String chapter = '/chapters';

  // Lesson section routes
  static const String lessonSection = '/lesson-sections';

  // Exam routes
  static const String examList = '/exam-list';
  static const String examTake = '/exam-take';
  static const String examResult = '/exam-result';
  static const String examHistory = '/exam-history';
  static const String examReview = '/exam-review';
  static const String examReviewBeforeSubmit = '/exam-review-before-submit';

  // Quiz routes
  static const String quizList = '/quizzes';
  static const String quizDetail = '/quizzes/:id';
  static const String quizResult = '/quizzes/:id/result';

  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String setting = '/setting';
  static const String changePassword = '/change-password';

  // Other routes
  static const String notifications = '/notifications';
  static const String help = '/help';
  static const String about = '/about';
}
