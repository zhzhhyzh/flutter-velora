import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ConnectionCard extends StatelessWidget {
  final UserModel user;
  final bool isConnected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const ConnectionCard({
    Key? key,
    required this.user,
    required this.isConnected,
    required this.onConnect,
    required this.onDisconnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 30,
              backgroundImage: user.profileImageUrl.isNotEmpty
                  ? NetworkImage(user.profileImageUrl)
                  : null,
              child: user.profileImageUrl.isEmpty
                  ? Icon(Icons.person, size: 30)
                  : null,
            ),
            SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    user.headline.isNotEmpty
                        ? user.headline
                        : 'LinkedIn Member',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Connect Button
            if (isConnected)
              OutlinedButton(
                onPressed: onDisconnect,
                child: Text('Disconnect'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              )
            else
              ElevatedButton(
                onPressed: onConnect,
                child: Text('Connect'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}