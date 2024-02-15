import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:signee/screens/home.dart';

class OnboardingScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      titleTextStyle: TextStyle(
        color: Colors.purple[700],
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      subTitleTextStyle: TextStyle(
        color: Colors.purple[400],
      ),
      title: 'Digital Signing',
      subTitle: 'Sign documents digitally with ease',
      imageUrl: 'assets/imgs/sign1.png',
    ),
    Introduction(
      titleTextStyle: TextStyle(
        color: Colors.purple[700],
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      subTitleTextStyle: TextStyle(
        color: Colors.purple[400],
      ),
      title: 'Share and Collaborate',
      subTitle: 'Share and collaborate with others on documents',
      imageUrl: 'assets/imgs/sign2.png',
    ),
    Introduction(
      titleTextStyle: TextStyle(
        color: Colors.purple[700],
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      subTitleTextStyle: TextStyle(
        color: Colors.purple[400],
      ),
      title: 'Access Anywhere',
      subTitle: 'Save and access your digital signatures anywhere, anytime',
      imageUrl: 'assets/imgs/sign1.png',
    ),
  ];

  OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: Colors.white,
      foregroundColor: Colors.purple[700],
      introductionList: list,
      onTapSkipButton: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainTab(),
        ),
        (route) => false,
      ),
      skipTextStyle: TextStyle(
        color: Colors.purple[700],
        fontSize: 18,
      ),
    );
  }
}
