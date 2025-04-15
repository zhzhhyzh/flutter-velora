import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/job_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users collection reference
  CollectionReference get usersRef => _db.collection('users');

  // Posts collection reference
  CollectionReference get postsRef => _db.collection('posts');

  // Jobs collection reference
  CollectionReference get jobsRef => _db.collection('jobs');

  // Create user
  Future<void> createUser(UserModel user) async {
    await usersRef.doc(user.uid).set(user.toMap());
  }

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    DocumentSnapshot doc = await usersRef.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    await usersRef.doc(user.uid).update(user.toMap());
  }

  // Add a connection
  Future<void> addConnection(String userId, String connectionId) async {
    await usersRef.doc(userId).update({
      'connections': FieldValue.arrayUnion([connectionId]),
    });
  }

  // Remove a connection
  Future<void> removeConnection(String userId, String connectionId) async {
    await usersRef.doc(userId).update({
      'connections': FieldValue.arrayRemove([connectionId]),
    });
  }

  // Create post
  Future<void> createPost(PostModel post) async {
    await postsRef.add(post.toMap());
  }

  // Get posts for feed
  Stream<List<PostModel>> getFeedPosts() {
    return postsRef
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PostModel.fromMap({
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    }))
        .toList());
  }

  // Like a post
  Future<void> likePost(String postId, String userId) async {
    await postsRef.doc(postId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  // Unlike a post
  Future<void> unlikePost(String postId, String userId) async {
    await postsRef.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  // Add comment to post
  Future<void> addComment(String postId, Comment comment) async {
    await postsRef.doc(postId).update({
      'comments': FieldValue.arrayUnion([comment.toMap()]),
    });
  }

  // Get jobs
  Stream<List<JobModel>> getJobs() {
    return jobsRef
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => JobModel.fromMap({
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    }))
        .toList());
  }
}
