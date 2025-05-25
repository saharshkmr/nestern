import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String id;
  final String type;
  final String content;
  final String senderId;
  final String recipientId;
  final DateTime timestamp;
  final bool isRead;

  Notification({
    required this.id,
    required this.type,
    required this.content,
    required this.senderId,
    required this.recipientId,
    required this.timestamp,
    this.isRead = false,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? '', // Add null checks
      type: json['type'] ?? '', // Add null checks
      content: json['content'] ?? '', // Add null checks
      senderId: json['senderId'] ?? '', // Add null checks
      recipientId: json['recipientId'] ?? '', // Add null checks
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ??
          DateTime.now(), // Add null checks and default value
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'senderId': senderId,
      'recipientId': recipientId,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }

  Notification copyWith({
    String? id,
    String? type,
    String? content,
    String? senderId,
    String? recipientId,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() {
    return 'Notification{id: $id, type: $type, content: $content, senderId: $senderId, recipientId: $recipientId, timestamp: $timestamp, isRead: $isRead}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Notification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          content == other.content &&
          senderId == other.senderId &&
          recipientId == other.recipientId &&
          timestamp == other.timestamp &&
          isRead == other.isRead;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      content.hashCode ^
      senderId.hashCode ^
      recipientId.hashCode ^
      timestamp.hashCode ^
      isRead.hashCode;
}
