import 'package:flutter/material.dart';

class NoteMapping extends StatefulWidget {
  @override
  _NoteMappingState createState() => _NoteMappingState();
}

class _NoteMappingState extends State<NoteMapping> {
  List<int> leftNotes = [];
  List<int> rightNotes = [];
  bool isRightSide = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16.0), // Adjust the top padding as needed
          child: Text(
            'Note Scoring',
            style: TextStyle(
              fontSize: 24, // You can adjust the font size as needed
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Left side'),
                buildButtons([1], leftNotes),
                buildButtons([2], leftNotes),
                buildButtons([3], leftNotes),
                buildButtons([if (!isRightSide) 4], leftNotes),
                buildButtons([if (!isRightSide) 5], leftNotes)
              ],
            ),
            Switch(
              value: isRightSide,
              onChanged: (value) {
                setState(() {
                  isRightSide = value;
                });
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Right side'),
                buildButtons([1], rightNotes),
                buildButtons([2], rightNotes),
                buildButtons([3], rightNotes),
                buildButtons([if (isRightSide) 4], rightNotes),
                buildButtons([if (isRightSide) 5], rightNotes)
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildButtons(List<int> numbers, List<int> notesList) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: numbers.map((number) {
        return ElevatedButton(
          onPressed: () {
            setState(() {
              if (isRightSide) {
                rightNotes.add(number);
              } else {
                leftNotes.add(number);
              }
            });
          },
          child: Text('$number'),
        );
      }).toList(),
    );
  }
}