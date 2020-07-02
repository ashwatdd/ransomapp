import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ransomapp/contract_card.dart';

class CreateContractPageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ransom Contract',
            style: TextStyle(fontFamily: 'Righteous')),
      ),
      body: Center(
          child: Container(
              padding: EdgeInsets.all(20),
              height: 500,
              alignment: Alignment.center,
              child: CreateContractForm())),
    );
  }
}

class CreateContractForm extends StatefulWidget {
  @override
  _CreateContractFormState createState() => _CreateContractFormState();
}

class _CreateContractFormState extends State<CreateContractForm> {
  final _formKey = GlobalKey<FormState>();
  String _item, _money;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Ransom an Item",
                style: TextStyle(fontSize: 30, fontFamily: 'Righteous')),
            TextFormFieldPadded(
                labelText: 'Lost Item',
                onSaved: (value) => _item = value.toString().trim()),
            TextFormFieldPadded(
                labelText: 'Money \$',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => _money = value.toString().trim()),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.all(12),
              child: Text('Post the Contract'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  try {
                    final _firebaseUser =
                        await FirebaseAuth.instance.currentUser();
                    Firestore.instance.collection('contracts').add({
                      'loseruid': _firebaseUser.uid,
                      'finderuid': null,
                      'progress': ContractProgress.posted.index,
                      'item': _item,
                      'money': double.parse(_money),
                      'location': GeoPoint(0, 0)
                    });
                  } catch (e) {
                    print(e);
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TextFormFieldPadded extends StatelessWidget {
  TextFormFieldPadded({this.labelText, this.onSaved, this.keyboardType});

  final String labelText;
  final Function onSaved;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: (value) {
          if (value.isEmpty || value == null) {
            return 'Please enter some text';
          }
          if (this.labelText == 'Money \$') {
            if (double.tryParse(value) == null) {
              return 'Please enter a dollar amount';
            }
          }
          return null;
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          labelText: labelText,
          fillColor: Color(0xff063645),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xffffffff)),
          ),
        ),
      ),
    );
  }
}
