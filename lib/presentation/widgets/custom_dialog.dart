import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Enum định nghĩa các loại dialog
enum DialogStatus {
  /// Dialog thông báo lỗi
  error,

  /// Dialog cảnh báo
  alert,

  /// Dialog xác nhận hành động
  confirm,

  /// Dialog thành công
  success,

  /// Dialog thông tin
  info,
}

/// Extension để lấy các thuộc tính mặc định cho mỗi loại dialog
extension DialogStatusExtension on DialogStatus {
  /// Icon mặc định cho mỗi loại dialog
  IconData get defaultIcon {
    switch (this) {
      case DialogStatus.error:
        return Icons.error_outline;
      case DialogStatus.alert:
        return Icons.warning_amber_rounded;
      case DialogStatus.confirm:
        return Icons.help_outline;
      case DialogStatus.success:
        return Icons.check_circle_outline;
      case DialogStatus.info:
        return Icons.info_outline;
    }
  }

  /// Màu mặc định cho mỗi loại dialog
  Color getColor(ColorScheme colorScheme) {
    switch (this) {
      case DialogStatus.error:
        return colorScheme.error;
      case DialogStatus.alert:
        return Colors.orange;
      case DialogStatus.confirm:
        return colorScheme.primary;
      case DialogStatus.success:
        return Colors.green;
      case DialogStatus.info:
        return colorScheme.primary;
    }
  }

  /// Text nút xác nhận mặc định
  String get defaultConfirmText {
    switch (this) {
      case DialogStatus.error:
        return 'Đóng';
      case DialogStatus.alert:
        return 'Đã hiểu';
      case DialogStatus.confirm:
        return 'Xác nhận';
      case DialogStatus.success:
        return 'OK';
      case DialogStatus.info:
        return 'OK';
    }
  }

  /// Có hiển thị nút hủy hay không
  bool get showCancelButton {
    switch (this) {
      case DialogStatus.error:
        return false;
      case DialogStatus.alert:
        return false;
      case DialogStatus.confirm:
        return true;
      case DialogStatus.success:
        return false;
      case DialogStatus.info:
        return false;
    }
  }
}

/// Custom Dialog widget hỗ trợ nhiều trường hợp sử dụng
class CustomDialog extends StatelessWidget {
  /// Loại dialog
  final DialogStatus status;

  /// Tiêu đề dialog
  final String title;

  /// Nội dung dialog
  final String content;

  /// Icon tùy chỉnh (nếu null sẽ dùng icon mặc định theo status)
  final IconData? icon;

  /// Màu icon tùy chỉnh (nếu null sẽ dùng màu mặc định theo status)
  final Color? iconColor;

  /// Text nút xác nhận
  final String? confirmText;

  /// Text nút hủy
  final String cancelText;

  /// Có hiển thị nút hủy hay không
  final bool? showCancel;

  /// Callback khi nhấn xác nhận
  final VoidCallback? onConfirm;

  /// Có thể đóng dialog bằng cách nhấn bên ngoài không
  final bool barrierDismissible;

  const CustomDialog({
    super.key,
    required this.status,
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
    this.confirmText,
    this.cancelText = 'Hủy',
    this.showCancel,
    this.onConfirm,
    this.barrierDismissible = true,
  });

  /// Hiển thị dialog và trả về kết quả
  static Future<bool?> show(
    BuildContext context, {
    required DialogStatus status,
    required String title,
    required String content,
    IconData? icon,
    Color? iconColor,
    String? confirmText,
    String cancelText = 'Hủy',
    bool? showCancel,
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomDialog(
        status: status,
        title: title,
        content: content,
        icon: icon,
        iconColor: iconColor,
        confirmText: confirmText,
        cancelText: cancelText,
        showCancel: showCancel,
        onConfirm: onConfirm,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// Shortcut cho dialog lỗi
  static Future<bool?> showError(
    BuildContext context, {
    String title = 'Lỗi',
    required String content,
    String? confirmText,
  }) {
    return show(
      context,
      status: DialogStatus.error,
      title: title,
      content: content,
      confirmText: confirmText,
      barrierDismissible: false,
    );
  }

  /// Shortcut cho dialog cảnh báo
  static Future<bool?> showAlert(
    BuildContext context, {
    String title = 'Cảnh báo',
    required String content,
    String? confirmText,
  }) {
    return show(
      context,
      status: DialogStatus.alert,
      title: title,
      content: content,
      confirmText: confirmText,
    );
  }

  /// Shortcut cho dialog xác nhận
  static Future<bool?> showConfirm(
    BuildContext context, {
    String title = 'Xác nhận',
    required String content,
    String? confirmText,
    String cancelText = 'Hủy',
    IconData? icon,
    Color? iconColor,
  }) {
    return show(
      context,
      status: DialogStatus.confirm,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      showCancel: true,
      icon: icon,
      iconColor: iconColor,
    );
  }

  /// Shortcut cho dialog thành công
  static Future<bool?> showSuccess(
    BuildContext context, {
    String title = 'Thành công',
    required String content,
    String? confirmText,
  }) {
    return show(
      context,
      status: DialogStatus.success,
      title: title,
      content: content,
      confirmText: confirmText,
    );
  }

  /// Shortcut cho dialog thông tin
  static Future<bool?> showInfo(
    BuildContext context, {
    String title = 'Thông báo',
    required String content,
    String? confirmText,
  }) {
    return show(
      context,
      status: DialogStatus.info,
      title: title,
      content: content,
      confirmText: confirmText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dialogTheme = theme.extension<CustomDialogTheme>();

    // Xác định các giá trị hiển thị
    final displayIcon = icon ?? status.defaultIcon;
    final displayIconColor = iconColor ?? status.getColor(colorScheme);
    final displayConfirmText = confirmText ?? status.defaultConfirmText;
    final displayShowCancel = showCancel ?? status.showCancelButton;

    // Lấy style từ theme extension hoặc dùng mặc định
    final iconSize = dialogTheme?.iconSize ?? 48.0;
    final titleStyle = dialogTheme?.titleStyle ?? theme.textTheme.titleLarge;
    final contentStyle = dialogTheme?.contentStyle ?? theme.textTheme.bodyMedium;

    return AlertDialog(
      icon: Icon(displayIcon, color: displayIconColor, size: iconSize),
      title: Text(title, style: titleStyle?.copyWith(fontWeight: FontWeight.w600)),
      content: Text(content, textAlign: TextAlign.center, style: contentStyle),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        if (displayShowCancel)
          OutlinedButton(
            onPressed: () {
              context.pop(false);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              side: BorderSide(color: colorScheme.primary),
            ),
            child: Text(cancelText),
          ),
        ElevatedButton(
          onPressed: () {
            onConfirm?.call();
            context.pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: displayIconColor,
            foregroundColor: Colors.white,
          ),
          child: Text(displayConfirmText),
        ),
      ],
    );
  }
}

/// Theme extension cho CustomDialog
class CustomDialogTheme extends ThemeExtension<CustomDialogTheme> {
  final double? iconSize;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final double? elevation;
  final ShapeBorder? shape;

  const CustomDialogTheme({
    this.iconSize,
    this.titleStyle,
    this.contentStyle,
    this.contentPadding,
    this.actionsPadding,
    this.elevation,
    this.shape,
  });

  @override
  CustomDialogTheme copyWith({
    double? iconSize,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return CustomDialogTheme(
      iconSize: iconSize ?? this.iconSize,
      titleStyle: titleStyle ?? this.titleStyle,
      contentStyle: contentStyle ?? this.contentStyle,
      contentPadding: contentPadding ?? this.contentPadding,
      actionsPadding: actionsPadding ?? this.actionsPadding,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
    );
  }

  @override
  CustomDialogTheme lerp(ThemeExtension<CustomDialogTheme>? other, double t) {
    if (other is! CustomDialogTheme) {
      return this;
    }
    return CustomDialogTheme(
      iconSize: t < 0.5 ? iconSize : other.iconSize,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      contentStyle: TextStyle.lerp(contentStyle, other.contentStyle, t),
      contentPadding: EdgeInsetsGeometry.lerp(contentPadding, other.contentPadding, t),
      actionsPadding: EdgeInsetsGeometry.lerp(actionsPadding, other.actionsPadding, t),
      elevation: t < 0.5 ? elevation : other.elevation,
      shape: t < 0.5 ? shape : other.shape,
    );
  }
}
