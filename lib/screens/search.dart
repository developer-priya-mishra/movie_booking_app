import 'package:flutter/material.dart';
import 'package:movie_booking_app/models/movie_model.dart';
import 'package:movie_booking_app/services/api_services.dart';

import '../components/movie_card.dart';
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
      future: FirestoreServices.setRecentSearch(query).then(
        (value) => ApiServices.searchMovies(query),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<MovieModel> movieList = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 10,
              ),
              itemCount: movieList.length,
              itemBuilder: (context, index) {
                MovieModel movie = movieList[index];

                return MovieCard(
                  id: movie.id,
                  imagePath: movie.posterPath,
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

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return FutureBuilder(
        future: FirestoreServices.getRecentSearch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List datalist = snapshot.data!;

              return ListView.builder(
                itemCount: datalist.length,
                itemBuilder: (context, index) {
                  String item = datalist[index];

                  return ListTile(
                    onTap: () {
                      query = item;
                    },
                    leading: const Icon(Icons.history),
                    title: Text(item),
                    contentPadding: const EdgeInsets.only(left: 16.0),
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
                child: Text("Type to search movies"),
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
    return FutureBuilder(
      future: ApiServices.searchMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<MovieModel> movieList = snapshot.data!;

          return ListView.builder(
            itemCount: movieList.length > 5 ? 5 : movieList.length,
            itemBuilder: (context, index) {
              MovieModel movie = movieList[index];

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetail(movie.id),
                    ),
                  );
                },
                leading: const Icon(Icons.search),
                title: Text(movie.title),
                contentPadding: const EdgeInsets.only(left: 16.0),
                trailing: IconButton(
                  onPressed: () {
                    query = movie.title;
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
