import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ransomapp/firebase_auth_model.dart';
import 'package:ransomapp/login_scaffold.dart';
import 'package:ransomapp/main_scaffold.dart';

void main() => runApp(MyApp());
//TODO: Go through and wrap every Firestore.instance call with try/catch

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => AuthModel(),
          child: MaterialHome(),
        ),
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.purple[900],
            accentColor: Colors.cyan[600],
            scaffoldBackgroundColor: Colors.blueGrey[900]));
  }
}

class MaterialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: (context, AuthModel authModel, _) {
      if (authModel.currentUser != null) {
        return MainScaffold();
      } else {
        return LoginScaffold();
      }
    });
  }
}
