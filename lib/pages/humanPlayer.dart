import 'package:flutter/material.dart';

class HumanPlayer extends StatefulWidget {
  final bool isBlue;
  final List<int> humanPlayerList;
  final Function setHumanPlayerList;

  const HumanPlayer(
      {super.key,
      required this.isBlue,
      required this.humanPlayerList,
      required this.setHumanPlayerList});

  @override
  _HumanPlayerState createState() => _HumanPlayerState();
}

class _HumanPlayerState extends State<HumanPlayer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding:
                EdgeInsets.only(top: 1.0), // Adjust the top padding as needed
            child: Text(
              'Scoring Table',
              style: TextStyle(
                fontSize: 18, // You can adjust the font size as needed
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onButtonPressed(widget.isBlue ? 1 : 3);
                    },
                    child: Text(widget.isBlue ? '1' : '3'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.humanPlayerList.contains(widget.isBlue ? 1 : 3)
                              ? Colors.green
                              : null,
                    ),
                  ),
                  if (widget.isBlue) const SizedBox(width: 10),
                  if (widget.isBlue)
                    ElevatedButton(
                      onPressed: () {
                        onButtonPressed(2);
                      },
                      child: const Text('2'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.humanPlayerList.contains(2)
                            ? Colors.green
                            : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onButtonPressed(widget.isBlue ? 3 : 1);
                    },
                    child: Text(widget.isBlue ? '3' : '1'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.humanPlayerList.contains(widget.isBlue ? 3 : 1)
                              ? Colors.green
                              : null,
                    ),
                  ),
                  if (!widget.isBlue) const SizedBox(width: 10),
                  if (!widget.isBlue)
                    ElevatedButton(
                      onPressed: () {
                        onButtonPressed(2);
                      },
                      child: const Text('2'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.humanPlayerList.contains(2)
                            ? Colors.green
                            : null,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onButtonPressed(int buttonNumber) {
    if (widget.humanPlayerList.contains(buttonNumber)) {
      widget.humanPlayerList.remove(buttonNumber);
      widget.setHumanPlayerList(widget.humanPlayerList);
    } else {
      widget.humanPlayerList.add(buttonNumber);
      widget.setHumanPlayerList(widget.humanPlayerList);
    }
  }
}
