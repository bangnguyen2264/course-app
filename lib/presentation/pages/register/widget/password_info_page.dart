import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:course/presentation/controllers/register/register_controller.dart';
import 'package:course/presentation/pages/register/widget/common_text_field.dart';

class PasswordInfoPage extends HookConsumerWidget {
  const PasswordInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.read(registerControllerProvider.notifier);

    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Mật khẩu', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Password
          CommonTextField(
            controller: passwordController,
            label: 'Mật khẩu',
            icon: Icons.lock,
            obscureText: obscurePassword.value,
            onChanged: (value) => registerController.setPassword(value),
            suffixIcon: IconButton(
              icon: Icon(obscurePassword.value ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                obscurePassword.value = !obscurePassword.value;
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              // Optional: Add more password strength validation
              if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                return 'Mật khẩu phải có cả chữ và số';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password
          CommonTextField(
            controller: confirmPasswordController,
            label: 'Xác nhận mật khẩu',
            icon: Icons.lock_outline,
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
          const SizedBox(height: 16),

          // Password hints
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mật khẩu phải:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                ),
                const SizedBox(height: 4),
                Text('• Có ít nhất 6 ký tự', style: TextStyle(color: Colors.blue.shade700)),
                Text('• Bao gồm cả chữ và số', style: TextStyle(color: Colors.blue.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
