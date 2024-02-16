import 'package:flutter/material.dart';
import 'package:movie_booking_app/models/movie_model.dart';

import 'movie_card.dart';
import 'movie_label.dart';

class MovieSlider extends StatelessWidget {
  final String label;
  final Future fetchData;
  const MovieSlider({
    super.key,
    required this.label,
    required this.fetchData,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<MovieModel> movieList = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MovieLabel(label),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 175.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5),
                    scrollDirection: Axis.horizontal,
                    itemCount: movieList.length,
                    itemBuilder: (context, index) {
                      MovieModel movie = movieList[index];

                      return MovieCard(
                        id: movie.id,
                        imagePath: movie.posterPath,
                        aspectRatio: 2 / 3,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox(
            height: 238.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
