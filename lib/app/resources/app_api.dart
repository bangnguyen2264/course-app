/// API Endpoints Constants
///
/// Tổ chức theo controllers từ backend
abstract class AppApi {
  // ============================================================================
  // BASE URL
  // ============================================================================
  static const String baseUrl = 'http://127.0.0.1:8081/api'; // TODO: Thay đổi base URL

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
  static String userById(dynamic id) => '/user/$id';
  static String userDelete(dynamic id) => '/user/$id';
  static String userUpdate(dynamic id) => '/user/$id';
  static String userChangePassword(dynamic id) => '/user/$id/change-password';

  // ============================================================================
  // SUBJECT CONTROLLER
  // ============================================================================
  static const String subjectList = '/subject';
  static const String subjectCreate = '/subject';
  static const String subjectBatchCreate = '/subject/batch';
  static String subjectById(dynamic id) => '/subject/$id';
  static String subjectDelete(dynamic id) => '/subject/$id';
  static String subjectUpdate(dynamic id) => '/subject/$id';

  // ============================================================================
  // CHAPTER CONTROLLER
  // ============================================================================
  static const String chapterList = '/chapter';
  static const String chapterCreate = '/chapter';
  static const String chapterBatchCreate = '/chapter/batch';
  static String chapterById(dynamic id) => '/chapter/$id';
  static String chapterDelete(dynamic id) => '/chapter/$id';
  static String chapterUpdate(dynamic id) => '/chapter/$id';

  // ============================================================================
  // LESSON CONTROLLER
  // ============================================================================
  static const String lessonList = '/lesson';
  static const String lessonCreate = '/lesson';
  static const String lessonBatchCreate = '/lesson/batch';
  static String lessonById(dynamic id) => '/lesson/$id';
  static String lessonDelete(dynamic id) => '/lesson/$id';
  static String lessonUpdate(dynamic id) => '/lesson/$id';

  // ============================================================================
  // LESSON SECTION CONTROLLER
  // ============================================================================
  static const String lessonSectionList = '/lesson-section';
  static const String lessonSectionCreate = '/lesson-section';
  static const String lessonSectionBatchCreate = '/lesson-section/batch';
  static String lessonSectionById(dynamic id) => '/lesson-section/$id';
  static String lessonSectionDelete(dynamic id) => '/lesson-section/$id';
  static String lessonSectionUpdate(dynamic id) => '/lesson-section/$id';

  // ============================================================================
  // QUIZ CONTROLLER
  // ============================================================================
  static const String quizList = '/quiz';
  static const String quizCreate = '/quiz';
  static String quizById(dynamic id) => '/quiz/$id';
  static String quizDelete(dynamic id) => '/quiz/$id';
  static String quizUpdate(dynamic id) => '/quiz/$id';

  // ============================================================================
  // EXAM CONTROLLER
  // ============================================================================
  static const String examList = '/exam';
  static const String examCreate = '/exam';
  static String examById(dynamic id) => '/exam/$id';
  static String examDelete(dynamic id) => '/exam/$id';
  static String examUpdate(dynamic id) => '/exam/$id';

  // ============================================================================
  // EXAM RESULT CONTROLLER
  // ============================================================================
  static const String examResultList = '/exam-result';
  static const String examResultSubmit = '/exam-result/submit';
  static String examResultById(dynamic id) => '/exam-result/$id';

  // ============================================================================
  // MEDIA CONTROLLER
  // ============================================================================
  static const String mediaUploadPublic = '/media/upload/public';
  static const String mediaUploadPrivate = '/media/upload/private';
  static String mediaPublicById(dynamic id) => '/media/public/$id';
  static String mediaPrivateById(dynamic id) => '/media/private/$id';
}
