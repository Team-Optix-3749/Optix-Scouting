import 'package:flutter/material.dart';

class NoteMapping extends StatefulWidget {
  @override
  _NoteMappingState createState() => _NoteMappingState();

  final List<int> leftNotes;
  final List<int> rightNotes;
  final Function setNoteMapping;

  const NoteMapping({super.key, required this.leftNotes, required this.rightNotes, required this.setNoteMapping});
}

class _NoteMappingState extends State<NoteMapping> {
<<<<<<< HEAD
  List<int> _leftNotes = [];
  List<int> _rightNotes = [];
=======
  List<int> threeNotes = [];
  List<int> fiveNotes = [];
>>>>>>> e6104a926e6dd7c98e6808e801336a4b1067d09f
  bool isRightSide = false;

  @override
  Widget build(BuildContext context) {
    List<int> leftNotes = [];
    List<int> rightNotes = [];

    if (isRightSide) {
      rightNotes = threeNotes;
      leftNotes = fiveNotes;
    } else {
      leftNotes = threeNotes;
      rightNotes = fiveNotes;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding:
              EdgeInsets.only(top: 16.0), // Adjust the top padding as needed
          child: Text(
            'Note Scoring ',
            style: TextStyle(
              fontSize: 18, // You can adjust the font size as needed
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
                buildButtons([1], _leftNotes),
                buildButtons([2], _leftNotes),
                buildButtons([3], _leftNotes),
                buildButtons([if (!isRightSide) 4], _leftNotes),
                buildButtons([if (!isRightSide) 5], _leftNotes)
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
                buildButtons([1], _rightNotes),
                buildButtons([2], _rightNotes),
                buildButtons([3], _rightNotes),
                buildButtons([if (isRightSide) 4], _rightNotes),
                buildButtons([if (isRightSide) 5], _rightNotes)
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
<<<<<<< HEAD
              if (isRightSide) {
                _rightNotes.add(number);
                widget.setNoteMapping(_leftNotes, _rightNotes);
              } else {
                _leftNotes.add(number);
                widget.setNoteMapping(_leftNotes, _rightNotes);
=======
              if (notesList.contains(number)) {
                notesList.remove(number);
              } else {
                notesList.add(number);
>>>>>>> e6104a926e6dd7c98e6808e801336a4b1067d09f
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: notesList.contains(number) ? Colors.green : null,
          ),
          child: Text('$number'),
        );
      }).toList(),
    );
  }
}
