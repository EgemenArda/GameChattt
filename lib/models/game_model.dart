class Games {
  String name;
  String genre;

  Games({
    required this.name,
    required this.genre,
  });
  factory Games.fromJson(Map<String, dynamic> json) {
    return Games(
      name: json["name"],
      genre: json["genre"],
    );
  }
}
