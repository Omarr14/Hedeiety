import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class AddFriendsScreen extends StatefulWidget {
  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> availableFriends = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAvailableFriends();
  }

  Future<void> loadAvailableFriends() async {
    setState(() => isLoading = true);
    final friends = await _firebaseService.fetchAvailableFriends();
    setState(() {
      availableFriends = friends;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Friends"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: availableFriends.length,
              itemBuilder: (ctx, index) {
                final friend = availableFriends[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friend['image_url']),
                  ),
                  title: Text(friend['username']),
                  trailing: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () async {
                      await _firebaseService.addFriend(friend['id']);
                      loadAvailableFriends();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "${friend['username']} added as a friend!")),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
