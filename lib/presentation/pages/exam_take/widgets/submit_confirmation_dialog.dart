import 'package:course/presentation/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class SubmitConfirmationDialog extends StatelessWidget {
  final int unansweredCount;
  final VoidCallback onConfirm;

  const SubmitConfirmationDialog({
    super.key,
    required this.unansweredCount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      status: DialogStatus.confirm,
      title: 'Xác nhận',
      content: unansweredCount > 0
          ? 'Bạn còn $unansweredCount câu hỏi chưa trả lời. Sau khi nộp bài, bạn sẽ không thể thay đổi câu trả lời.'
          : 'Bạn có chắc chắn muốn nộp bài?',
      confirmText: 'Nộp bài',
      cancelText: 'Hủy',
      onConfirm: onConfirm,
      barrierDismissible: true,
    );
  }
}
