import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ransomapp/contract_card.dart';
import 'package:ransomapp/contract_page_route.dart';
import 'package:ransomapp/firebase_auth_model.dart';
import 'package:ransomapp/ui_utils/center_circle_progress.dart';

class ListingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('Your Listings',
                    style: TextStyle(fontSize: 30, fontFamily: 'Righteous')),
              )),
          ListingsLiveView()
        ]);
  }
}

class ListingsLiveView extends StatelessWidget {
  Widget _buildListViewFromSnapshot(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, AuthModel authModel) {
    if (!snapshot.hasData) return CenteredCircleProgress();
    return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) {
          DocumentSnapshot contract = snapshot.data.documents[index];
          return ContractCard(
              contractID: contract.documentID,
              username: "You",
              item: contract['item'],
              money: contract['money'].toDouble(),
              geopoint: contract['location'],
              progress: ContractProgress.values[contract['progress']],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContractPageRoute(
                      contractID: contract.documentID,
                      currentUserUID: authModel.currentUser.uid,
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<AuthModel>(
        builder: (context, AuthModel authModel, _) => StreamBuilder(
            stream: Firestore.instance
                .collection('contracts')
                .where('loseruid', isEqualTo: authModel.currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) =>
                _buildListViewFromSnapshot(context, snapshot, authModel)),
      ),
    );
  }
}
