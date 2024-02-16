import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie_model.dart';
import 'firestore_services.dart';

const String movieDbApi = '0a1d6f90acf381243c505dd61101152b';

class ApiServices {
  static String baseUrl = "https://api.themoviedb.org";
  static String imageUrl = "https://image.tmdb.org/t/p/";

  static Future<List<MovieModel>> nowPlayingMovies() async {
    String url = "$baseUrl/3/movie/now_playing?api_key=$movieDbApi";

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        List<dynamic> results = data["results"];

        List<MovieModel> movieList = [];

        for (var item in results) {
          MovieModel movieModel = MovieModel.fromJson(item);
          movieList.add(movieModel);
        }

        return movieList;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<MovieModel>> topRatedMovies() async {
    String url = "$baseUrl/3/movie/top_rated?api_key=$movieDbApi";

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        List<dynamic> results = data["results"];

        List<MovieModel> movieList = [];

        for (var item in results) {
          MovieModel movieModel = MovieModel.fromJson(item);
          movieList.add(movieModel);
        }

        return movieList;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<MovieModel>> popularMovies() async {
    String url = "$baseUrl/3/movie/popular?api_key=$movieDbApi";

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        List<dynamic> results = data["results"];

        List<MovieModel> movieList = [];

        for (var item in results) {
          MovieModel movieModel = MovieModel.fromJson(item);
          movieList.add(movieModel);
        }

        return movieList;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<MovieModel>> upcomingMovies() async {
    String url = "$baseUrl/3/movie/upcoming?api_key=$movieDbApi";

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        List<dynamic> results = data["results"];

        List<MovieModel> movieList = [];

        for (var item in results) {
          MovieModel movieModel = MovieModel.fromJson(item);
          movieList.add(movieModel);
        }

        return movieList;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<MovieModel>> searchMovies(String query) async {
    String url = "$baseUrl/3/search/movie?api_key=$movieDbApi&query=$query";

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        List<dynamic> results = data["results"];

        List<MovieModel> movieList = [];

        for (var item in results) {
          MovieModel movieModel = MovieModel.fromJson(item);
          movieList.add(movieModel);
        }

        return movieList;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<MovieModel> movieDetail(int id) async {
    String url = "$baseUrl/3/movie/$id?api_key=$movieDbApi";

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        MovieModel movieModel = MovieModel.fromJson(data);

        return movieModel;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<MovieModel>> recentViewedMovies() async {
    List<int> recentViewed = [];

    Map<String, dynamic>? fields = await FirestoreServices.getCurrentUserData();

    if (fields != null && fields["recent viewed"] != null) {
      for (int movieId in fields["recent viewed"]) {
        recentViewed.add(movieId);
      }
    }

    // now we have list of movie id in recentViewed, so we will iterate it and get all movie detail from moviedb api
    List<MovieModel> movieInfos = [];

    for (int movieId in recentViewed) {
      MovieModel info = await movieDetail(movieId);
      movieInfos.add(info);
    }

    return movieInfos;
  }
}
