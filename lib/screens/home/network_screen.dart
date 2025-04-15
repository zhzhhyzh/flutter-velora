import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../widgets/connection_card.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  _NetworkScreenState createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  List<UserModel> _users = [];
  List<String> _currentUserConnections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUserId = _authService.currentUser?.uid;
      if (currentUserId != null) {
        // Get current user's connections
        final currentUser = await _databaseService.getUserById(currentUserId);
        if (currentUser != null) {
          _currentUserConnections = currentUser.connections;
        }

        // Fetch all users (in a real app, you'd want to paginate this)
        final snapshot = await _databaseService.usersRef.get();
        final users = snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
            .where((user) => user.uid != currentUserId)
            .toList();

        setState(() {
          _users = users;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading users: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addConnection(String userId) async {
    final currentUserId = _authService.currentUser?.uid;
    if (currentUserId != null) {
      try {
        await _databaseService.addConnection(currentUserId, userId);
        setState(() {
          _currentUserConnections.add(userId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection added')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding connection: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _removeConnection(String userId) async {
    final currentUserId = _authService.currentUser?.uid;
    if (currentUserId != null) {
      try {
        await _databaseService.removeConnection(currentUserId, userId);
        setState(() {
          _currentUserConnections.remove(userId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection removed')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing connection: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Connections Count
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'My Connections (${_currentUserConnections.length})',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // People you may know
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'People you may know',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),

        // Users List
        Expanded(
          child: _users.isEmpty
              ? Center(child: Text('No users found'))
              : ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              final isConnected = _currentUserConnections.contains(user.uid);

              return ConnectionCard(
                user: user,
                isConnected: isConnected,
                onConnect: () => _addConnection(user.uid),
                onDisconnect: () => _removeConnection(user.uid),
              );
            },
          ),
        ),
      ],
    );
  }
}
