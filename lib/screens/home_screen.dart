import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:major_task/screens/contact_detail.dart';
import 'package:major_task/screens/loading2.dart';
import 'package:major_task/screens/loading_screen.dart';
import 'package:major_task/screens/profile_screen.dart'; // Adjust the import path as necessary
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> friends = [
    {'name': 'Joey', 'image': 'assets/images/Joe.png', 'phone': '01234567890'},
    {
      'name': 'Khaled',
      'image': 'assets/images/khaled.jpg',
      'phone': '01123456789'
    },
    {'name': 'Luda', 'image': 'assets/images/luda.jpg', 'phone': '01012345678'},
  ];

  void _showAddFriendDialog() {
    final _formKey = GlobalKey<FormState>();
    String? _friendName;
    String? _friendPhone;
    File? _friendImage;

    void _pickImage() async {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _friendImage = File(pickedImage.path);
        });
      }
    }

    void _addFriend() {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      _formKey.currentState!.save();

      if (_friendImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image!')),
        );
        return;
      }

      setState(() {
        friends.add({
          'name': _friendName,
          'phone': _friendPhone,
          'image': _friendImage!.path,
        });
      });

      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Friend'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _friendName = value;
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length != 11 ||
                          !RegExp(r'^\d+$').hasMatch(value)) {
                        return 'Please enter a valid 11-digit phone number.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _friendPhone = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addFriend,
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Friends',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: _logout,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoadingScreen(),
              ));
              await Future.delayed(const Duration(seconds: 2));
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
          IconButton(
            onPressed: _showAddFriendDialog,
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFCDD2), // Light red at the top
              Color(0xFFFFFFFF), // White at the bottom
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (ctx, index) {
                  final friend = friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: friend['image'].startsWith('assets/')
                          ? AssetImage(friend['image']) as ImageProvider
                          : FileImage(File(friend['image'])),
                    ),
                    title: Text(friend['name']),
                    subtitle: Text(friend['phone']),
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoadingScreen2(),
                      ));
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ContactDetailScreen(
                            name: friend['name'],
                            imagePath: friend['image'],
                            phone: friend['phone'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Lottie.asset(
              'assets/animation/santa_edition.json',
              repeat: true,
              reverse: false,
              animate: true,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}
