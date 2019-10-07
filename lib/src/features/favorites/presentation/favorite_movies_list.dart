import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fmovies/src/core/db/database.dart';
import 'package:fmovies/src/core/utils/image_constants.dart';
import 'package:fmovies/src/core/widgets/blurred_image.dart';
import 'package:fmovies/src/features/favorites/domain/favorite_movies_bloc.dart';
import 'package:fmovies/src/features/favorites/domain/favorite_movies_event.dart';
import 'package:fmovies/src/features/movie/domain/movie_details_bloc.dart';
import 'package:fmovies/src/features/movie/presentation/movie_details.dart';

class FavoriteMoviesList extends StatelessWidget {
  final List<Movie> movies;
  final Movie deletedMovie;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  FavoriteMoviesList(this.movies, this.deletedMovie);

  @override
  Widget build(BuildContext context) {

    if (deletedMovie != null) {
      print('movie is not null -' + deletedMovie.title);
    } else print('movie is null');

    return AnimatedList(
      key: _listKey,
      initialItemCount: movies.length,
      itemBuilder: (context, position, animation) {
        return BuildFavoriteListTile(movies[position], deletedMovie, animation);
      },
    );
  }
}

class BuildFavoriteListTile extends StatelessWidget {
  final Movie movie;
  final Movie deletedMovie;
  final Animation animation;
  
  BuildFavoriteListTile(this.movie, this.deletedMovie, this.animation);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FavoriteMoviesBloc>(context);

    double width = MediaQuery.of(context).size.width;
    double height = width * 0.5;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return BlocProvider(
              builder: (context) => MovieDetailsBloc(),
              child: MovieDetails(movie: movie),
            );
          },
        ),
      ),
      onLongPress: () => bloc.dispatch(DeleteFavoriteMovie(movie: movie)),
      child: SizeTransition(
        sizeFactor: animation,
        child: Container(
          height: height,
          width: width,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BlurredImage(BASE_IMAGE_URL +
                  BACKDROP_SIZES[SIZE_MEDIUM] +
                  movie.backdropPath),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildImage(POSTER_SIZES[SIZE_MEDIUM] + movie.posterPath),
                    Column(
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 170.0,
                            minWidth: 170.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 4.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              movie.releaseDate,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 4.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path == null) {
      return Image.asset('images/placeholder.png');
    } else {
      return FadeInImage.assetNetwork(
        placeholder: 'images/placeholder.png',
        image: BASE_IMAGE_URL + path,
      );
    }
  }
}
