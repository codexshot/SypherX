import 'dart:convert';




class UserShortInfo {

  final String uid;


  final String fullName;


  final String username;


  final String? profileImageUrl;

  UserShortInfo({
    required this.uid,
    required this.fullName,
    required this.username,
    required this.profileImageUrl,
  });

  UserShortInfo copyWith({
    String? uid,
    String? fullName,
    String? username,
    String? profileImageUrl,
  }) {
    return UserShortInfo(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'full_name': fullName,
      'username': username,
      'profile_image_url': profileImageUrl,
    };
  }

  factory UserShortInfo.fromMap(Map<String, dynamic> map) {
    return UserShortInfo(
      uid: map['uid'] ?? '',
      fullName: map["full_name"] ?? '',
      username: map['username'] ?? '',
      profileImageUrl: map['profile_image_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserShortInfo.fromJson(String source) => UserShortInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserShortInfo(uid: $uid, fullName: $fullName, username: $username, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserShortInfo &&
        other.uid == uid &&
        other.fullName == fullName &&
        other.username == username &&
        other.profileImageUrl == profileImageUrl;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ fullName.hashCode ^ username.hashCode ^ profileImageUrl.hashCode;
  }
}
