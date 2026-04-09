class UserProfileModel {
  final String uid;
  final String name;
  final String image;
  final int shortId;
  final bool isVerified;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.image,
    required this.shortId,
    this.isVerified = false,
  });

  factory UserProfileModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserProfileModel(
      uid: id,
      name: data['name'] ?? 'User',
      image: data['userimage'] ?? '',
      shortId: data['shortId'] ?? 0,
      isVerified: data['isVerified'] ?? false,
    );
  }
}
