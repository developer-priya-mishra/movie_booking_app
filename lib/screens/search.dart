import 'package:flutter/material.dart';
import 'package:movie_booking_app/services/api_services.dart';

import '../components/movie_info.dart';
import '../services/firestore_services.dart';
import 'movie_detail.dart';

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  List<String> recentQueries = [];

  Future<List<dynamic>> addRecentSearchAndShowResults() async {
    recentQueries = [
      query,
    ];

    Map<String, dynamic>? fields = await FirestoreServices.getCurrentUserData();

    if (fields != null && fields["recent search"] != null) {
      recentQueries.addAll(fields["recent search"]);
    }

    await FirestoreServices.setCurrentUserData(
      {"recent search": recentQueries.toSet()},
    );

    return await ApiServices.searchMovies(query);
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const SizedBox(
        child: Center(
          child: Text("No result"),
        ),
      );
    }

    return FutureBuilder(
      future: addRecentSearchAndShowResults(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List datalist = snapshot.data!;

            return ListView.builder(
              itemCount: datalist.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = datalist[index];

                return MovieInfo(
                  id: item["id"],
                  posterPath: item["poster_path"],
                  title: item["title"],
                  releaseDate: item["release_date"],
                  voteAverage: item["vote_average"].toString(),
                  voteCount: item["vote_count"].toString(),
                  overview: item["overview"],
                );
              },
            );
          } else {
            return const Center(
              child: Text("No result found"),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<void> getRecentSearch() async {
    Map<String, dynamic>? fields = await FirestoreServices.getCurrentUserData();

    if (fields != null && fields["recent search"] != null) {
      recentQueries.clear();
      recentQueries.addAll(fields["recent search"]);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return FutureBuilder(
        future: getRecentSearch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: recentQueries.length,
              itemBuilder: (context, index) {
                String item = recentQueries[index];

                return ListTile(
                  onTap: () {
                    query = item;
                  },
                  leading: const Icon(Icons.history),
                  title: Text(item),
                  trailing: IconButton(
                    onPressed: () {
                      query = item;
                    },
                    icon: const Icon(Icons.north_west),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
    return FutureBuilder(
      future: ApiServices.searchMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List datalist = snapshot.data!;

          return ListView.builder(
            itemCount: datalist.length > 5 ? 5 : datalist.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> item = datalist[index];

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetail(item["id"]),
                    ),
                  );
                },
                leading: const Icon(Icons.search),
                title: Text(item["title"]),
                trailing: IconButton(
                  onPressed: () {
                    query = item["title"];
                  },
                  icon: const Icon(Icons.north_west),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
