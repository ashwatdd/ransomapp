import 'package:flutter/material.dart';
import 'package:ransomapp/notification_card.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('Notifications',
                    style: TextStyle(fontSize: 30, fontFamily: 'Righteous')),
              )),
          NotificationLiveView()
        ]);
  }
}

class NotificationLiveView extends StatefulWidget {
  @override
  _NotificationLiveViewState createState() => _NotificationLiveViewState();
}

class _NotificationLiveViewState extends State<NotificationLiveView> {
  List<NotificationCard> _notifications = [
    NotificationCard(title: 'Ashwat is finding wallet', iconname: Icons.info),
    NotificationCard(
        title: 'Ashwat has found wallet',
        iconname: Icons.notification_important,
        subtitle: 'Click to Verify')
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: _notifications,
      ),
    );
  }
}
// style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
