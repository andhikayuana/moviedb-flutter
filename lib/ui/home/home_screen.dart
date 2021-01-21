import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:moviedb_flutter/data/model/movie.dart';
import 'package:moviedb_flutter/data/repository/movie_repository.dart';
import 'package:moviedb_flutter/exception/movie_exception.dart';

final moviesFutureProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;

  final movieRepository = ref.read(movieRepositoryProvider);
  final movies = await movieRepository.getMovies();

  return movies;
});

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("MovieDB Micron"),
      ),
      body: watch(moviesFutureProvider).when(
          data: (movies) {
            return RefreshIndicator(
              onRefresh: () {
                return context.refresh(moviesFutureProvider);
              },
              child: GridView.extent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
                children: movies
                    .map((movie) => _MovieBox(
                          movie: movie,
                        ))
                    .toList(),
              ),
            );
          },
          loading: () => Center(
                child: CircularProgressIndicator(),
              ),
          error: (e, s) {
            if (e is MovieException) {
              return _ErrorBody(message: e.message);
            }
            return _ErrorBody(message: "oops, something went wrong!");
          }),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;

  const _ErrorBody({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context.refresh(moviesFutureProvider),
            child: Text("Try again"),
          )
        ],
      ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  final Movie movie;

  const _MovieBox({
    Key key,
    this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          movie.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          child: _FrontBanner(text: movie.title),
          bottom: 0,
          left: 0,
          right: 0,
        )
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  final String text;

  const _FrontBanner({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          height: 60,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
