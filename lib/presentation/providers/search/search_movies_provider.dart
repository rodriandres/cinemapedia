
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  
  final moviesRepository = ref.read( movieRepositoryProvider );
  
  return SearchedMoviesNotifier(
    searchMovies: moviesRepository.searchMovies,
    ref: ref
  );
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {

  SearchMoviesCallback searchMovies;

  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }): super([]);

  Future<List<Movie>> searchMoviesQuery( String query) async {

    final List<Movie> movies = await searchMovies(query);
    ref.read( searchQueryProvider.notifier ).update((state) => query);
    state = movies;
    return state;
  }
}