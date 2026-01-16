import 'package:course/domain/entities/user/gender.dart';
import 'package:course/domain/entities/user/user.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị thông tin user
class ProfileInfoCard extends StatelessWidget {
  final User user;

  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin cá nhân',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Icons.person_outline,
              label: 'Họ tên',
              value: user.fullName,
            ),
            _buildDivider(context),
            _buildInfoRow(context, icon: Icons.email_outlined, label: 'Email', value: user.email),
            if (user.phomeNumber != null) ...[
              _buildDivider(context),
              _buildInfoRow(
                context,
                icon: Icons.phone_outlined,
                label: 'Số điện thoại',
                value: user.phomeNumber!,
              ),
            ],
            _buildDivider(context),
            _buildInfoRow(
              context,
              icon: user.gender == Gender.male ? Icons.male : Icons.female,
              label: 'Giới tính',
              value: user.gender == Gender.male ? 'Nam' : 'Nữ',
            ),
            _buildDivider(context),
            _buildInfoRow(context, icon: Icons.cake_outlined, label: 'Ngày sinh', value: user.dob),
            if (user.address != null) ...[
              _buildDivider(context),
              _buildInfoRow(
                context,
                icon: Icons.location_on_outlined,
                label: 'Địa chỉ',
                value: user.address!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5), height: 1);
  }
}
