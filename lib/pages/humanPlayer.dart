import 'package:flutter/material.dart';

class HumanPlayer extends StatefulWidget {
  @override
  _HumanPlayerState createState() => _HumanPlayerState();
}

class _HumanPlayerState extends State<HumanPlayer> {
  
  List<int> humanPlayerLocation = [];
  int humanPlayerScore = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1.0), // Adjust the top padding as needed
            child: Text(
              'Human Player',
              style: TextStyle(
                fontSize: 18, // You can adjust the font size as needed
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  onButtonPressed(1);
                },
                child: const Text('1'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  onButtonPressed(2);
                },
                child: const Text('2'),
              ),
            ],
          ),
          const SizedBox(height:5),
          ElevatedButton(
            onPressed: () {
              onButtonPressed(3);
            },
            child: const Text('3'),
          ),
        ],
      ),
    );
  }

  void onButtonPressed(int buttonNumber) {
    setState(() {
      humanPlayerLocation.add(buttonNumber);
      humanPlayerScore += 432;
    });

    // Delay to see the updated score before buttons disappear (optional)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        // Reset the humanPlayerLocation and hide the buttons
        humanPlayerLocation.clear();
      });
    });
  }
}