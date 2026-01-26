import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashRemover extends StatefulWidget {
  final Widget child;

  const SplashRemover({Key? key, required this.child}) : super(key: key);

  @override
  State<SplashRemover> createState() => _SplashRemoverState();
}

class _SplashRemoverState extends State<SplashRemover> {
  @override
  void initState() {
    super.initState();
    _removeSplash();
  }

  void _removeSplash() {
    // Remove splash sau khi frame đầu tiên được render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
