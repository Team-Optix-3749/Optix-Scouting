import 'package:flutter/material.dart';

class _NoteMapping extends StatefulWidget {
  @override
  _NoteMappingState createState() => _NoteMappingState();
}

class _NoteMappingState extends State<_NoteMapping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Mapping'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display your image here
            Image.asset(
              'assets/note-mapping.png',  // Replace with the path to your image
              height: 200, // Adjust the height as needed
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNotePoint(1),
                _buildNotePoint(2),
                _buildNotePoint(3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotePoint(int value) {
    return InkWell(
      onTap: () {
        _handleNotePointClick(value);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotePointClick(int value) {
    // You can perform any action based on the clicked value
    print('Clicked on point $value');
    // Modify this function to suit your needs
  }
}