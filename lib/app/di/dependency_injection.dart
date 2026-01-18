import 'package:course/app/services/app_preferences.dart';
import 'package:course/app/services/secure_storage.dart';
import 'package:course/domain/repositories/auth_repository.dart';
import 'package:course/domain/repositories/chapter_reposirtory.dart';
import 'package:course/domain/repositories/file_repository.dart';
import 'package:course/domain/repositories/lesson_section_repository.dart';
import 'package:course/domain/repositories/subject_repository.dart';
import 'package:course/domain/repositories/user_repository.dart';
import 'package:course/domain/usecases/get_avatar_usecase.dart';
import 'package:course/domain/usecases/get_chapter_usecase.dart';
import 'package:course/domain/usecases/get_lesson_section_usecase.dart';
import 'package:course/domain/usecases/get_subject_usecase.dart';
import 'package:course/domain/usecases/get_user_usecase.dart';
import 'package:course/domain/usecases/login_usecase.dart';
import 'package:course/domain/usecases/logout_usecase.dart';
import 'package:course/domain/usecases/refresh_token_usecase.dart';
import 'package:course/domain/usecases/register_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:course/app/config/dio_config.dart';

/// GetIt instance - Singleton Dependency Injection container
final getIt = GetIt.instance;

/// Setup all dependencies
Future<void> setupDependencies() async {
  // Register SecureStorageService as singleton
  getIt.registerSingleton<SecureStorage>(SecureStorage.getInstance());

  // Register UserPreferencesService as singleton
  final userPrefsService = await AppPreferences.getInstance();
  getIt.registerSingleton<AppPreferences>(userPrefsService);

  // Register Dio as singleton
  getIt.registerSingleton<Dio>(DioConfig.getInstance());

  // Repositories
  getIt.registerFactory<AuthRepository>(() => AuthRepository(getIt<Dio>()));
  getIt.registerFactory<UserRepository>(() => UserRepository(getIt<Dio>()));
  getIt.registerFactory<FileRepository>(() => FileRepository(getIt<Dio>(), getIt<SecureStorage>()));
  getIt.registerFactory<SubjectRepository>(() => SubjectRepository(getIt<Dio>()));
  getIt.registerFactory<ChapterRepository>(() => ChapterRepository(getIt<Dio>()));
  getIt.registerFactory<LessonSectionRepository>(() => LessonSectionRepository(getIt<Dio>()));
  // getIt.registerFactory<LessonRepository>(() => LessonRepository(getIt<Dio>()));
  // getIt.registerFactory<QuizRepository>(() => QuizRepository(getIt<Dio>()));
  // getIt.registerFactory<ExamRepository>(() => ExamRepository(getIt<Dio>()));
  // getIt.registerFactory<ExamResultRepository>(() => ExamResultRepository(getIt<Dio>()));

  // UseCases - Auth
  getIt.registerFactory<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>(), getIt<SecureStorage>(), getIt<AppPreferences>()),
  );
  getIt.registerFactory<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerFactory<RefreshTokenUsecase>(
    () => RefreshTokenUsecase(getIt<AuthRepository>(), getIt<SecureStorage>()),
  );
  getIt.registerFactory<LogoutUseCase>(
    () => LogoutUseCase(getIt<SecureStorage>(), getIt<AppPreferences>()),
  );

  // UseCases - User
  getIt.registerFactory<GetUserUseCase>(
    () => GetUserUseCase(getIt<UserRepository>(), getIt<AppPreferences>()),
  );

  // UseCases - File
  getIt.registerFactory<GetAvatarUseCase>(() => GetAvatarUseCase(getIt<FileRepository>()));

  // UseCases - Subject
  getIt.registerFactory<GetSubjectUsecase>(() => GetSubjectUsecase(getIt<SubjectRepository>()));

  // UseCases - Chapter
  getIt.registerFactory<GetChapterUsecase>(() => GetChapterUsecase(getIt<ChapterRepository>()));

  // UseCases - Lesson Section
  getIt.registerFactory<GetLessonSectionUsecase>(
    () => GetLessonSectionUsecase(getIt<LessonSectionRepository>()),
  );
}
