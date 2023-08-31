class CurrentUser {
  String username;
  String image_url;
  String email;
  String fcmToken;

  CurrentUser({
    required this.fcmToken,
    required this.email,
    required this.username,
    required this.image_url,
  });
  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return CurrentUser(
      fcmToken: map["fcmToken"],
      email: map["email"],
      username: map["username"],
      image_url: map["image_url"],
    );
  }
}
