import 'dart:math';

class User {
  String id;
  String username;
  String fullname;
  String email;
  String password;
  String? uid;

  User({
    this.id = '',
    required this.username,
    required this.fullname,
    required this.email,
    required this.password,
    this.uid,
  });

  User.withoutPassword({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    this.password = '',
    this.uid,
  });

  void setUid(String uid) {
    this.uid = uid;
  }

  String toStringMap() {
    return """
    {
      "id": \"$id\",
      "username": \"$username\",
      "fullname": \"$fullname\",
      "email": \"$email\",
      "uid": \"$uid\"
    }""";
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'fullname': fullname,
      'email': email,
      'uid': uid
    };
  }

  Map<String, dynamic> toFirestoreRestMap() {
    return {
      'fields': {
        'username': {
          'stringValue': username,
        },
        'fullname': {'stringValue': fullname},
        'email': {'stringValue': email},
        'uid': {'stringValue': uid}
      }
    };
  }

  factory User.fromMap(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;
    return User.withoutPassword(
        id: json['name'].split('/').last,
        username: fields['username']['stringValue'] as String,
        fullname: fields['fullname']['stringValue'] as String,
        email: fields['email']['stringValue'] as String,
        uid: fields['uid']['stringValue'] as String);
  }

  factory User.fromFirebaseMap(Map<String, dynamic> json) {
    return User.withoutPassword(
        id: json['uid'],
        username: json['username'],
        fullname: json['fullname'],
        email: json['email'],
        uid: json['uid']);
  }
}
