// return Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Container(
//                padding: EdgeInsets.all(15),
//                margin: EdgeInsets.only(bottom: 10),
//                decoration: BoxDecoration(
//                    color: Color(0xff063645),
//                    borderRadius: BorderRadius.all(Radius.circular(10)),
//                    border: Border.all(color: Color(0xffffffff))),
//                child:
//                    Text('Verify and pay \$5 to Ashwat', textScaleFactor: 2)),
//            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//              _roundedButton('Paypal'),
//              _roundedButton('Google Pay'),
//              _roundedButton('Apple Pay'),
//            ]),
//          ]);

//return Container(
//              height: 200,
//              color: Colors.amber,
//              child: Center(
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  mainAxisSize: MainAxisSize.min,
//                  children:  [
//                    const Text('BottomSheet'),
//                    RaisedButton(
//                      child: const Text('Close BottomSheet'),
//                      onPressed: () => Navigator.pop(context),
//                    )
//                  ],
//                ),
//              ),
//            );

import 'package:flutter/material.dart';

class PaymentBottomSheet extends StatelessWidget {
  PaymentBottomSheet({Key key, this.toUID, this.fromUID, this.dollarAmount})
      : super(key: key);
  final String toUID, fromUID;
  final double dollarAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 170,
        color: Colors.grey[800],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              FittedBox(
                  child: Text("Paying $toUID",
                      style: TextStyle(fontFamily: 'Righteous', fontSize: 22))),
              Divider(color: Theme.of(context).accentColor),
              Text("\$$dollarAmount",
                  style: TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 36,
                      fontFamily: 'Righteous',
                      fontWeight: FontWeight.bold)),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                          borderSide: BorderSide(color: Colors.red),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Deny")),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          color: Colors.green,
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Confirm")),
                    ),
                  )
                ],
              )
            ]),
          ),
        ));
  }
}
