import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//TODO: progress -> ['posted', 'accepted', 'found', 'payed']
enum ContractProgress { posted, accepted, found, payed }

class ContractCard extends StatelessWidget {
  ContractCard(
      {Key key,
      this.money,
      this.geopoint,
      this.item,
      this.username,
      this.progress,
      this.contractID,
      this.onPressed})
      : super(key: key);
  final double money;
  final GeoPoint geopoint;
  final String item;
  final String username;
  final ContractProgress progress;
  final String contractID;
  final Function onPressed;

  Color _getProgressColor() {
    switch (this.progress) {
      case ContractProgress.posted:
        return Colors.redAccent;
        break;
      case ContractProgress.accepted:
        return Colors.orange;
        break;
      case ContractProgress.found:
        return Colors.green;
        break;
      case ContractProgress.payed:
        return Colors.blue[900];
        break;
    }
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _getProgressColor()),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: FlatButton(
        onPressed: onPressed,
        child: Column(
          children: <Widget>[
            ListTile(
                title: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('\$$money', textScaleFactor: 2)),
                leading: Icon(Icons.attach_money, color: Colors.blue[500])),
            ListTile(
                title: Text('${geopoint.latitude}'),
                subtitle: Text('${geopoint.longitude}'),
                leading: Icon(Icons.location_on, color: Colors.blue[500])),
            ListTile(
                title: Text('$item'),
                leading: Icon(Icons.info, color: Colors.blue[500])),
            ListTile(
              title: Text('$username'),
              leading: Icon(Icons.contact_mail, color: Colors.blue[500]),
            ),
            ListTile(
              title: Text('ContractID: $contractID'),
              dense: true,
            )
          ],
        ),
      ),
    );
  }
}
