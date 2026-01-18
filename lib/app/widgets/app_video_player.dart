import 'package:chewie/chewie.dart';
import 'package:course/app/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Enum định nghĩa loại video
enum VideoSourceType {
  youtube,
  network, // Video từ URL trực tiếp (mp4, m3u8, ...)
  embed, // Iframe embed (Vimeo, Dailymotion, ...)
}

/// Widget hiển thị video đa nguồn
class AppVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final double? aspectRatio;

  const AppVideoPlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.looping = false,
    this.aspectRatio,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoSourceType _sourceType;

  // YouTube player
  YoutubePlayerController? _youtubeController;

  // Chewie/VideoPlayer
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  // WebView for embed
  WebViewController? _webViewController;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _youtubeController?.dispose();
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
  }

  /// Xác định loại video từ URL
  VideoSourceType _detectVideoSource(String url) {
    final lowerUrl = url.toLowerCase();

    // YouTube
    if (lowerUrl.contains('youtube.com') || lowerUrl.contains('youtu.be')) {
      return VideoSourceType.youtube;
    }

    // Video trực tiếp (mp4, m3u8, webm, ...)
    if (lowerUrl.endsWith('.mp4') ||
        lowerUrl.endsWith('.m3u8') ||
        lowerUrl.endsWith('.webm') ||
        lowerUrl.endsWith('.mov') ||
        lowerUrl.contains('/video/')) {
      return VideoSourceType.network;
    }

    // Embed (Vimeo, Dailymotion, iframe, ...)
    if (lowerUrl.contains('vimeo.com') ||
        lowerUrl.contains('dailymotion.com') ||
        lowerUrl.contains('embed')) {
      return VideoSourceType.embed;
    }

    // Default: thử network
    return VideoSourceType.network;
  }

  Future<void> _initializePlayer() async {
    try {
      _sourceType = _detectVideoSource(widget.videoUrl);

      switch (_sourceType) {
        case VideoSourceType.youtube:
          _initYoutubePlayer();
          break;
        case VideoSourceType.network:
          await _initNetworkPlayer();
          break;
        case VideoSourceType.embed:
          _initEmbedPlayer();
          break;
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không thể tải video: ${e.toString()}';
        });
      }
    }
  }

  void _initYoutubePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId == null) {
      throw Exception('Invalid YouTube URL');
    }

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        loop: widget.looping,
        mute: false,
        enableCaption: true,
        forceHD: false,
      ),
    );
  }

  Future<void> _initNetworkPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    await _videoPlayerController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      aspectRatio: widget.aspectRatio ?? _videoPlayerController!.value.aspectRatio,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      fullScreenByDefault: false,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      placeholder: Container(color: Colors.black),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.white, size: 42),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void _initEmbedPlayer() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(Uri.parse(widget.videoUrl));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoading();
    }

    if (_errorMessage != null) {
      return _buildError();
    }

    return Container(
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(aspectRatio: widget.aspectRatio ?? 16 / 9, child: _buildPlayer()),
    );
  }

  Widget _buildPlayer() {
    switch (_sourceType) {
      case VideoSourceType.youtube:
        return _buildYoutubePlayer();
      case VideoSourceType.network:
        return _buildChewiePlayer();
      case VideoSourceType.embed:
        return _buildWebViewPlayer();
    }
  }

  Widget _buildYoutubePlayer() {
    if (_youtubeController == null) {
      return _buildError();
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _youtubeController!, showVideoProgressIndicator: true),
      builder: (context, player) => player,
    );
  }

  Widget _buildWebViewPlayer() {
    if (_webViewController == null) {
      return _buildError();
    }

    return WebViewWidget(controller: _webViewController!);
  }

  Widget _buildChewiePlayer() {
    if (_chewieController == null) {
      return _buildError();
    }

    return Chewie(controller: _chewieController!);
  }

  Widget _buildLoading() {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget _buildError() {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white54, size: 48),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Không thể phát video',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _disposeControllers();
                _initializePlayer();
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Thử lại', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
