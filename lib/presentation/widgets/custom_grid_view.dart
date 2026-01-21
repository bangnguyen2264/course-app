import 'package:flutter/material.dart';

/// Widget grid layout chung có thể tùy chỉnh card
/// Dùng cho nhiều màn hình với layout tương tự
class CustomGridView<T> extends StatelessWidget {
  /// Danh sách items để hiển thị
  final List<T> items;

  /// Builder để tạo widget cho mỗi item
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Số cột trong grid
  final int crossAxisCount;

  /// Tỷ lệ chiều rộng/chiều cao của mỗi item
  final double childAspectRatio;

  /// Khoảng cách giữa các item theo chiều ngang
  final double crossAxisSpacing;

  /// Khoảng cách giữa các item theo chiều dọc
  final double mainAxisSpacing;

  /// Padding xung quanh grid
  final EdgeInsetsGeometry? padding;

  /// Widget hiển thị khi đang loading
  final Widget? loadingWidget;

  /// Có đang loading không
  final bool isLoading;

  /// Widget hiển thị khi có lỗi
  final Widget? errorWidget;

  /// Có lỗi không
  final bool hasError;

  /// Widget hiển thị khi danh sách rỗng
  final Widget? emptyWidget;

  /// Widget hiển thị khi đang load thêm (pagination)
  final Widget? loadingMoreWidget;

  /// Có đang load thêm không
  final bool isLoadingMore;

  /// Widget hiển thị ở cuối danh sách (footer)
  final Widget? footer;

  const CustomGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.padding,
    this.loadingWidget,
    this.isLoading = false,
    this.errorWidget,
    this.hasError = false,
    this.emptyWidget,
    this.loadingMoreWidget,
    this.isLoadingMore = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    // Hiển thị loading khi đang tải lần đầu
    if (isLoading && items.isEmpty) {
      return loadingWidget ?? const Center(child: CircularProgressIndicator());
    }

    // Hiển thị error khi có lỗi
    if (hasError && items.isEmpty) {
      return errorWidget ?? const Center(child: Text('Có lỗi xảy ra'));
    }

    // Hiển thị empty khi không có dữ liệu
    if (items.isEmpty) {
      return emptyWidget ?? const Center(child: Text('Không có dữ liệu'));
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Grid items
        SliverPadding(
          padding: padding ?? const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= items.length) return null;
              return itemBuilder(context, items[index], index);
            }, childCount: items.length),
          ),
        ),

        // Loading more indicator
        if (isLoadingMore)
          SliverToBoxAdapter(
            child:
                loadingMoreWidget ??
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
          ),

        // Footer widget
        if (footer != null) SliverToBoxAdapter(child: footer!),
      ],
    );
  }
}
