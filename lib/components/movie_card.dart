import 'package:flutter/material.dart';

import '../screens/movie_detail.dart';
import '../services/api_services.dart';

class MovieCard extends StatelessWidget {
  final int id;
  final String? imagePath;
  final double aspectRatio;
  const MovieCard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.aspectRatio,
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: imagePath == null
              ? const Center(
                  child: Icon(
                    Icons.broken_image,
                  ),
                )
              : ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  child: Image.network(
                    "${ApiServices.imageUrl}w780$imagePath",
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}