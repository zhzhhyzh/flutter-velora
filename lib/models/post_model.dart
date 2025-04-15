import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImage;
  final String content;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userProfileImage = '',
    required this.content,
    required this.timestamp,
    this.likes = const [],
    this.comments = const [],
  });

  factory PostModel.fromMap(Map<String, dynamic> data) {
    return PostModel(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userProfileImage: data['userProfileImage'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(data['likes'] ?? []),
      comments: (data['comments'] as List)
          .map((comment) => Comment.fromMap(comment))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'content': content,
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
    };
  }
}

class Comment {
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
  });

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': timestamp,
    };
  }
}