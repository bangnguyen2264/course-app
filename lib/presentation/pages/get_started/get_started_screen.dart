import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:course/app/resources/app_assets.dart';
import 'package:course/app/resources/app_value.dart';
import 'package:course/app/services/user_preferences_service.dart';
import 'package:course/app/di/dependency_injection.dart';
import 'package:sizer/sizer.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> with SingleTickerProviderStateMixin {
  bool _showAuthButtons = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _prefsService = getIt<UserPreferencesService>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    // _checkFirstTime();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkFirstTime() async {
    final hasSeenIntro = await _prefsService.hasSeenIntro();

    if (hasSeenIntro) {
      setState(() {
        _showAuthButtons = true;
      });
      _animationController.value = 1.0;
    }
  }

  Future<void> _handleGetStarted() async {
    await _prefsService.setHasSeenIntro(true);

    setState(() {
      _showAuthButtons = true;
    });
    _animationController.forward();
  }

  void _navigateToLogin() {
    context.go('/login');
  }

  void _navigateToRegister() {
    context.go('/register');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColor.appGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Illustration
              Expanded(
                flex: 5,
                child: Center(
                  child: Image.asset(
                    AppAssets.logo,
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.6,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Content Card
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppValues.v32),
                      topRight: Radius.circular(AppValues.v32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: AppValues.v24,
                        offset: Offset(0, -AppValues.v4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppValues.v24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title and Description
                        Column(
                          children: [
                            Text(
                              'Học tập là cách tốt nhất\nđể phát triển',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColor.titleText,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: AppValues.v16),
                            Text(
                              'Khám phá hàng ngàn khóa học chất lượng cao, '
                              'nâng cao kiến thức và kỹ năng của bạn mọi lúc mọi nơi',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColor.statisticLabel,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),

                        // Buttons
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _showAuthButtons
                              ? FadeTransition(opacity: _fadeAnimation, child: _buildAuthButtons())
                              : _buildGetStartedButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      key: const ValueKey('get_started'),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleGetStarted,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppValues.v16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppValues.v12)),
          elevation: 0,
        ),
        child: Text(
          'Bắt đầu',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildAuthButtons() {
    return Column(
      key: const ValueKey('auth_buttons'),
      children: [
        // Login Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _navigateToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: AppValues.v16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppValues.v12)),
              elevation: 0,
            ),
            child: Text(
              'Đăng nhập',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: AppValues.v12),

        // Register Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _navigateToRegister,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.primary,
              side: const BorderSide(color: AppColor.primary, width: 2),
              padding: const EdgeInsets.symmetric(vertical: AppValues.v16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppValues.v12)),
            ),
            child: Text(
              'Đăng ký',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColor.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
