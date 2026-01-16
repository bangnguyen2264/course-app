import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:course/presentation/controllers/register/register_controller.dart';
import 'package:course/presentation/pages/register/widget/common_text_field.dart';

class AddressInfoPage extends HookConsumerWidget {
  const AddressInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.read(registerControllerProvider.notifier);

    final addressController = useTextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Địa chỉ', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Address
          CommonTextField(
            controller: addressController,
            label: 'Địa chỉ',
            icon: Icons.location_on,
            maxLines: 3,
            onChanged: (value) => registerController.setAddress(value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập địa chỉ';
              }
              if (value.length < 10) {
                return 'Địa chỉ phải có ít nhất 10 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Address hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Vui lòng nhập địa chỉ đầy đủ: số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố',
                    style: TextStyle(color: Colors.amber.shade700, fontSize: 12),
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
