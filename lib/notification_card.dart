import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard(
      {Key key, this.title, this.subtitle, this.iconname, this.interaction})
      : super(key: key);
  final String title;
  final String subtitle;
  final IconData iconname;
  final Function interaction;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: subtitle == null
            ? ListTile(
                title: Text(title),
                leading: Icon(iconname, color: Colors.blue[500]),
                onTap: interaction)
            : ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                leading: Icon(iconname, color: Colors.blue[500]),
                onTap: interaction));
  }
}
