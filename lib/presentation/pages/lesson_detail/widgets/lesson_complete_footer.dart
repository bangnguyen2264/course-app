import 'package:course/app/resources/app_color.dart';
import 'package:flutter/material.dart';

class LessonCompleteFooter extends StatelessWidget {
  final VoidCallback? onComplete;
  final String nextLabel;

  const LessonCompleteFooter({super.key, this.onComplete, this.nextLabel = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Complete & Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nextLabel.isEmpty ? 'Next lesson available' : nextLabel,
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 0.5,
              color: AppColor.statisticLabel,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
