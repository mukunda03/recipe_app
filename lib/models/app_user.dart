class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final String phone;

  AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'fullName': fullName, 'phone': phone};
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      phone: map['phone'],
    );
  }
}
