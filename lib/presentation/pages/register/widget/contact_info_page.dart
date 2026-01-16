import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:course/presentation/controllers/register/register_controller.dart';
import 'package:course/presentation/pages/register/widget/common_text_field.dart';
import 'package:validators/validators.dart';

class ContactInfoPage extends HookConsumerWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.read(registerControllerProvider.notifier);

    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Thông tin liên hệ', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Email
          CommonTextField(
            controller: emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => registerController.setEmail(value),
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

          // Phone Number
          CommonTextField(
            controller: phoneController,
            label: 'Số điện thoại',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            onChanged: (value) => registerController.setPhoneNumber(value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số điện thoại';
              }
              // Vietnamese phone number validation
              final phoneRegex = RegExp(r'^(0|\+84)[3|5|7|8|9][0-9]{8}$');
              if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
