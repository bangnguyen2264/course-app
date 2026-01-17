/// API Endpoints Constants
///
/// Dùng cho Retrofit với @Path()
abstract class AppApi {
  // ============================================================================
  // BASE URL
  // ============================================================================
  static const String baseUrl = 'https://courses-demo-hsa2hsg0bmcwcxhq.eastasia-01.azurewebsites.net';
  static const String prefix = '/api';

  // ============================================================================
  // AUTH CONTROLLER
  // ============================================================================
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';

  // ============================================================================
  // USER CONTROLLER
  // ============================================================================
  static const String userList = '/user';
  static const String userById = '/user/{id}';
  static const String userDelete = '/user/{id}';
  static const String userUpdate = '/user/{id}';
  static const String userChangePassword = '/user/{id}/change-password';

  // ============================================================================
  // SUBJECT CONTROLLER
  // ============================================================================
  static const String subjectList = '/subject';
  static const String subjectCreate = '/subject';
  static const String subjectBatchCreate = '/subject/batch';
  static const String subjectById = '/subject/{id}';
  static const String subjectDelete = '/subject/{id}';
  static const String subjectUpdate = '/subject/{id}';

  // ============================================================================
  // CHAPTER CONTROLLER
  // ============================================================================
  static const String chapterList = '/chapter';
  static const String chapterCreate = '/chapter';
  static const String chapterBatchCreate = '/chapter/batch';
  static const String chapterById = '/chapter/{id}';
  static const String chapterDelete = '/chapter/{id}';
  static const String chapterUpdate = '/chapter/{id}';

  // ============================================================================
  // LESSON CONTROLLER
  // ============================================================================
  static const String lessonList = '/lesson';
  static const String lessonCreate = '/lesson';
  static const String lessonBatchCreate = '/lesson/batch';
  static const String lessonById = '/lesson/{id}';
  static const String lessonDelete = '/lesson/{id}';
  static const String lessonUpdate = '/lesson/{id}';

  // ============================================================================
  // LESSON SECTION CONTROLLER
  // ============================================================================
  static const String lessonSectionList = '/lesson-section';
  static const String lessonSectionCreate = '/lesson-section';
  static const String lessonSectionBatchCreate = '/lesson-section/batch';
  static const String lessonSectionById = '/lesson-section/{id}';
  static const String lessonSectionDelete = '/lesson-section/{id}';
  static const String lessonSectionUpdate = '/lesson-section/{id}';

  // ============================================================================
  // QUIZ CONTROLLER
  // ============================================================================
  static const String quizList = '/quiz';
  static const String quizCreate = '/quiz';
  static const String quizById = '/quiz/{id}';
  static const String quizDelete = '/quiz/{id}';
  static const String quizUpdate = '/quiz/{id}';

  // ============================================================================
  // EXAM CONTROLLER
  // ============================================================================
  static const String examList = '/exam';
  static const String examCreate = '/exam';
  static const String examById = '/exam/{id}';
  static const String examDelete = '/exam/{id}';
  static const String examUpdate = '/exam/{id}';

  // ============================================================================
  // EXAM RESULT CONTROLLER
  // ============================================================================
  static const String examResultList = '/exam-result';
  static const String examResultSubmit = '/exam-result/submit';
  static const String examResultById = '/exam-result/{id}';

  // ============================================================================
  // MEDIA CONTROLLER
  // ============================================================================
  static const String mediaUploadPublic = '/media/upload/public';
  static const String mediaUploadPrivate = '/media/upload/private';
  static const String mediaPublicById = '/media/public/{id}';
  static const String mediaPrivateById = '/media/private/{id}';
}
