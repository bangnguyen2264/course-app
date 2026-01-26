import 'package:flutter/material.dart';
import 'package:course/presentation/widgets/custom_dialog.dart';

/// Dialog xác nhận đăng xuất
/// Sử dụng CustomDialog với status confirm
class LogoutConfirmDialog {
  LogoutConfirmDialog._();

  /// Hiển thị dialog xác nhận đăng xuất
  /// Trả về true nếu người dùng xác nhận đăng xuất
  static Future<bool?> show(BuildContext context) {
    return CustomDialog.showConfirm(
      context,
      title: 'Đăng xuất',
      content: 'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?',
      confirmText: 'Đăng xuất',
      cancelText: 'Hủy',
      icon: Icons.logout,
      iconColor: Theme.of(context).colorScheme.error,
    );
  }
}
