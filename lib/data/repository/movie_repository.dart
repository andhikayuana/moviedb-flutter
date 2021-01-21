import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_flutter/environment_config.dart';
import 'package:moviedb_flutter/exception/movie_exception.dart';
import '../model/movie.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final config = ref.read(environmentConfigProvider);

  return MovieRepository(
    envConfig: config,
    dio: Dio(),
  );
});

class MovieRepository {
  final EnvironmentConfig envConfig;
  final Dio dio;

  MovieRepository({this.envConfig, this.dio});

  Future<List<Movie>> getMovies({int page: 1}) async {
    try {
      final response = await dio.get(
          "https://api.themoviedb.org/3/movie/popular?api_key=${envConfig.moviedbApiKey}&language=en-US&page=${page}");

      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<Movie> movies =
          results.map((movie) => Movie.fromMap(movie)).toList(growable: false);
      return movies;
    } on DioError catch (e) {
      throw MovieException.fromDio(e);
    }
  }
}
