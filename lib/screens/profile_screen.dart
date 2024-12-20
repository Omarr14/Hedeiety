import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:major_task/screens/loading2.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> myEvents = [
    {'title': 'Flutter Workshop', 'date': '2024-12-20', 'image': null},
    {'title': 'Team Meeting', 'date': '2024-12-21', 'image': null},
    {'title': 'Birthday Party', 'date': '2024-12-25', 'image': null},
  ];

  void _addEvent(String title, String date, XFile? image) {
    String? pepsiImage =
        title.contains('Pepsi') ? 'assets/images/pepsi.jpg' : null;

    setState(() {
      myEvents
          .add({'title': title, 'date': date, 'image': pepsiImage ?? image});
    });
  }

  void _deleteEvent(int index) {
    setState(() {
      myEvents.removeAt(index);
    });
  }

  void _modifyEvent(
      int index, String newTitle, String newDate, XFile? newImage) {
    String? pepsiImage =
        newTitle.contains('Pepsi') ? 'assets/images/pepsi.jpg' : null;

    setState(() {
      myEvents[index]['title'] = newTitle;
      myEvents[index]['date'] = newDate;
      myEvents[index]['image'] =
          pepsiImage; // Store the image path (null if not Pepsi)
    });
  }

  void _showAddEventDialog() {
    String title = '';
    String date = '';
    XFile? image;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add New Event'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Event Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Event Date'),
                onChanged: (value) {
                  date = value;
                },
              ),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  final picker = ImagePicker();
                  image = await picker.pickImage(source: ImageSource.gallery);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (title.isNotEmpty && date.isNotEmpty) {
                  // Show loading screen
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        LoadingScreen2(), // Custom loading screen
                  ));

                  // Simulate a delay for loading
                  await Future.delayed(const Duration(seconds: 2));

                  // Add the event
                  _addEvent(title, date, image);
                  Navigator.of(context).pop(); // Close the loading screen
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showModifyEventDialog(int index) {
    String newTitle = myEvents[index]['title'];
    String newDate = myEvents[index]['date'];
    XFile? newImage = myEvents[index]['image'];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Modify Event'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'New Event Title'),
                controller: TextEditingController(text: newTitle),
                onChanged: (value) {
                  newTitle = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'New Event Date'),
                controller: TextEditingController(text: newDate),
                onChanged: (value) {
                  newDate = value;
                },
              ),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  final picker = ImagePicker();
                  newImage =
                      await picker.pickImage(source: ImageSource.gallery);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newTitle.isNotEmpty && newDate.isNotEmpty) {
                  _modifyEvent(index, newTitle, newDate, newImage);
                  Navigator.of(ctx).pop();
                }
              },
              child: Text('Modify'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEventDialog,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/Omar.jpg'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Omar',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('omar@example.com'),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: myEvents.length,
              itemBuilder: (ctx, index) {
                final event = myEvents[index];
                return ListTile(
                  leading: event['image'] != null
                      ? Image.asset(
                          event['image'],
                          width: 40,
                          height: 40,
                        )
                      : const Icon(Icons.event),
                  title: Text(event['title']),
                  subtitle: Text('Date: ${event['date']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showModifyEventDialog(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteEvent(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
