import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

class Movie {
  final int id;
  final String title;
  final String posterUrl;

  Movie({required this.id, required this.title, required this.posterUrl});
}

class Api {
  final String apiKey = 'b944d6eba2d3f434fdb9d98457345ae8';
  final String baseUrl = 'https://api.themoviedb.org/3/search/movie';
  final String posterBaseUrl = 'https://image.tmdb.org/t/p/w780';

  Future<List<Movie>> getMovies(int page) async {
    final response = await http.get(Uri.parse(
      '$baseUrl?api_key=$apiKey&page=$page&query=naran',)
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      return results
          .map((movieData) => Movie(
        id: movieData['id'],
        title: movieData['title'],
        posterUrl: '$posterBaseUrl${movieData['poster_path']}',
      ))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MovieGrid(),
//     );
//   }
// }

class MovieGrid extends StatefulWidget {
  @override
  _MovieGridState createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  final Api api = Api();
  final ScrollController _scrollController = ScrollController();
  List<Movie> movies = [];
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMoreMovies();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreMovies();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreMovies() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      try {
        final List<Movie> newMovies = await api.getMovies(page);
        setState(() {
          movies.addAll(newMovies);
          page++;
        });
      } catch (e) {
        print('Error loading movies: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Posters'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: movies.length + 1, // +1 for the loading indicator
        itemBuilder: (context, index) {
          print(movies.length);
          if (index < movies.length) {
            return MovieTile(movie: movies[index]);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        controller: _scrollController,
      ),
    );
  }
}

class MovieTile extends StatelessWidget {
  final Movie movie;

  MovieTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie.title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
