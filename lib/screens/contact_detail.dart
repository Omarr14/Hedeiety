import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For json.encode and json.decode

class ContactDetailScreen extends StatefulWidget {
  final String name;
  final String imagePath;
  final String phone;
  final List<String> events = [
    'Wedding Party',
    'Birthday Celebration',
    'Christmas Event',
    'New Year Party',
    'Graduation Ceremony',
  ]; // List of events to show

  ContactDetailScreen({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.phone,
  }) : super(key: key);

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  Map<String, String> _pledgedStatus =
      {}; // Use String to store colors and status
  bool _showJsonAnimation =
      false; // State variable to control animation visibility

  @override
  void initState() {
    super.initState();
    _loadPledgedStatus();
    // Set "Birthday Celebration" to initially red
    _pledgedStatus['Birthday Celebration'] = 'pledged';
  }

  Future<void> _loadPledgedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStatusString = prefs.getString('${widget.name}_pledgedStatus');
    if (savedStatusString != null) {
      final Map<String, String> savedStatus =
          Map<String, String>.from(json.decode(savedStatusString));
      setState(() {
        _pledgedStatus = savedStatus;
      });
    }
  }

  Future<void> _savePledgedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStatusString = json.encode(_pledgedStatus);
    await prefs.setString('${widget.name}_pledgedStatus', savedStatusString);
  }

  void _pledgeGift(String event) {
    setState(() {
      _pledgedStatus[event] = 'pledged';
      _showJsonAnimation = true; // Show JSON animation when pledging
    });
    _savePledgedStatus();
  }

  void _unpledgeGift(String event) {
    setState(() {
      _pledgedStatus[event] = 'unpledged';
      _showJsonAnimation = false; // Hide JSON animation when unpledging
    });
    _savePledgedStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red[100]!,
              Colors.red[50]!,
              Colors.white
            ], // Gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: widget.imagePath.startsWith('assets/')
                    ? AssetImage(widget.imagePath) as ImageProvider
                    : FileImage(File(widget.imagePath)),
              ),
              SizedBox(height: 20),
              Text(
                widget.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.phone,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                'Events',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.events.length,
                  itemBuilder: (ctx, index) {
                    String event = widget.events[index];
                    String status = _pledgedStatus[event] ?? 'unpledged';

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: status == 'pledged' ? Colors.red : Colors.grey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event,
                            style: TextStyle(color: Colors.black),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: status == 'unpledged'
                                    ? () {
                                        _pledgeGift(event);
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: status == 'pledged'
                                    ? () {
                                        _unpledgeGift(event);
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_showJsonAnimation)
                Container(
                    // Display JSON animation here
                    // child: Image.asset('assets/animation/pledge.json'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
