import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:signee/screens/homescreen.dart';
import 'package:signee/screens/tabs/bookmarks.dart';
import 'package:signee/screens/tabs/setup.dart';
import 'package:signee/screens/tabs/signatures.dart';

class MainTab extends StatefulWidget {
  const MainTab({super.key});

  @override
  State<MainTab> createState() => MainTabState();
}

class MainTabState extends State<MainTab> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // dynamic body
      body: _buildBody(currentIndex),

      // bottom navigation bar
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.purple[700],
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.list_alt_outlined, title: 'Signatures'),
          TabItem(icon: Icons.favorite_rounded, title: 'Bookmarks'),
          TabItem(icon: Icons.settings, title: 'Setup'),
        ],
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  // build screen
  Widget _buildBody(currentIndex) {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SignaturesScreen();
      case 2:
        return const BookmarsScreen();
      case 3:
        return const SetupScreen();
      default:
        return const HomeScreen();
    }
  }
}
