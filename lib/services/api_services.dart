import 'dart:convert';

import 'package:http/http.dart' as http;

import 'firestore_services.dart';

const String movieDbApi = '0a1d6f90acf381243c505dd61101152b';

class ApiServices {
  static String baseUrl = "https://api.themoviedb.org";
  static String imageUrl = "https://image.tmdb.org/t/p/";

  static Future<List<dynamic>> nowPlayingMovies() async {
    String url = "$baseUrl/3/movie/now_playing?api_key=$movieDbApi";
    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> results = data["results"];
        return results;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<dynamic>> topRatedMovies() async {
    String url = "$baseUrl/3/movie/top_rated?api_key=$movieDbApi";
    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        List<dynamic> results = data["results"];

        return results;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<dynamic>> popularMovies() async {
    String url = "$baseUrl/3/movie/popular?api_key=$movieDbApi";

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> results = data["results"];
        return results;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<dynamic>> upcomingMovies() async {
    String url = "$baseUrl/3/movie/upcoming?api_key=$movieDbApi";
    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> results = data["results"];
        return results;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<dynamic>> searchMovies(String query) async {
    String url = "$baseUrl/3/search/movie?api_key=$movieDbApi&query=$query";

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> results = data["results"];
        return results;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> movieDetail(int id) async {
    String url = "$baseUrl/3/movie/$id?api_key=$movieDbApi";

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw "Something went wrong!";
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> recentViewedMovies() async {
    List<int> recentViewed = [];

    Map<String, dynamic>? fields = await FirestoreServices.getCurrentUserData();

    if (fields != null && fields["recent viewed"] != null) {
      for (int movieId in fields["recent viewed"]) {
        recentViewed.add(movieId);
      }
    }

    // now we have list of movie id in recentViewed, so we will iterate it and get all movie detail from moviedb api
    List<Map<String, dynamic>> movieInfos = [];

    for (int movieId in recentViewed) {
      Map<String, dynamic> info = await movieDetail(movieId);
      movieInfos.add(info);
    }

    return movieInfos;
  }
}
