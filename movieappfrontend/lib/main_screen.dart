import 'package:flutter/material.dart';
import 'package:movieappfrontend/screens/home_page.dart';
import 'package:movieappfrontend/screens/search_page.dart';
import 'package:movieappfrontend/screens/shows_screen.dart'; // Import the new ShowsScreen
import 'package:movieappfrontend/screens/watchlist_page.dart'; // Import the new WatchlistScreen
import 'package:movieappfrontend/screens/profile_page.dart'; // Import the ProfilePage

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(), // Movies
    const ShowsScreen(), // Shows
    const SearchPage(), // Search
    const WatchlistPage(), // Watchlist
    const ProfilePage(), // Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Shows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
        backgroundColor: Colors.black, // Dark background for the nav bar
      ),
    );
  }
}
