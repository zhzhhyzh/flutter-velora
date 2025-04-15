import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  UserModel? _user;
  bool _isLoading = true;
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        final user = await _databaseService.getUserById(userId);
        setState(() {
          _user = user;
          if (user != null) {
            _nameController.text = user.name;
            _headlineController.text = user.headline;
            _aboutController.text = user.about;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null && _user != null) {
      try {
        setState(() {
          _isLoading = true;
        });

        final imageUrl = await _storageService.uploadProfileImage(
          _user!.uid,
          File(image.path),
        );

        // Update user with new image URL
        final updatedUser = UserModel(
          uid: _user!.uid,
          email: _user!.email,
          name: _user!.name,
          headline: _user!.headline,
          about: _user!.about,
          profileImageUrl: imageUrl,
          connections: _user!.connections,
        );

        await _databaseService.updateUser(updatedUser);
        setState(() {
          _user = updatedUser;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedUser = UserModel(
        uid: _user!.uid,
        email: _user!.email,
        name: _nameController.text,
        headline: _headlineController.text,
        about: _aboutController.text,
        profileImageUrl: _user!.profileImageUrl,
        connections: _user!.connections,
      );

      await _databaseService.updateUser(updatedUser);
      setState(() {
        _user = updatedUser;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_user == null) {
      return Center(child: Text('Error loading profile'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                // Cover Photo
                Container(
                  height: 120,
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),

                // Profile Picture and Info
                Transform.translate(
                  offset: Offset(0, -40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: _isEditing ? _pickImage : null,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: _user!.profileImageUrl.isNotEmpty
                                        ? NetworkImage(_user!.profileImageUrl)
                                        : null,
                                    child: _user!.profileImageUrl.isEmpty
                                        ? Icon(Icons.person, size: 50)
                                        : null,
                                  ),
                                  if (_isEditing)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 18,
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 16,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Spacer(),
                            if (!_isEditing)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                ),
                                child: Text('Edit Profile'),
                              )
                            else
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = false;
                                        _nameController.text = _user!.name;
                                        _headlineController.text = _user!.headline;
                                        _aboutController.text = _user!.about;
                                      });
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: _saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                    ),
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 16),
                        if (_isEditing)
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          )
                        else
                          Text(
                            _user!.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        SizedBox(height: 8),
                        if (_isEditing)
                          TextField(
                            controller: _headlineController,
                            decoration: InputDecoration(
                              labelText: 'Headline',
                              border: OutlineInputBorder(),
                            ),
                          )
                        else
                          Text(
                            _user!.headline.isNotEmpty
                                ? _user!.headline
                                : 'Add a headline',
                            style: TextStyle(
                              fontSize: 16,
                              color: _user!.headline.isNotEmpty
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // About Section
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (_isEditing)
                    TextField(
                      controller: _aboutController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'About',
                        border: OutlineInputBorder(),
                      ),
                    )
                  else
                    Text(
                      _user!.about.isNotEmpty
                          ? _user!.about
                          : 'Add information about yourself',
                      style: TextStyle(
                        color: _user!.about.isNotEmpty
                            ? Colors.black87
                            : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Connections Section
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Connections',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_user!.connections.length}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    _user!.connections.isEmpty
                        ? 'Start building your network'
                        : 'Grow your network by connecting with more professionals',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to network tab
                      // This would typically be done by updating the
                      // _currentIndex in HomeScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text('Find Connections'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _aboutController.dispose();
    super.dispose();
  }
}