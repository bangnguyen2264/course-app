import 'package:course/app/constants/app_routes.dart';
import 'package:course/presentation/controllers/login/login_controller.dart';
import 'package:course/presentation/controllers/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:validators/validators.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginControllerProvider);
    final loginController = ref.read(loginControllerProvider.notifier);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);

    // Listen to success state
    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next.isSuccess) {
        context.go(AppRoutes.home);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Chào mừng trở lại!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Email field
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!isEmail(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword.value,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword.value ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      obscurePassword.value = !obscurePassword.value;
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 8) {
                    return 'Mật khẩu phải có ít nhất 8 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to forgot password
                  },
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
              const SizedBox(height: 24),

              // Error message
              if (loginState.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    loginState.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),

              // Login button
              ElevatedButton(
                onPressed: loginState.isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          await loginController.login(
                            emailController.text.trim(),
                            passwordController.text,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: loginState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Đăng nhập'),
              ),
              const SizedBox(height: 16),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa có tài khoản?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: const Text('Đăng ký ngay'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
