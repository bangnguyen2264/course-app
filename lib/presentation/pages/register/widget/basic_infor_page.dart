import 'package:course/presentation/widgets/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:course/presentation/controllers/register/register_controller.dart';

class BasicInfoPage extends HookConsumerWidget {
  const BasicInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.read(registerControllerProvider.notifier);
    
    final fullNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Thông tin cơ bản',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          
          // Full Name
          CommonTextField(
            controller: fullNameController,
            label: 'Họ và tên',
            prefixIcon: Icons.person,
            onChanged: (value) => registerController.setFullName(value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ tên';
              }
              if (value.length < 2) {
                return 'Họ tên phải có ít nhất 2 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Email
          CommonTextField(
            controller: emailController,
            label: 'Email',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => registerController.setEmail(value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Password
          CommonTextField(
            controller: passwordController,
            label: 'Mật khẩu',
            prefixIcon: Icons.lock,
            obscureText: obscurePassword.value,
            suffixIcon: IconButton(
              icon: Icon(obscurePassword.value ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                obscurePassword.value = !obscurePassword.value;
              },
            ),
            onChanged: (value) => registerController.setPassword(value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Confirm Password
          CommonTextField(
            controller: confirmPasswordController,
            label: 'Xác nhận mật khẩu',
            prefixIcon: Icons.lock_outline,
            obscureText: obscureConfirmPassword.value,
            suffixIcon: IconButton(
              icon: Icon(obscureConfirmPassword.value ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                obscureConfirmPassword.value = !obscureConfirmPassword.value;
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng xác nhận mật khẩu';
              }
              if (value != passwordController.text) {
                return 'Mật khẩu không khớp';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}