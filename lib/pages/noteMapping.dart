import 'package:flutter/material.dart';

class NoteMapping extends StatefulWidget {
  @override
  _NoteMappingState createState() => _NoteMappingState();

  final List<int> threeNotes;
  final List<int> fiveNotes;
  final Function setThreeNotes;
  final Function setFiveNotes;
  final bool isRightSide;

  const NoteMapping({super.key, required this.threeNotes, required this.fiveNotes, required this.setThreeNotes, required this.setFiveNotes, required this.isRightSide});
}

class _NoteMappingState extends State<NoteMapping> {

  @override
  Widget build(BuildContext context) {
    bool isRightSide = widget.isRightSide;
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
                for (int i=1; i<=((!isRightSide)?5:3); i++) buildButtons([i], (!isRightSide) ? widget.fiveNotes : widget.threeNotes,  (!isRightSide) ? widget.setFiveNotes : widget.setThreeNotes),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Right side'),
                for (int i=1; i<=((isRightSide)?5:3); i++) buildButtons([i], (isRightSide) ? widget.fiveNotes : widget.threeNotes,  (isRightSide) ? widget.setFiveNotes : widget.setThreeNotes),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildButtons(List<int> numbers, List<int> notesList, Function setNotesList) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: numbers.map((number) {
        return ElevatedButton(
          onPressed: () {
            setState(() {
              if (notesList.contains(number)) {
                notesList.remove(number);
                setNotesList(notesList);
              } else {
                notesList.add(number);
                setNotesList(notesList);
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
