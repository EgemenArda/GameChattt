class Games {
  String name;
  String image;
  String genre;

  Games({
    required this.image,
    required this.name,
    required this.genre,
  });
  factory Games.fromJson(Map<String, dynamic> json) {
    return Games(
        name: json["name"], genre: json["genre"], image: json["image"]);
  }
}
