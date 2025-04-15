import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();

  FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PostModel>>(
      stream: _databaseService.getFeedPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading feed'));
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return Center(child: Text('No posts yet. Be the first to post!'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(
              post: post,
              currentUserId: _authService.currentUser?.uid ?? '',
              onLike: () {
                _likePost(post.id);
              },
              onUnlike: () {
                _unlikePost(post.id);
              },
              onComment: (comment) {
                _addComment(post.id, comment);
              },
            );
          },
        );
      },
    );
  }

  void _likePost(String postId) {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _databaseService.likePost(postId, userId);
    }
  }

  void _unlikePost(String postId) {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _databaseService.unlikePost(postId, userId);
    }
  }

  void _addComment(String postId, String content) {
    final user = _authService.currentUser;
    if (user != null) {
      _databaseService.addComment(
        postId,
        Comment(
          userId: user.uid,
          userName: user.displayName ?? 'User',
          content: content,
          timestamp: DateTime.now(),
        ),
      );
    }
  }
}