import 'package:course/app/constants/app_routes.dart';
import 'package:course/presentation/controllers/register/register_controller.dart';
import 'package:course/presentation/controllers/register/register_state.dart';
import 'package:course/presentation/pages/register/widget/personal_info_page.dart';
import 'package:course/presentation/pages/register/widget/contact_info_page.dart';
import 'package:course/presentation/pages/register/widget/password_info_page.dart';
import 'package:course/presentation/pages/register/widget/address_info_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerControllerProvider);
    final registerController = ref.read(registerControllerProvider.notifier);

    final pageController = usePageController();

    // Listen to page changes
    useEffect(() {
      pageController.addListener(() {
        if (pageController.page != null) {
          registerController.setCurrentPage(pageController.page!.round());
        }
      });
      return null;
    }, []);

    // Listen to success state
    ref.listen<RegisterState>(registerControllerProvider, (previous, next) {
      if (next.isSuccess) {
        context.go(AppRoutes.login);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công! Vui lòng đăng nhập'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(value: (registerState.currentPage + 1) / 4),

          // PageView
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                PersonalInfoPage(), // Page 1: Họ tên, Ngày sinh, Giới tính
                ContactInfoPage(), // Page 2: Email, Số điện thoại
                PasswordInfoPage(), // Page 3: Mật khẩu
                AddressInfoPage(), // Page 4: Địa chỉ
              ],
            ),
          ),

          // Error message
          if (registerState.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                registerState.errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Back button
                if (registerState.currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: registerState.isLoading
                          ? null
                          : () {
                              registerController.previousPage();
                              pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                      child: const Text('Quay lại'),
                    ),
                  ),
                if (registerState.currentPage > 0) const SizedBox(width: 16),

                // Next/Register button
                Expanded(
                  child: ElevatedButton(
                    onPressed: registerState.isLoading
                        ? null
                        : () async {
                            if (!registerState.canProceedFromPage(registerState.currentPage)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
                              );
                              return;
                            }

                            if (registerState.currentPage < 3) {
                              registerController.nextPage();
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              await registerController.register();
                            }
                          },
                    child: registerState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(registerState.currentPage < 3 ? 'Tiếp tục' : 'Đăng ký'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
