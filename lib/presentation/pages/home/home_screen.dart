import 'package:flutter/material.dart';
import 'package:course/app/resources/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 100, color: AppColor.primary),
            const SizedBox(height: 24),
            Text(
              'Chào mừng đến với ứng dụng!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColor.titleText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bạn đã đăng nhập thành công',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColor.statisticLabel),
            ),
          ],
        ),
      ),
    );
  }
}
