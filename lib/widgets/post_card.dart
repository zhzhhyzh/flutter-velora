import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final PostModel post;
  final String currentUserId;
  final VoidCallback onLike;
  final VoidCallback onUnlike;
  final Function(String) onComment;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.onLike,
    required this.onUnlike,
    required this.onComment,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController _commentController = TextEditingController();
  bool _showComments = false;

  bool get _isLiked => widget.post.likes.contains(widget.currentUserId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: widget.post.userProfileImage.isNotEmpty
                  ? NetworkImage(widget.post.userProfileImage)
                  : null,
              child: widget.post.userProfileImage.isEmpty
                  ? Text(widget.post.userName[0])
                  : null,
            ),
            title: Text(
              widget.post.userName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(timeago.format(widget.post.timestamp)),
          ),

          // Post Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.post.content),
          ),

          // Like & Comment Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text('${widget.post.likes.length} likes'),
                Spacer(),
                if (widget.post.comments.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showComments = !_showComments;
                      });
                    },
                    child: Text(
                      '${widget.post.comments.length} comments',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
              ],
            ),
          ),

          // Divider
          Divider(),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                icon: Icon(
                  _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  color: _isLiked ? Theme.of(context).primaryColor : Colors.grey,
                ),
                label: Text(
                  'Like',
                  style: TextStyle(
                    color: _isLiked ? Theme.of(context).primaryColor : Colors.grey,
                  ),
                ),
                onPressed: _isLiked ? widget.onUnlike : widget.onLike,
              ),
              TextButton.icon(
                icon: Icon(Icons.comment_outlined, color: Colors.grey),
                label: Text('Comment', style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  setState(() {
                    _showComments = true;
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.share_outlined, color: Colors.grey),
                label: Text('Share', style: TextStyle(color: Colors.grey)),
                onPressed: () {},
              ),
            ],
          ),

          // Comments Section
          if (_showComments) ...[
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.post.comments.length,
                itemBuilder: (context, index) {
                  final comment = widget.post.comments[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      comment.userName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(comment.content),
                    trailing: Text(
                      timeago.format(comment.timestamp),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),

            // Add Comment
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        widget.onComment(_commentController.text);
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}