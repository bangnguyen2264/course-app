import 'package:flutter/material.dart';

/// Widget hiển thị ảnh từ URL với placeholder và error handling
class AppImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    Widget imageWidget = Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoading(loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildError();
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: borderRadius),
          child: const Icon(Icons.image_outlined, color: Colors.grey, size: 48),
        );
  }

  Widget _buildLoading(ImageChunkEvent loadingProgress) {
    final progress = loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
        : null;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: borderRadius),
      child: Center(child: CircularProgressIndicator(value: progress, strokeWidth: 2)),
    );
  }

  Widget _buildError() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: borderRadius),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, color: Colors.grey, size: 48),
          SizedBox(height: 8),
          Text('Không thể tải ảnh', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
