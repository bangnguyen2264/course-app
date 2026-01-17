import 'package:course/app/resources/app_api.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị avatar với fallback icon
class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatar({super.key, this.avatarUrl, this.size = 100, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final url = avatarUrl != null && avatarUrl!.isNotEmpty ? AppApi.baseUrl + avatarUrl! : null;
    debugPrint('Avatar URL: $url'); // Debug print to check the URL
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.primary, width: 3),
            ),
            child: ClipOval(
              child: url != null
                  ? Image.network(
                      url,
                      fit: BoxFit.contain,
                      errorBuilder: (_, error, stackTrace) {
                        debugPrint('Image load error: $error');
                        return _buildPlaceholder(context);
                      },
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildLoading(context);
                      },
                    )
                  : _buildPlaceholder(context),
            ),
          ),
          if (onTap != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                child: Icon(Icons.camera_alt, size: size * 0.2, color: colorScheme.onPrimary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Icon(Icons.person, size: size * 0.5, color: Theme.of(context).colorScheme.primary);
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
