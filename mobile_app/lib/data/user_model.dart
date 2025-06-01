class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final int age;
  final String email;
  final String username;
  final String photoUrl;
  final String mobileNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.username,
    required this.photoUrl,
    required this.mobileNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.empty() {
    return UserModel(
      userId: '',
      firstName: '',
      lastName: '',
      age: 0,
      email: '',
      username: '',
      photoUrl: '',
      mobileNumber: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      age: json['age'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
