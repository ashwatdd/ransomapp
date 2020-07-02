import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ransomapp/contract_card.dart';
import 'package:ransomapp/payment_bottom_sheet.dart';
import 'package:ransomapp/ui_utils/center_circle_progress.dart';

class ContractPageRoute extends StatelessWidget {
  ContractPageRoute({Key key, this.contractID, this.currentUserUID})
      : super(key: key);
  final String contractID;
  final String currentUserUID;

  Widget _buildPageFromSnapshot(
    BuildContext context,
    AsyncSnapshot<DocumentSnapshot> snapshot,
  ) {
    if (!snapshot.hasData || !snapshot.data.exists)
      return CenteredCircleProgress();
    return Column(
      children: <Widget>[
        ContractCard(
          contractID: snapshot.data.documentID,
          username: snapshot.data['loseruid'],
          item: snapshot.data['item'],
          money: snapshot.data['money'].toDouble(),
          geopoint: snapshot.data['location'],
          progress: ContractProgress.values[snapshot.data['progress']],
        ),
        ImageBar(),
        ChangingButtonBar(
            snapshot: snapshot.data, currentUserUID: currentUserUID)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Viewing Contract', style: TextStyle(fontFamily: 'Righteous')),
      ),
      body: Center(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              alignment: Alignment.center,
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('contracts')
                      .document(contractID)
                      .snapshots(),
                  builder: _buildPageFromSnapshot))),
    );
  }
}

class ChangingButtonBar extends StatelessWidget {
  ChangingButtonBar({Key key, this.snapshot, this.currentUserUID})
      : super(key: key);
  final DocumentSnapshot snapshot;
  final String currentUserUID;

  void _deleteContract() {
    Firestore.instance
        .collection('contracts')
        .document(snapshot.documentID)
        .delete();
  }

  void _paymentFlow(BuildContext context) async {
    bool success = await showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) => PaymentBottomSheet(
            toUID: snapshot.data['finderuid'],
            fromUID: currentUserUID,
            dollarAmount: snapshot.data['money'].toDouble()));
    if (success) {
      Firestore.instance
          .collection('contracts')
          .document(snapshot.documentID)
          .setData({'progress': ContractProgress.payed.index}, merge: true);
    }
  }

  void _acceptContract() {
    Firestore.instance
        .collection('contracts')
        .document(snapshot.documentID)
        .setData({
      'finderuid': currentUserUID,
      'progress': ContractProgress.accepted.index
    }, merge: true);
  }

  void _releaseContract() {
    Firestore.instance
        .collection('contracts')
        .document(snapshot.documentID)
        .setData({'finderuid': null, 'progress': ContractProgress.posted.index},
            merge: true);
  }

  void _foundItem() {
    Firestore.instance
        .collection('contracts')
        .document(snapshot.documentID)
        .setData({'progress': ContractProgress.found.index}, merge: true);
  }

  void _cancelFoundItem() {
    Firestore.instance
        .collection('contracts')
        .document(snapshot.documentID)
        .setData({'progress': ContractProgress.accepted.index}, merge: true);
  }

  List<Widget> _buildButtonbar(
      BuildContext context, ContractProgress progress) {
    if (snapshot.data['loseruid'] == currentUserUID) {
      //TODO: Loser: {'posted': Cancel (delete document), 'accepted': Cancel, 'found': Pay (trigger paymentflow) }
      if (progress == ContractProgress.posted) {
        return <Widget>[
          RaisedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteContract();
              },
              child: Text("Delete Contract"))
        ];
      } else if (progress == ContractProgress.accepted) {
        return <Widget>[
          FlatButton(onPressed: _deleteContract, child: Text("Delete Contract"))
        ];
      } else if (progress == ContractProgress.found) {
        return <Widget>[
          RaisedButton(
              onPressed: () => _paymentFlow(context),
              child: Text("Accept and Pay Finder"))
        ];
      }
    } else if (snapshot.data['finderuid'] == currentUserUID) {
      //TODO: Finder: {'accepted': ReleaseContract(nullify finderuid)/Found, 'found': NotFound}
      if (progress == ContractProgress.accepted) {
        return <Widget>[
          FlatButton(
              onPressed: _releaseContract, child: Text("Release Contract")),
          RaisedButton(onPressed: _foundItem, child: Text("Found It"))
        ];
      } else if (progress == ContractProgress.found) {
        return <Widget>[
          RaisedButton(onPressed: _cancelFoundItem, child: Text("Didn't Find"))
        ];
      }
    } else if (snapshot.data['finderuid'] == null) {
      //TODO: Finder: {'posted': Accept (add finderuid)}
      return <Widget>[
        RaisedButton(onPressed: _acceptContract, child: Text("Accept"))
      ];
    }
    return [Text("Debug Build")];
  }

  @override
  Widget build(BuildContext context) {
    final progress = ContractProgress.values[snapshot.data['progress']];

    return ButtonBar(children: _buildButtonbar(context, progress));
  }
}

class ImageBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Image.network(
              'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.31Ldyuyf9ImRYEY0UeNP_wHaFc%26pid%3DApi&f=1'),
          Image.network(
              'https://www.elprocus.com/wp-content/uploads/Featured-image-2.png'),
        ],
      ),
    );
  }
}
