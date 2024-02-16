class MovieModel {
  late String backdropPath;
  late List<String> genres;
  late int id;
  late String originalLanguage;
  late String overview;
  late String popularity;
  late String posterPath;
  late String releaseDate;
  late String runtime;
  late String status;
  late String tagline;
  late String title;
  late String voteAverage;
  late String voteCount;

  MovieModel({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalLanguage,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  MovieModel.fromJson(Map<String, dynamic> data) {
    backdropPath = data['backdrop_path'] ?? "";

    genres = [];
    if (data["genres"] != null) {
      for (var item in data["genres"]) {
        genres.add(item["name"]);
      }
    }

    id = data['id'] ?? 0;

    originalLanguage = "";
    if (data["spoken_languages"] != null) {
      for (var item in data["spoken_languages"]) {
        if (item["iso_639_1"] == data["original_language"]) {
          originalLanguage = item["english_name"];
          break;
        }
      }
    }

    overview = data['overview'] ?? "";

    popularity = "";
    if (data['popularity'] != null) {
      popularity = data['popularity'].toString();
    }

    posterPath = data['poster_path'] ?? "";

    releaseDate = "";
    if (data['release_date'] != null) {
      releaseDate = data['release_date'].split("-").reversed.toList().join("-");
    }

    runtime = "";
    if (data['runtime'] != null) {
      runtime = "${data['runtime'] ~/ 60} hrs ${data['runtime'] % 60} min";
    }

    status = data['status'] ?? "";
    tagline = data['tagline'] ?? "";
    title = data['title'] ?? "";

    voteAverage = "";
    if (data['vote_average'] != null) {
      voteAverage = data['vote_average'].toString();
    }

    voteCount = data['vote_count'] == null ? "" : data['vote_count'].toString();
  }
}
