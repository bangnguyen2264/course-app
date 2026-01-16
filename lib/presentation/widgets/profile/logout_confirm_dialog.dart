import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Dialog xác nhận đăng xuất
class LogoutConfirmDialog extends StatelessWidget {
  const LogoutConfirmDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(context: context, builder: (_) => const LogoutConfirmDialog());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Icon(Icons.logout, color: colorScheme.error, size: 48),
      title: const Text('Đăng xuất'),
      content: const Text(
        'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        OutlinedButton(
          onPressed: () => context.pop(),
          child: const Text('Hủy'),
          style: OutlinedButton.styleFrom(foregroundColor: colorScheme.primary),
        ),
        ElevatedButton(
          onPressed: () => context.pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.error),
          child: const Text('Đăng xuất'),
        ),
      ],
    );
  }
}
