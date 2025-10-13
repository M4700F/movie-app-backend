import 'package:flutter/material.dart';
import 'package:movieappfrontend/models/movie.dart'; // For MovieCard
import 'package:movieappfrontend/widgets/movie_card.dart'; // For My Recent Ratings
import 'package:movieappfrontend/theme/app_theme.dart'; // For theme control
import 'package:movieappfrontend/main.dart'; // Import themeNotifier

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Placeholder data for profile sections
  final int _moviesWatched = 127;
  final int _hoursStreamed = 342;
  final int _favorites = 45;
  final int _myRatingsCount = 32;

  final List<Movie> _recentRatings = [
    Movie(
      id: '1',
      title: 'Quantum Nexus',
      rating: 5.0,
      image: 'https://images.unsplash.com/photo-1644772715611-0d1f77c10e36?w=400',
    ),
    Movie(
      id: '2',
      title: 'Dark Memories',
      rating: 5.0,
      image: 'https://images.unsplash.com/photo-1558877025-102791db823f?w=400',
    ),
    Movie(
      id: '3',
      title: 'Love in Paris',
      rating: 4.0,
      image: 'https://images.unsplash.com/photo-1627964464837-6328f5931576?w=400',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top Overview Section
          Row(
            children: [
              _buildOverviewCard('Movies Watched', _moviesWatched.toString(), Colors.deepPurple),
              const SizedBox(width: 16),
              _buildOverviewCard('Hours Streamed', _hoursStreamed.toString(), Colors.orange),
              const SizedBox(width: 16),
              _buildOverviewCard('Favorites', _favorites.toString(), Colors.pink),
            ],
          ),
          const SizedBox(height: 32),

          // My Recent Ratings Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Recent Ratings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to My Ratings List Page
                },
                child: const Text(
                  'See All',
                  style: TextStyle(color: AppTheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 290, // Height for horizontal movie card list
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recentRatings.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final movie = _recentRatings[index];
                return MovieCard(
                  movie: movie,
                  onTap: () {
                    // Navigate to movie details
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // Action List Items
          _buildActionListItem(
            icon: Icons.settings,
            title: 'Account Settings',
            onTap: () {
              // Navigate to Account Settings
            },
          ),
          const SizedBox(height: 16),
          _buildActionListItem(
            icon: Icons.star_outline,
            title: 'My Ratings',
            trailingText: _myRatingsCount.toString(),
            onTap: () {
              // Navigate to My Ratings
            },
          ),
          const SizedBox(height: 16),
          _buildActionListItem(
            icon: Icons.history,
            title: 'Viewing History',
            onTap: () {
              // Navigate to Viewing History
            },
          ),
          const SizedBox(height: 16),
          _buildActionListItem(
            icon: Icons.reviews_outlined,
            title: 'My Reviews',
            onTap: () {
              // Navigate to My Reviews
            },
          ),
          const SizedBox(height: 16),
          _buildActionListItem(
            icon: Icons.reviews_outlined,
            title: 'My Reviews',
            onTap: () {
              // Navigate to My Reviews
            },
          ),
          const SizedBox(height: 16),
          _buildActionListItem(
            icon: themeNotifier.value == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            title: 'Dark/Light Theme',
            trailingWidget: Switch(
              value: themeNotifier.value == ThemeMode.dark,
              onChanged: (value) {
                themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              },
              activeColor: AppTheme.primary,
            ),
            onTap: () {
              themeNotifier.value = themeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.muted.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionListItem({
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? trailingWidget,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.muted.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            if (trailingText != null)
              Text(
                trailingText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground),
              ),
            if (trailingWidget != null) trailingWidget,
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.mutedForeground),
          ],
        ),
      ),
    );
  }
}
