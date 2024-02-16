import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../services/api_services.dart';
import '../services/firestore_services.dart';
import 'booking.dart';

class MovieDetail extends StatefulWidget {
  final int id;
  const MovieDetail(this.id, {super.key});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  late MovieModel movie;

  @override
  void initState() {
    super.initState();
    FirestoreServices.setRecentViewed(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ApiServices.movieDetail(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              movie = snapshot.data!;

              return ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: Stack(
                      children: [
                        movie.backdropPath.isEmpty
                            ? Container(
                                color: Colors.grey.shade100,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              )
                            : Opacity(
                                opacity: 0.4,
                                child: Image.network(
                                  "${ApiServices.imageUrl}w780${movie.backdropPath}",
                                ),
                              ),
                        movie.posterPath.isEmpty
                            ? Positioned(
                                bottom: 15.0,
                                left: 15.0,
                                child: Container(
                                  width: 92.0,
                                  height: 138.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              )
                            : Positioned(
                                bottom: 15.0,
                                left: 15.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    "${ApiServices.imageUrl}w92${movie.posterPath}",
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 15.0,
                          right: 15.0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: movie.title,
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (movie.tagline.isNotEmpty)
                                    TextSpan(
                                      text: "\n(${movie.tagline})",
                                    ),
                                ],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: movie.genres.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: RawChip(
                            label: Text(
                              item,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 7.5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Overview",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(movie.overview),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 7.5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "About Movie",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Release Date : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.5,
                                ),
                              ),
                              Text(movie.releaseDate),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Runtime : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.5,
                                ),
                              ),
                              Text(movie.runtime),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Status : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.5,
                                ),
                              ),
                              Text(movie.status),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Original language : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.5,
                                ),
                              ),
                              Text(movie.originalLanguage),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rate,
                                color: Colors.amber,
                                size: 18.0,
                              ),
                              const SizedBox(width: 5.0),
                              Text(movie.voteAverage),
                              const SizedBox(
                                height: 15.0,
                                child: VerticalDivider(),
                              ),
                              const Icon(
                                Icons.thumb_up_alt,
                                color: Colors.amber,
                                size: 18.0,
                              ),
                              const SizedBox(width: 5.0),
                              Text(movie.voteCount),
                              const SizedBox(
                                height: 15.0,
                                child: VerticalDivider(),
                              ),
                              const Icon(
                                Icons.trending_up,
                                color: Colors.amber,
                                size: 18.0,
                              ),
                              const SizedBox(width: 5.0),
                              Text(movie.popularity),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("No Data Found"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        margin: const EdgeInsets.all(15.0),
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Booking(title: movie.title),
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: const Text("Book now"),
        ),
      ),
    );
  }
}
