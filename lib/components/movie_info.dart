import 'package:flutter/material.dart';

import '../screens/movie_detail.dart';
import '../services/api_services.dart';

class MovieInfo extends StatelessWidget {
  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String voteAverage;
  final String voteCount;
  final String overview;

  const MovieInfo({
    super.key,
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetail(id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 7.5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              posterPath == null
                  ? Container(
                      width: 92.0,
                      height: 138.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey.shade700,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        '${ApiServices.imageUrl}w92$posterPath',
                      ),
                    ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      releaseDate.split("-")[0],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rate,
                          color: Colors.amber,
                          size: 18.0,
                        ),
                        const SizedBox(width: 5.0),
                        Text(voteAverage),
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
                        Text(voteCount),
                      ],
                    ),
                    Text(
                      overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
}
