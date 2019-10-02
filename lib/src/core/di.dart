import 'package:fmovies/src/core/api/cinemas_api_service.dart';
import 'package:fmovies/src/core/api/cinemas_api_service_factoy.dart';
import 'package:fmovies/src/core/api/movies_api_service.dart';
import 'package:fmovies/src/core/api/movies_api_service_factory.dart';
import 'package:fmovies/src/core/db/database.dart';
import 'package:fmovies/src/core/utils/network_info.dart';
import 'package:fmovies/src/features/cinemas/data/cinemas_repository.dart';
import 'package:fmovies/src/features/cinemas/data/cinemas_repository_impl.dart';
import 'package:fmovies/src/features/cinemas/domain/cinemas_bloc.dart';
import 'package:fmovies/src/features/favorites/data/favorite_movies_repository.dart';
import 'package:fmovies/src/features/favorites/data/favorite_movies_repository_impl.dart';
import 'package:fmovies/src/features/favorites/domain/favorite_movies_bloc.dart';
import 'package:fmovies/src/features/popular/data/popular_movies_repository.dart';
import 'package:fmovies/src/features/popular/data/popular_movies_repository_impl.dart';
import 'package:fmovies/src/features/popular/domain/popular_movies_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerFactory(() => PopularMoviesBloc(
        popularMoviesRepository: getIt(),
        favoriteMoviesRepository: getIt(),
      ));

  getIt.registerFactory(
      () => FavoriteMoviesBloc(favoriteMoviesRepository: getIt()));

  getIt.registerFactory(() => CinemasBloc(cinemasRepository: getIt()));

  getIt.registerLazySingleton<MoviesDao>(() => AppDatabase().moviesDao);
  getIt.registerLazySingleton<CinemasApiService>(
      () => CinemasApiServiceFactory());

  getIt
      .registerLazySingleton<MoviesApiService>(() => MoviesApiServiceFactory());

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo());

  getIt.registerFactory<PopularMoviesRepository>(
    () => PopularMoviesRepositoryImpl(
      movieApiService: getIt(),
      networkInfo: getIt(),
      moviesDao: getIt(),
    ),
  );

  getIt.registerFactory<CinemasRepository>(
    () => CinemasRepositoryImpl(
      networkInfo: getIt(),
      cinemasApiService: getIt(),
    ),
  );

  getIt.registerFactory<FavoriteMoviesRepository>(
    () => FavoriteMoviesRepositoryImpl(
      moviesDao: getIt(),
    ),
  );
}
