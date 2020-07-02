import 'package:flutter/material.dart';

class CenteredCircleProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator()))));
  }
}
