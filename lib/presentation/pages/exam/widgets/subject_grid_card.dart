import 'package:course/app/resources/app_color.dart';
import 'package:course/domain/entities/subject/subject.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị một môn học dạng card trong grid
class SubjectGridCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback? onTap;

  const SubjectGridCard({super.key, required this.subject, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColor.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school_outlined,
                  size: 32,
                  color: AppColor.primary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              // Subject name
              Text(
                subject.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColor.titleText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
