import 'package:flutter/material.dart';

/// Widget loading state cho profile
class ProfileLoadingWidget extends StatelessWidget {
  const ProfileLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
    );
  }
}

/// Widget error state cho profile
class ProfileErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ProfileErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Đã xảy ra lỗi',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
