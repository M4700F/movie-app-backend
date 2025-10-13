import 'package:flutter/material.dart';
import 'package:movieappfrontend/models/movie.dart';
import 'package:movieappfrontend/widgets/movie_card.dart';
import 'package:movieappfrontend/screens/movie_details.dart'; // For navigating to details

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  String? _selectedGenre; // New state variable for selected genre

  // Placeholder data for all movies/shows to search from
  final List<Movie> _allContent = [
    Movie(
      id: '1',
      title: 'Black Panther: Wakanda Forever',
      rating: 7.3,
      image: 'https://image.tmdb.org/t/p/w500/sv1Ig0CYQyB0y0b00000000000000000.jpg',
      genre: 'Action',
    ),
    Movie(
      id: '2',
      title: 'Puss in Boots: The Last Wish',
      rating: 8.4,
      image: 'https://image.tmdb.org/t/p/w500/1NqwE6LP9DuevFpt0aGcYFGyHvS.jpg',
      genre: 'Animation',
    ),
    Movie(
      id: '3',
      title: 'Knock at the Cabin',
      rating: 6.5,
      image: 'https://image.tmdb.org/t/p/w500/dm06LqNykz6Rz1G4C400000000000000000.jpg',
      genre: 'Horror',
    ),
    Movie(
      id: '5',
      title: 'The Last of Us',
      rating: 8.8,
      image: 'https://image.tmdb.org/t/p/w500/bL5fCPd00000000000000000000000000000.jpg',
      genre: 'Drama',
    ),
    Movie(
      id: '6',
      title: 'House of the Dragon',
      rating: 8.5,
      image: 'https://image.tmdb.org/t/p/w500/xysQ6q00000000000000000000000000000.jpg',
      genre: 'Fantasy',
    ),
    Movie(
      id: '7',
      title: 'The Lord of the Rings: The Fellowship of the Ring',
      rating: 8.8,
      image: 'https://image.tmdb.org/t/p/w500/6oom00000000000000000000000000000.jpg',
      genre: 'Fantasy',
    ),
    Movie(
      id: '8',
      title: 'The Lord of the Rings: The Two Towers',
      rating: 8.7,
      image: 'https://image.tmdb.org/t/p/w500/6oom00000000000000000000000000000.jpg',
      genre: 'Fantasy',
    ),
  ];

  // List of available genres for filtering
  final List<String> _genres = ['Action', 'Animation', 'Horror', 'Drama', 'Fantasy', 'Sci-Fi', 'Thriller'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _performSearch(''); // Initial search to show all content
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _performSearch(_searchController.text);
  }

  void _performSearch(String query) {
    setState(() {
      _searchResults = _allContent.where((movie) {
        final titleMatches = movie.title.toLowerCase().contains(query.toLowerCase());
        final genreMatches = _selectedGenre == null || movie.genre == _selectedGenre;
        return titleMatches && genreMatches;
      }).toList();
    });
  }

  void _onGenreSelected(String? genre) {
    setState(() {
      _selectedGenre = genre;
      _performSearch(_searchController.text); // Re-run search with new genre filter
    });
  }

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
        automaticallyImplyLeading: false, // Hide back button
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for movies or shows',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  )
                : null,
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[800],
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          // Genre Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 40, // Height for the horizontal genre chips
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _genres.length + 1, // +1 for "All" filter
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final genre = index == 0 ? 'All' : _genres[index - 1];
                  final isSelected = _selectedGenre == genre || (index == 0 && _selectedGenre == null);
                  return ChoiceChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      _onGenreSelected(selected && genre != 'All' ? genre : null);
                    },
                    selectedColor: Colors.amber,
                    backgroundColor: Colors.grey[800],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(
                    child: Text(
                      'No results found. Try a different search or genre.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.6, // Adjust aspect ratio for movie cards
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = _searchResults[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () => _navigateToDetails(movie),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
