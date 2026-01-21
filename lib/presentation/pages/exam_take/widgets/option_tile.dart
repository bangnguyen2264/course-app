import 'package:course/app/resources/app_color.dart';
import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final bool multiple;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.label,
    required this.selected,
    this.multiple = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColor.primary.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColor.primary : Colors.black12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColor.primary : Colors.transparent,
                border: Border.all(color: AppColor.primary, width: 2),
              ),
              child: selected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.titleText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
