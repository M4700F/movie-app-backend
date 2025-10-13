import 'package:flutter/material.dart';
import 'package:movieappfrontend/main_screen.dart'; // Import the MainScreen
// import 'package:video_player/video_player.dart'; // Commented out for now

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  // late VideoPlayerController _videoController; // Commented out for now

  @override
  void initState() {
    super.initState();

    // Initialize animation for text and button
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    // // Initialize video player (Commented out for now)
    // _videoController = VideoPlayerController.asset('assets/videos/background_animation.mp4')
    //   ..initialize().then((_) {
    //     _videoController.play();
    //     _videoController.setLooping(true);
    //     _videoController.setVolume(0.0); // Mute the video
    //     if (mounted) {
    //       setState(() {}); // Ensure the first frame is shown
    //     }
    //   });
  }

  @override
  void dispose() {
    _animationController.dispose();
    // _videoController.dispose(); // Commented out for now
    super.dispose();
  }

  void _navigateToMainScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for movie app
      body: Stack(
        children: [
          // // Background video (Commented out for now)
          // SizedBox.expand(
          //   child: FittedBox(
          //     fit: BoxFit.cover,
          //     child: SizedBox(
          //       width: _videoController.value.size.width,
          //       height: _videoController.value.size.height,
          //       child: VideoPlayer(_videoController),
          //     ),
          //   ),
          // ),
          // Overlay content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.movie_filter, // Movie-themed icon
                        size: 100,
                        color: Colors.amber, // Accent color
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome to CineMatch', // Movie app title
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _navigateToMainScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Accent color
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black, // Text color for button
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
