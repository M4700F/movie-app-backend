import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/search_page.dart';
import '../screens/watchlist_page.dart';
import '../screens/profile_page.dart';
import '../widgets/top_app_bar.dart';
import '../theme/app_theme.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../screens/movie_details.dart';

void main() {
  runApp(const CineMatchApp());
}

class CineMatchApp extends StatelessWidget {
  const CineMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineMatch',
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const WatchlistPage(),
    const ProfilePage(),
  ];

  final List<String> _titles = [
    'CineMatch',
    'Search',
    'Watchlist',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex != 0 ? PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: TopAppBarWidget(
          title: _titles[_currentIndex],
          showSearch: _currentIndex != 1,
          onSearchClick: () {
            setState(() {
              _currentIndex = 1;
            });
          },
        ),
      ) : null,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}