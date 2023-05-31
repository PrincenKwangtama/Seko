class User {
  final String uid;
  final String? email;
  final bool? emailVerified;
  final String? status;
  final String phoneNumber;
  final String profilePicture;

  User({
    required this.uid,
    this.email,
    this.emailVerified,
    this.status = 'user',
    this.phoneNumber = '+621122223333',
    this.profilePicture = 'assets/images/profile.jpg',
  });
}
