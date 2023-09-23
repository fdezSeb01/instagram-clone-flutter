class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String bio;
  final String username;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        'uid': uid,
        'email': email,
        'photUrl': photoUrl,
        'bio': bio,
        'followers': followers,
        'following': following,
      };
}
