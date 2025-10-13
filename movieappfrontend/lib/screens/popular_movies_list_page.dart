import 'package:flutter/material.dart';
import 'package:movieappfrontend/models/movie.dart';
import 'package:movieappfrontend/widgets/movie_card.dart';
import 'package:movieappfrontend/screens/movie_details.dart';

class PopularMoviesListPage extends StatelessWidget {
  final List<Movie> movies;
  final String title;

  const PopularMoviesListPage({
    super.key,
    required this.movies,
    required this.title,
  });

  void _navigateToDetails(BuildContext context, Movie movie) {
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
        title: Text(title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () => _navigateToDetails(context, movie),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie.image,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${movie.rating.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 14, color: Colors.amber),
                            ),
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.genre ?? 'Unknown Genre',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', // Placeholder description
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
