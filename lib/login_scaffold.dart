import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ransomapp/firebase_auth_model.dart';

class LoginScaffold extends StatelessWidget {
  LoginScaffold({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('Ransom - Login', style: TextStyle(fontFamily: 'Righteous')),
          centerTitle: true,
          leading: IconButton(
              icon: Image.asset('assets/ransom_logo.png'),
              onPressed: () {
                try {
                  Provider.of<AuthModel>(context, listen: false).signOut();
                } catch (e) {
                  print(e);
                }
              }),
        ),
        body: Center(
          child: Container(
            height: 340.0,
            child: LoginForm(),
          ),
        ));
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _email, _password;

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
            TextFormFieldPadded(
                type: 'email',
                labelText: 'Username or Email',
                onSaved: (value) => _email = value.toString().trim()),
            TextFormFieldPadded(
                type: 'password',
                labelText: 'Password',
                onSaved: (value) => _password = value.toString().trim()),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text('Log In'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  try {
                    Provider.of<AuthModel>(context, listen: false)
                        .signInWithEmailAndPassword(_email, _password);
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text('Sign Up'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  try {
                    Provider.of<AuthModel>(context, listen: false)
                        .createUserWithEmailAndPassword(_email, _password);
                  } catch (e) {
                    print(e);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class TextFormFieldPadded extends StatelessWidget {
  TextFormFieldPadded({this.type, this.labelText, this.onSaved});

  final String type;
  final String labelText;
  final Function onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        onSaved: onSaved,
        validator: (value) {
          if (type == 'user') {
//            TODO: Validate Email
          } else if (type == 'password') {
//            TODO: Validate Password
          }
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        obscureText: type == 'password' ? true : false,
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
