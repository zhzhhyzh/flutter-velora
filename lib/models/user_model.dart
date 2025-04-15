class UserModel {
  final String uid;
  final String email;
  final String name;
  final String headline;
  final String about;
  final String profileImageUrl;
  final List<String> connections;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.headline = '',
    this.about = '',
    this.profileImageUrl = '',
    this.connections = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      headline: data['headline'] ?? '',
      about: data['about'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      connections: List<String>.from(data['connections'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'headline': headline,
      'about': about,
      'profileImageUrl': profileImageUrl,
      'connections': connections,
    };
  }
}
