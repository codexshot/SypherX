import 'dart:convert';

class ConnectedGroupModel {
  final String roomId;
  final String roomName;
  final String roomImage;
  ConnectedGroupModel({
    required this.roomId,
    required this.roomName,
    required this.roomImage,
  });

  ConnectedGroupModel copyWith({
    String? roomId,
    String? roomName,
    String? roomImage,
  }) {
    return ConnectedGroupModel(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      roomImage: roomImage ?? this.roomImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'roomImage': roomImage,
    };
  }

  factory ConnectedGroupModel.fromMap(Map<String, dynamic> map) {
    return ConnectedGroupModel(
      roomId: map['roomId'] ?? '',
      roomName: map['roomName'] ?? '',
      roomImage: map['roomImage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConnectedGroupModel.fromJson(String source) => ConnectedGroupModel.fromMap(json.decode(source));

  @override
  String toString() => 'ConnectGroupModel(roomId: $roomId, roomName: $roomName, roomImage: $roomImage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConnectedGroupModel && other.roomId == roomId && other.roomName == roomName && other.roomImage == roomImage;
  }

  @override
  int get hashCode => roomId.hashCode ^ roomName.hashCode ^ roomImage.hashCode;
}
