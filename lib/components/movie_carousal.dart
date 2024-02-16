import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'movie_card.dart';
import 'movie_label.dart';

class MovieCarousal extends StatelessWidget {
  final String label;
  final Future fetchData;
  const MovieCarousal({
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
            List dataList = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //label
                MovieLabel(label),
                const SizedBox(height: 10.0),
                // movie list
                CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 175.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                  ),
                  itemCount: dataList.length,
                  itemBuilder: (
                    BuildContext context,
                    int itemIndex,
                    int pageViewIndex,
                  ) {
                    return MovieCard(
                      id: dataList[itemIndex]["id"],
                      imagePath: dataList[itemIndex]["backdrop_path"],
                      aspectRatio: 16 / 9,
                    );
                  },
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
