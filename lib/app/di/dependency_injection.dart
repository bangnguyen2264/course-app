import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:course/app/services/user_preferences_service.dart';
import 'package:course/app/services/secure_storage_service.dart';
import 'package:course/app/config/dio_config.dart';

/// GetIt instance - Singleton Dependency Injection container
final getIt = GetIt.instance;

/// Setup all dependencies
Future<void> setupDependencies() async {
  // Register SecureStorageService as singleton
  getIt.registerSingleton<SecureStorageService>(SecureStorageService.getInstance());

  // Register UserPreferencesService as singleton
  final userPrefsService = await UserPreferencesService.getInstance();
  getIt.registerSingleton<UserPreferencesService>(userPrefsService);

  // Register Dio as singleton
  getIt.registerSingleton<Dio>(DioConfig.getInstance());

  // TODO: Register other services here
  // Example:
  // getIt.registerLazySingleton<ApiService>(() => ApiService());
  // getIt.registerFactory<AuthRepository>(() => AuthRepository());
}
