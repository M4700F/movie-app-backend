import 'package:flutter/material.dart';
import 'package:movieappfrontend/models/movie.dart';
import 'package:movieappfrontend/widgets/movie_card.dart';
import 'package:movieappfrontend/theme/app_theme.dart';
import 'package:movieappfrontend/screens/movie_details.dart'; // Import MovieDetailsPage

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  // Placeholder data for different lists
  final List<Movie> _continueWatching = [
    Movie(
      id: '11',
      title: 'The Blacklist',
      rating: 7.6,
      image: 'https://image.tmdb.org/t/p/w500/u3bZgnGQ00000000000000000000000000000.jpg',
      genre: 'Crime',
    ),
    Movie(
      id: '12',
      title: 'NCIS',
      rating: 7.6,
      image: 'https://image.tmdb.org/t/p/w500/xysQ6q00000000000000000000000000000.jpg',
      genre: 'Action',
    ),
  ];

  final List<Movie> _favorites = [
    Movie(
      id: '13',
      title: 'The Last of Us',
      rating: 8.8,
      image: 'https://image.tmdb.org/t/p/w500/bL5fCPd00000000000000000000000000000.jpg',
      genre: 'Drama',
    ),
  ];

  final List<Movie> _watchLater = [
    Movie(
      id: '14',
      title: 'Dune',
      rating: 8.0,
      image: 'https://image.tmdb.org/t/p/w500/d5NXSJFyHTcgdZzY400000000000000000.jpg',
      genre: 'Sci-Fi',
    ),
    Movie(
      id: '15',
      title: 'Interstellar',
      rating: 8.6,
      image: 'https://image.tmdb.org/t/p/w500/g00000000000000000000000000000000.jpg',
      genre: 'Sci-Fi',
    ),
  ];

  void _navigateToDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Continue Watching Section
          _buildSection(
            context,
            title: 'Continue Watching',
            movies: _continueWatching,
          ),
          const SizedBox(height: 32),

          // Favorites Section
          _buildSection(
            context,
            title: 'Favorites',
            movies: _favorites,
          ),
          const SizedBox(height: 32),

          // Watch Later Section
          _buildSection(
            context,
            title: 'Watch Later',
            movies: _watchLater,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Movie> movies}) {
    if (movies.isEmpty) {
      return const SizedBox.shrink(); // Don't show section if empty
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 290, // Height for horizontal movie card list
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                onTap: () => _navigateToDetails(movie),
              );
            },
          ),
        ),
      ],
    );
  }
}
