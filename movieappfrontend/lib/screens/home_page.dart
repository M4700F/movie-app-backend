import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../widgets/top_app_bar.dart';
import '../screens/movie_details.dart';
import '../screens/popular_movies_list_page.dart'; // Import PopularMoviesListPage
import '../screens/popular_shows_list_page.dart'; // Import PopularShowsListPage
import '../theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _carouselIndex = 0;

  final List<Movie> _trendingMovies = [
    Movie(
      id: '1',
      title: 'Black Panther: Wakanda Forever',
      rating: 7.3,
      image: 'https://image.tmdb.org/t/p/w500/sv1Ig0CYQyB0y0b00000000000000000.jpg', // Placeholder image
    ),
    // Add more trending movies if needed, but for the hero section, we only use the first one
  ];

  final List<Movie> _popularMovies = [ // Renamed from _recommendedMovies
    Movie(
      id: '2',
      title: 'Puss in Boots: The Last Wish',
      rating: 8.4,
      image: 'https://image.tmdb.org/t/p/w500/1NqwE6LP9DuevFpt0aGcYFGyHvS.jpg', // Placeholder image
      genre: 'Animation',
    ),
    Movie(
      id: '3',
      title: 'Knock at the Cabin',
      rating: 6.5,
      image: 'https://image.tmdb.org/t/p/w500/dm06LqNykz6Rz1G4C400000000000000000.jpg', // Placeholder image
      genre: 'Horror',
    ),
    Movie(
      id: '4',
      title: 'Black Panther: Wakanda Forever',
      rating: 7.3,
      image: 'https://image.tmdb.org/t/p/w500/sv1Ig0CYQyB0y0b00000000000000000.jpg', // Placeholder image
      genre: 'Action',
    ),
  ];

  final List<Movie> _popularShows = [ // New list for popular shows
    Movie(
      id: '5',
      title: 'The Last of Us',
      rating: 8.8,
      image: 'https://image.tmdb.org/t/p/w500/bL5fCPd00000000000000000000000000000.jpg', // Placeholder image
      genre: 'Drama',
    ),
    Movie(
      id: '6',
      title: 'House of the Dragon',
      rating: 8.5,
      image: 'https://image.tmdb.org/t/p/w500/xysQ6q00000000000000000000000000000.jpg', // Placeholder image
      genre: 'Fantasy',
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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero Section (Single Featured Movie)
          SizedBox(
            height: 500,
            child: Stack(
              children: [
                Image.network(
                  _trendingMovies[0].image, // Use the first trending movie as featured
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.background.withOpacity(0.6),
                        AppTheme.background,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 80,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _trendingMovies[0].title,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nov 09, 2022', // Example release date from screenshot
                        style: TextStyle(
                          color: AppTheme.mutedForeground,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle play trailer
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Play'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () => _navigateToDetails(_trendingMovies[0]),
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Info'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primary,
                              side: const BorderSide(color: AppTheme.primary),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Popular movies Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular movies',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PopularMoviesListPage(
                              movies: _popularMovies,
                              title: 'Popular Movies',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'see all >',
                        style: TextStyle(color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _popularMovies.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return MovieCard(
                        movie: _popularMovies[index],
                        onTap: () => _navigateToDetails(
                            _popularMovies[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Popular Shows Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Shows',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PopularShowsListPage(
                              shows: _popularShows,
                              title: 'Popular Shows',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'see all >',
                        style: TextStyle(color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _popularShows.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return MovieCard(
                        movie: _popularShows[index],
                        onTap: () => _navigateToDetails(
                            _popularShows[index]),
                      );
                    },
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
