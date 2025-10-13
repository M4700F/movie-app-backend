import 'package:flutter/material.dart';
import 'package:movieappfrontend/models/movie.dart'; // Reusing Movie model for shows for now
import 'package:movieappfrontend/theme/app_theme.dart';
import 'package:movieappfrontend/widgets/movie_card.dart'; // For similar shows section

class ShowDetailsPage extends StatefulWidget {
  final Movie show; // Renamed from movie to show

  const ShowDetailsPage({super.key, required this.show});

  @override
  State<ShowDetailsPage> createState() => _ShowDetailsPageState();
}

class _ShowDetailsPageState extends State<ShowDetailsPage> {
  bool _showFullStory = false;

  // Placeholder data for cast, reviews, and similar shows
  final List<Map<String, String>> _cast = [
    {'name': 'Pedro Pascal', 'image': 'https://image.tmdb.org/t/p/w200/q7oY00000000000000000000000000000.jpg'},
    {'name': 'Bella Ramsey', 'image': 'https://image.tmdb.org/t/p/w200/q7oY00000000000000000000000000000.jpg'},
  ];

  final List<Map<String, dynamic>> _reviews = [
    {'user': 'TVFanatic', 'handle': '@TVFanatic', 'rating': 4.8, 'text': 'An absolute masterpiece! The acting and storytelling are phenomenal.'},
    {'user': 'ShowCritic', 'handle': '@ShowCritic', 'rating': 4.0, 'text': 'Gripping and intense, but some pacing issues in the middle episodes.'},
  ];

  final List<Movie> _similarShows = [
    Movie(
      id: '9',
      title: 'Game of Thrones',
      rating: 9.0,
      image: 'https://image.tmdb.org/t/p/w500/u3bZgnGQ00000000000000000000000000000.jpg',
      genre: 'Fantasy',
    ),
    Movie(
      id: '10',
      title: 'The Witcher',
      rating: 8.2,
      image: 'https://image.tmdb.org/t/p/w500/xysQ6q00000000000000000000000000000.jpg',
      genre: 'Fantasy',
    ),
  ];

  // Placeholder for episodes
  final List<Map<String, String>> _episodes = [
    {'title': 'Episode 1', 'subtitle': 'When You\'re Lost in the ...', 'date': 'Jan 15, 2023', 'duration': '1h 21m', 'image': 'https://image.tmdb.org/t/p/w200/q7oY00000000000000000000000000000.jpg'},
    {'title': 'Episode 2', 'subtitle': 'Infected', 'date': 'Jan 22, 2023', 'duration': '53m', 'image': 'https://image.tmdb.org/t/p/w200/q7oY00000000000000000000000000000.jpg'},
    {'title': 'Episode 3', 'subtitle': 'Long, Long Time', 'date': 'Jan 29, 2023', 'duration': '1h 17m', 'image': 'https://image.tmdb.org/t/p/w200/q7oY00000000000000000000000000000.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppTheme.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.show.image,
                    fit: BoxFit.cover,
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
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.show.title,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'S1E9', // Example season/episode from screenshot
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground),
                            ),
                            const Text(' • ', style: TextStyle(color: AppTheme.mutedForeground)),
                            Text(
                              widget.show.genre ?? 'Drama', // Example genre
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground),
                            ),
                            const Text(' • ', style: TextStyle(color: AppTheme.mutedForeground)),
                            const Text(
                              '1 Season', // Example duration
                              style: TextStyle(color: AppTheme.mutedForeground),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.show.rating.toStringAsFixed(1)} (2k)', // Example rating from screenshot
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.play_arrow, color: Colors.black),
                                onPressed: () {
                                  // Handle play trailer
                                },
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
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.white),
                onPressed: () {
                  // Handle add to watchlist
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Story Section
                  Text(
                    'Story',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey...', // Placeholder description
                    style: TextStyle(
                      color: AppTheme.mutedForeground,
                      height: 1.5,
                    ),
                    maxLines: _showFullStory ? null : 3,
                    overflow: _showFullStory ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                  if (!_showFullStory)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showFullStory = true;
                        });
                      },
                      child: const Text('Show more', style: TextStyle(color: AppTheme.primary)),
                    ),
                  const SizedBox(height: 24),

                  // Last Episode on Air
                  Text(
                    'Last Episode on Air',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.muted.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _episodes[0]['image']!,
                            width: 100,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _episodes[0]['title']!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${_episodes[0]['subtitle']!} • ${_episodes[0]['date']!} • ${_episodes[0]['duration']!}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Seasons Section
                  Text(
                    'Seasons',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150, // Height for horizontal seasons list
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1, // Placeholder for 1 season
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to Episodes List Page for this season
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _buildEpisodesBottomSheet(context),
                            );
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w200/bL5fCPd00000000000000000000000000000.jpg', // Placeholder season image
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Season 1',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '9 episodes',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cast Section
                  Text(
                    'Cast',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120, // Height for horizontal cast list
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _cast.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final member = _cast[index];
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(member['image']!),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              member['name']!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reviews Section
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150, // Height for horizontal reviews list
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _reviews.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        return Container(
                          width: 250, // Fixed width for review cards
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.muted.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppTheme.primary,
                                    child: Text(review['user']![0], style: const TextStyle(color: Colors.black)),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(review['user']!, style: Theme.of(context).textTheme.titleSmall),
                                      Text(review['handle']!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                review['text']!,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < (review['rating'] as double).floor() ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                    size: 16,
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Similar Shows Section
                  Text(
                    'Similar',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 290, // Reusing the height from MovieCard
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _similarShows.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final show = _similarShows[index];
                        return MovieCard(
                          movie: show, // Reusing MovieCard for shows
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowDetailsPage(show: show),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodesBottomSheet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.mutedForeground,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Episodes',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _episodes.length,
              itemBuilder: (context, index) {
                final episode = _episodes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          episode['image']!,
                          width: 120,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              episode['title']!,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${episode['subtitle']!} • ${episode['date']!} • ${episode['duration']!}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
