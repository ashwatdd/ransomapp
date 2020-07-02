import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ransomapp/contract_card.dart';
import 'package:ransomapp/contract_page_route.dart';
import 'package:ransomapp/firebase_auth_model.dart';
import 'package:ransomapp/ui_utils/center_circle_progress.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('Feed',
                    style: TextStyle(fontSize: 30, fontFamily: 'Righteous')),
              )),
          //TODO: Create a Google Maps API (Places API) Integration
          FeedLiveView()
        ]);
  }
}

class FeedLiveView extends StatelessWidget {
  Widget _buildListViewFromSnapshot(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot,
  ) {
    if (!snapshot.hasData) return CenteredCircleProgress();
    return Consumer<AuthModel>(builder: (_, AuthModel authModel, __) {
      return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot contract = snapshot.data.documents[index];

            // IMPORTANT to remove where contract is created by yourself
            // Firebase does not provide inequality in .where()

            if (contract['loseruid'] == authModel.currentUser.uid) return null;
            return ContractCard(
                contractID: contract.documentID,
                username: contract['loseruid'],
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('contracts')
              .where('finderuid', isNull: true)
              .snapshots(),
          builder: _buildListViewFromSnapshot),
    );
  }
}
