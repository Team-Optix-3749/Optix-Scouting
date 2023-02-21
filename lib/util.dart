import 'package:flutter/material.dart';

mixin Util on StatefulWidget {
  static Widget buildPopupDialog(
      BuildContext context, String title, List<Widget> text) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(8),
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: text,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  static Widget buildPitPopupDialog(BuildContext context, String title,
      List<Widget> text, VoidCallback onPressed) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(8),
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: text,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onPressed();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
