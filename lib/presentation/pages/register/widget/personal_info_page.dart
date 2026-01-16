import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:course/presentation/controllers/register/register_controller.dart';
import 'package:course/presentation/pages/register/widget/common_text_field.dart';
import 'package:course/presentation/pages/register/widget/date_of_birth_field.dart';
import 'package:course/domain/entities/user/gender.dart';

class PersonalInfoPage extends HookConsumerWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerControllerProvider);
    final registerController = ref.read(registerControllerProvider.notifier);

    final fullNameController = useTextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Thông tin cá nhân', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Full Name
          CommonTextField(
            controller: fullNameController,
            label: 'Họ và tên',
            icon: Icons.person,
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

          // Date of Birth (3 dropdowns)
          DateOfBirthField(
            initialDate: registerState.dob,
            onChanged: (date) {
              if (date != null) {
                registerController.setDob(date);
              }
            },
          ),
          const SizedBox(height: 16),

          // Gender
          DropdownButtonFormField<Gender>(
            value: registerState.gender,
            decoration: const InputDecoration(
              labelText: 'Giới tính',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            items: Gender.values.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender == Gender.male ? 'Nam' : 'Nữ'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                registerController.setGender(value);
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Vui lòng chọn giới tính';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
