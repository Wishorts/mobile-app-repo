import 'package:flutter/material.dart';
import 'package:mobile_app/shared/theme/app_color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../auth/login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == 2;
              });
            },
            children: const [
              OnboardingPage(title: "Welcome", subtitle: "Your smart app for modern workflows."),
              OnboardingPage(title: "Organize", subtitle: "Manage your tasks efficiently."),
              OnboardingPage(title: "Achieve", subtitle: "Boost productivity with ease."),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  dotColor: AppColors.primary,
                  activeDotColor: AppColors.background,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              child: Text(_isLastPage ? "Get Started" : "Next"),
              onPressed: () {
                if (_isLastPage) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                } else {
                  _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;

  const OnboardingPage({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
