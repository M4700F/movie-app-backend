import 'package:flutter/material.dart';
import 'package:movieappfrontend/models/movie.dart'; // Reusing Movie model for shows for now
import 'package:movieappfrontend/widgets/movie_card.dart'; // Reusing MovieCard for shows for now
import 'package:movieappfrontend/screens/movie_details.dart'; // Reusing MovieDetailsPage for shows for now

class PopularShowsListPage extends StatelessWidget {
  final List<Movie> shows; // Renamed from movies to shows
  final String title;

  const PopularShowsListPage({
    super.key,
    required this.shows,
    required this.title,
  });

  void _navigateToDetails(BuildContext context, Movie show) { // Renamed movie to show
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: show), // Pass show as movie
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
        itemCount: shows.length,
        itemBuilder: (context, index) {
          final show = shows[index]; // Renamed movie to show
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () => _navigateToDetails(context, show),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      show.image,
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
                          show.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${show.rating.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 14, color: Colors.amber),
                            ),
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          show.genre ?? 'Unknown Genre',
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
