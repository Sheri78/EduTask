class AppUser {
  final String uid;
  final String email;
  final String? name;
  final String? phone;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      phone: map['phone'],
    );
  }

  AppUser copyWith({
    String? name,
    String? phone,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}