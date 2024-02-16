import 'package:flutter/material.dart';

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
  String movieTitle = "";
  String? backdropPath = "";
  String? posterPath = "";

  Future<void> setRecentViewed() async {
    List recentViewed = [
      widget.id,
    ];

    Map<String, dynamic>? fields = await FirestoreServices.getCurrentUserData();

    if (fields != null && fields["recent viewed"] != null) {
      recentViewed.addAll(fields["recent viewed"]);
    }

    await FirestoreServices.setCurrentUserData(
      {"recent viewed": recentViewed.toSet()},
    );
  }

  @override
  void initState() {
    super.initState();
    setRecentViewed();
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
              List genresList = snapshot.data?["genres"];

              movieTitle = snapshot.data?["title"];
              backdropPath = snapshot.data?["backdrop_path"];
              posterPath = snapshot.data?["poster_path"];

              return ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: Stack(
                      children: [
                        backdropPath == null
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
                                  "${ApiServices.imageUrl}w780$backdropPath",
                                ),
                              ),
                        posterPath == null
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
                                    "${ApiServices.imageUrl}w92$posterPath",
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
                                    text: movieTitle,
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (snapshot.data!["tagline"]
                                      .toString()
                                      .isNotEmpty)
                                    TextSpan(
                                      text: "\n(${snapshot.data?["tagline"]})",
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
                      children: genresList.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: RawChip(
                            label: Text(
                              item["name"],
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
                          Text(
                            snapshot.data?["overview"],
                          ),
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
                              Text(
                                snapshot.data!["release_date"]
                                    .toString()
                                    .split("-")
                                    .reversed
                                    .toList()
                                    .join("-"),
                              ),
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
                              Text(
                                "${snapshot.data?["runtime"] ~/ 60} hrs ${snapshot.data?["runtime"] % 60} min",
                              ),
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
                              Text(snapshot.data?["status"]),
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
                              Text(snapshot.data?["original_language"]),
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
                              Text(snapshot.data!["vote_average"].toString()),
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
                              Text(snapshot.data!["vote_count"].toString()),
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
                              Text(snapshot.data!["popularity"].toString()),
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
              builder: (context) => Booking(title: movieTitle),
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
